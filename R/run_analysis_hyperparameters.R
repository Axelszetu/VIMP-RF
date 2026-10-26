#Fit all RF hyperparameter settings and logistic regression on one supplied dataset.
if (FALSE){
  ntree_parameters <- c(3,5,20)
  names(ntree_parameters) <- parameter_sizes_names
  rf_hyperparameter_settings <- make_rf_hyperparameter_settings(mtry_parameters = mtry_parameters, nodesize_parameters = nodesize_parameters, ntree_parameters = ntree_parameters)
  system.time(run_analysis_hyperparameters(data = simulated_data, rf_hyperparameter_settings = rf_hyperparameter_settings, covars = abnorm_cols, model_covars = covar_no_age))
}

run_analysis_hyperparameters <- function(data, rf_hyperparameter_settings,
                                        covars = abnorm_cols, model_covars = covar_no_age){
  #Both models use model_covars; covars selects the reported importance values.
  validate_covars(covars, model_covars)
  rf_results <- lapply(
    rf_hyperparameter_settings,
    function(setting){
      compute_rf_vimps(
        setting = setting,
        simulated_data = data,
        covars = covars,
        model_covars = model_covars
      )
    }
  )
  logreg_model <- fit_logreg_model(data, covars = model_covars)
  ATE_logreg <- get_ATE_logreg(logreg_model, data, covars = covars)
  results <- rf_results
  results$logreg$numeric$ATE_logreg <- ATE_logreg
  return(results)
}
