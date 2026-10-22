# Run from the repository root. The example generates the dataset only once.
library(randomForestSRC)
for (file in c("validate_covars", "fit_rf_model_bin", "get_perm_vimp",
               "get_minimal_depth_vimp", "get_ATE_rf", "run_rf_repetitions",
               "make_cumulative_rank_plots")) {
  source(file.path("R", paste0(file, ".R")))
}

set.seed(100)
example_data <- data.frame(x1 = rbinom(300, 1, 0.5),
                           x2 = rbinom(300, 1, 0.4),
                           x3 = rbinom(300, 1, 0.3))
example_data$Y <- factor(rbinom(300, 1, plogis(-1 + example_data$x1)),
                         levels = c(0, 1))

# These small settings demonstrate the interface; they are not a choice of k
# or hyperparameters for a substantive analysis. No seed is reset within runs.
set.seed(101)
rf_runs <- run_rf_repetitions(example_data, k = 10, ntree = 50,
                              mtry = 2, nodesize = 5,
                              model_covars = c("x1", "x2", "x3"),
                              measures = c("perm", "md", "ATE"))
rank_plots <- make_cumulative_rank_plots(rf_runs)
print(head(rf_runs))
print(rank_plots$plots$perm)
# Other measures have separate figures: rank_plots$plots$md and rank_plots$plots$ATE.
# Each figure has one subplot per variable.
# rank_plots$summary contains l, mean_rank, mcse, lower, and upper by variable/measure.
# Save rf_runs with saveRDS() if needed; the plotting function only needs
# the run, variable, measure, and rank columns.
