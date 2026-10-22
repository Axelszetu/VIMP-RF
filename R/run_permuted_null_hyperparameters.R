run_permuted_null_hyperparameters <- function(data, rf_hyperparameter_settings,
                                              covars = abnorm_cols,
                                              model_covars = covar_no_age) {
  # All settings in a repetition share one permutation and newly drawn outcome.
  simulated_data <- permute_ECG_null_data(data, covars = covars)
  results <- lapply(rf_hyperparameter_settings, function(setting) {
    compute_rf_vimps(setting = setting, simulated_data = simulated_data,
                     covars = covars, model_covars = model_covars)
  })
  logreg_model <- fit_logreg_model(simulated_data, covars = model_covars)
  results$logreg$numeric$ATE_logreg <-
    get_ATE_logreg(logreg_model, simulated_data, covars = covars)
  return(results)
}
