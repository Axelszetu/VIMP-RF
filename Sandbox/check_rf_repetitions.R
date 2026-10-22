# Run with Rscript Sandbox/check_rf_repetitions.R, or source from the repository root.
library(randomForestSRC)
for (file in c("validate_covars", "fit_rf_model_bin", "get_perm_vimp",
               "get_minimal_depth_vimp", "get_ATE_rf", "run_rf_repetitions",
               "make_cumulative_rank_plots")) {
  source(file.path("R", paste0(file, ".R")))
}

local({
  # Limit only this smoke test's thread count; leave the caller's option intact.
  old_options <- options(rf.cores = 1)
  on.exit(options(old_options))
  expect_error <- function(expr) {
    stopifnot(inherits(tryCatch(expr, error = identity), "error"))
  }

  # Instrument fitting to verify fixed inputs, one fit per run, and selection
  # before ranking. The extra model covariate must not enter the rank universe.
  fixed_data <- data.frame(a = c(0, 1), b = c(1, 0), c = c(0, 1),
                           extra = c(1, 0), Y = factor(c(0, 1)))
  model_covars <- c("a", "b", "c", "extra")
  comparison <- c("c", "a", "b")
  fit_count <- 0L
  fit_rf_model_bin <- function(simulated_data, ntree, mtry, nodesize, covars) {
    stopifnot(identical(simulated_data, fixed_data), ntree == 40,
              mtry == 2, nodesize == 5, identical(covars, model_covars))
    fit_count <<- fit_count + 1L
    list(draw = runif(1))
  }
  draws <- numeric()
  get_perm_vimp <- function(forest) {
    draws <<- c(draws, forest$draw)
    c(b = 2, extra = 100, a = 2, c = -1)
  }
  get_minimal_depth_vimp <- function(forest) c(c = 3, a = 1, extra = 0, b = 1)
  get_ATE_rf <- function(forest, data, covars) c(b = 0.2, c = 0.1, a = -0.2)[covars]
  runner <- run_rf_repetitions
  environment(runner) <- environment()
  result <- runner(fixed_data, 3, 40, 2, 5, model_covars, comparison)
  stopifnot(fit_count == 3L, length(unique(draws)) == 3L, nrow(result) == 27L)
  for (measure in c("perm", "md", "ATE")) {
    x <- result[result$run == 1 & result$measure == measure, ]
    stopifnot(identical(x$variable, comparison), identical(x$rank, c(3, 1.5, 1.5)))
  }
  stopifnot(identical(subset(result, run == 1 & measure == "ATE")$score,
                      c(0.1, -0.2, 0.2)))
  get_minimal_depth_vimp <- function(forest) stop("Unrequested measure called.")
  get_ATE_rf <- function(...) stop("Unrequested measure called.")
  selected <- runner(fixed_data, 1, 40, 2, 5, model_covars, comparison, "perm")
  stopifnot(nrow(selected) == 3L, all(selected$measure == "perm"))
  get_perm_vimp <- function(forest) c(a = NA_real_, b = 1, c = 2)
  expect_error(runner(fixed_data, 1, 40, 2, 5, model_covars, comparison, "perm"))
  expect_error(runner(fixed_data, 0, 40, 2, 5, model_covars))

  # Known valid rankings: a/b exchange positions; c always has rank 3.
  fixture <- data.frame(run = rep(1:4, each = 3),
                        variable = rep(c("a", "b", "c"), 4), measure = "perm",
                        rank = c(1, 2, 3, 2, 1, 3, 1, 2, 3, 2, 1, 3))
  rng_before <- .Random.seed
  calculated <- make_cumulative_rank_plots(fixture[nrow(fixture):1, ])
  stopifnot(identical(rng_before, .Random.seed))
  a <- subset(calculated$summary, variable == "a")
  stopifnot(isTRUE(all.equal(a$mean_rank, c(1, 1.5, 4/3, 1.5))),
            is.na(a$lower[1]), is.na(a$upper[1]), is.na(a$mcse[1]))
  for (l in 2:4) {
    prefix <- c(1, 2, 1, 2)[seq_len(l)]
    se <- sd(prefix) / sqrt(l)
    stopifnot(isTRUE(all.equal(a$mcse[l], se)),
              isTRUE(all.equal(a$lower[l], mean(prefix) - qt(0.975, l - 1) * se)),
              isTRUE(all.equal(a$upper[l], mean(prefix) + qt(0.975, l - 1) * se)))
  }
  constant <- subset(calculated$summary, variable == "c" & l >= 2)
  stopifnot(all(constant$mcse == 0), all(constant$lower == 3), all(constant$upper == 3))
  expect_error(make_cumulative_rank_plots(fixture[-1, ]))
  expect_error(make_cumulative_rank_plots(rbind(fixture, fixture[1, ])))
  invalid <- fixture
  invalid$rank[1] <- Inf
  expect_error(make_cumulative_rank_plots(invalid))
  single <- make_cumulative_rank_plots(subset(fixture, run == 1))
  stopifnot(all(is.na(single$summary$lower)))
  invisible(ggplot2::ggplot_build(single$plots$perm))
  built <- ggplot2::ggplot_build(calculated$plots$perm)
  panel_a <- with(built$layout$layout, PANEL[variable == "a"])
  ribbon_a <- subset(built$data[[1]], PANEL == panel_a)
  line_a <- subset(built$data[[3]], PANEL == panel_a)
  stopifnot(inherits(calculated$plots$perm$layers[[1]]$geom, "GeomRibbon"),
            inherits(calculated$plots$perm$layers[[3]]$geom, "GeomLine"),
            isTRUE(all.equal(ribbon_a$ymin, a$lower[-1])),
            isTRUE(all.equal(line_a$y, a$mean_rank)))
  cat("PASS: fixed-input/ranking/measure-selection and cumulative-interval checks\n")
})

local({
  old_options <- options(rf.cores = 1)
  on.exit(options(old_options))
  set.seed(100)
  data <- data.frame(x1 = rbinom(300, 1, 0.5), x2 = rbinom(300, 1, 0.4),
                     x3 = rbinom(300, 1, 0.3))
  data$Y <- factor(rbinom(300, 1, plogis(-1 + data$x1)), levels = c(0, 1))
  original <- data
  set.seed(101)
  first <- run_rf_repetitions(data, 6, 40, 2, 5, c("x1", "x2", "x3"))
  set.seed(101)
  second <- run_rf_repetitions(data, 6, 40, 2, 5, c("x1", "x2", "x3"))
  stopifnot(identical(first, second), identical(data, original), nrow(first) == 54L,
            all(with(first, table(run, variable, measure)) == 1L),
            all(is.finite(first$score)), all(is.finite(first$rank)))
  plots <- make_cumulative_rank_plots(first)
  stopifnot(identical(names(plots$plots), c("perm", "md", "ATE")))
  for (measure in names(plots$plots)) {
    p <- plots$plots[[measure]]
    layout <- ggplot2::ggplot_build(p)$layout$layout
    stopifnot(identical(unique(p$data$measure), measure), nrow(layout) == 3L,
              setequal(layout$variable, c("x1", "x2", "x3")))
    path <- file.path(tempdir(), paste0("T001-", measure, ".png"))
    ggplot2::ggsave(path, p, width = 8, height = 5, dpi = 120)
    cat("Plot:", normalizePath(path, winslash = "/"), "\n")
  }
  print(with(first, table(run, measure)))
  print(subset(plots$summary, l == 6))
  cat("PASS: actual-forest smoke test; 6 runs, 3 variables, 3 measures; reproducible\n")
})
