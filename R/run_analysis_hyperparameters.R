#We implement a function to run the variations over RF hyperparameters at once: Simulate data, fit random forests and extract vimps for each parameter setting, as well as logreg model fit/parameter estimation/ATE calculation.
if (FALSE){
  rf_hyperparameter_settings <- make_rf_hyperparameter_settings(mtry_parameters = mtry_parameters, nodesize_parameters = nodesize_parameters, ntree_parameters = ntree_parameters)
  for (setting in rf_hyperparameter_settings){
    print(nameof(setting))
  }
}

run_analaysis_hyperparameters <- function(n, effects_first_order, effects_interactions, rf_hyperparameter_settings){
  simulated_data <- sim_OHCA_ECG_data(n = n, effects_first_order = effects_first_order, effects_interactions = effects_interactions)
  rf_results <- vector(mode = 'list', length = length(rf_hyperparameter_settings))
  names(rf_results) <- names(rf_hyperparameter_settings)
  
}