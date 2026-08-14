#We implement a function to run the variations over RF hyperparameters at once: Simulate data, fit random forests and extract vimps for each parameter setting, as well as logreg model fit/parameter estimation/ATE calculation.
if (FALSE){
  ntree_parameters <- c(3,5,20)
  names(ntree_parameters) <- parameter_sizes_names
  rf_hyperparameter_settings <- make_rf_hyperparameter_settings(mtry_parameters = mtry_parameters, nodesize_parameters = nodesize_parameters, ntree_parameters = ntree_parameters)
  for (setting in rf_hyperparameter_settings){
    print(nameof(setting))
  }
  system.time(run_analaysis_hyperparameters(n = 2000, effects_first_order = effects_first_order, effects_interactions = effects_interactions, rf_hyperparameter_settings))
}

run_analaysis_hyperparameters <- function(n, effects_first_order, effects_interactions, rf_hyperparameter_settings){
  simulated_data <- sim_OHCA_ECG_data(n = n, effects_first_order = effects_first_order, effects_interactions = effects_interactions)
  #rf_results <- vector(mode = 'list', length = length(rf_hyperparameter_settings))
  #names(rf_results) <- names(rf_hyperparameter_settings)
  rf_results <- lapply(
    rf_hyperparameter_settings,
    function(setting){
      compute_rf_vimps(
        setting = setting,
        simulated_data = simulated_data
      )
    }
  )
  logreg_model <- fit_logreg_model(simulated_data)
  ATE_logreg <- get_ATE_logreg(logreg_model, simulated_data)
  results <- rf_results
  results$logreg$ATE_logreg$numeric <- ATE_logreg
  results$logreg$ATE_logreg$rank <- rank(ATE_logreg)
  return(results)
}