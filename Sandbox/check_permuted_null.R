# Run from the repository root: Rscript Sandbox/check_permuted_null.R
library(targets)
library(randomForestSRC)
tar_source("R")

local({
  old_options <- options(rf.cores = 1)
  on.exit(options(old_options))
  set.seed(3003)
  source_data <- data.table::data.table(
    a = rep(c(0, 1), 200), b = rep(c(0, 1), 200),
    background = rep(c(0, 0, 1, 1), 100),
    expected_outcome = rep(0.8, 400), Y = factor(rep(c(0, 1), 200))
  )
  original <- data.table::copy(source_data)
  d <- permute_ECG_null_data(source_data, covars = c("a", "b"))
  stopifnot(identical(source_data, original),
            identical(d$background, original$background),
            identical(names(d), names(original)), nrow(d) == nrow(original),
            all(d$expected_outcome == 0.5),
            identical(levels(d$Y), c("0", "1")),
            !identical(d$a, d$b), !identical(d$Y, original$Y))
  for (v in c("a", "b")) {
    stopifnot(identical(sort(d[[v]]), sort(original[[v]])))
  }
  set.seed(3003)
  stopifnot(identical(d, permute_ECG_null_data(source_data, c("a", "b"))))
  next_data <- permute_ECG_null_data(source_data, c("a", "b"))
  stopifnot(!identical(d$a, next_data$a), !identical(d$Y, next_data$Y))

  settings <- make_rf_hyperparameter_settings(
    c(low = 1, medium = 2, high = 3),
    c(low = 3, medium = 5, high = 10),
    c(low = 20, medium = 30, high = 40)
  )
  result <- run_permuted_null_hyperparameters(
    source_data, settings, covars = c("a", "b"),
    model_covars = c("a", "b", "background")
  )
  stopifnot(identical(source_data, original),
            identical(names(result), c(names(settings), "logreg")))
  for (setting in names(result)) {
    for (scores in result[[setting]]$numeric) {
      stopifnot(identical(names(scores), c("a", "b")), all(is.finite(scores)))
    }
  }
  cat("PASS: exact margins, input preservation, separate permutations, null outcome, reproducibility and model integration\n")
})

tar_validate()
manifest <- tar_manifest()
stopifnot(all(c("rf_hyperparameter_results_permuted_null",
                "rf_hyperparameter_results_tables_permuted_null") %in% manifest$name))
cat("PASS: targets pipeline validation and new target names\n")
