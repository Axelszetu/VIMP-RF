# Refit on one fixed dataset; retain one score and rank per run/variable/measure.
# Y must be a factor with levels 0 and 1. Load randomForestSRC before calling.
run_rf_repetitions <- function(data, k, ntree, mtry, nodesize,
                               model_covars, rank_covars = model_covars,
                               measures = c("perm", "md", "ATE")) {
  if (length(k) != 1L || !is.finite(k) || k < 1 || k != floor(k)) {
    stop("k must be a positive integer.")
  }
  validate_covars(model_covars, setdiff(names(data), "Y"), "model_covars")
  validate_covars(rank_covars, model_covars, "rank_covars")
  validate_covars(measures, c("perm", "md", "ATE"), "measures")
  if (!is.factor(data$Y) || !setequal(levels(data$Y), c("0", "1")) ||
      anyNA(data$Y) || length(unique(data$Y)) != 2L) {
    stop("Y must be a factor with observed classes 0 and 1 and no missing values.")
  }
  if (any(vapply(model_covars, function(x) anyNA(data[[x]]), logical(1)))) {
    stop("Model covariates must not contain missing values.")
  }

  runs <- lapply(seq_len(k), function(run) {
    forest <- fit_rf_model_bin(data, ntree = ntree, mtry = mtry,
                               nodesize = nodesize, covars = model_covars)
    results <- lapply(measures, function(measure) {
      scores <- switch(measure,
        perm = get_perm_vimp(forest),
        md = get_minimal_depth_vimp(forest),
        ATE = get_ATE_rf(forest, data, covars = rank_covars)
      )[rank_covars]
      if (any(!is.finite(scores))) {
        stop("Nonfinite or missing ", measure, " scores in run ", run, ".")
      }
      # Rank only the comparison set; retain signs in the raw scores.
      ranking_scores <- switch(measure,
        perm = -scores, md = scores, ATE = -abs(scores)
      )
      data.frame(run = run, variable = rank_covars, measure = measure,
                 score = unname(scores),
                 rank = unname(rank(ranking_scores, ties.method = "average")))
    })
    do.call(rbind, results)
  })
  do.call(rbind, runs)
}
