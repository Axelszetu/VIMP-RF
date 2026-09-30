#Function that, for a given combination of mtry, nodesize and ntree fits a rf model, and computes permutation-based variable importance, minimal depth, and ATE.
if(FALSE){
  setting <- reference
  setting[[3]] <- 5
}
compute_rf_vimps <- function(setting, simulated_data, covars = abnorm_cols,
                             model_covars = covar_no_age){
  #Fit with model_covars; report importance only for covars.
  validate_covars(covars, model_covars)
  mtry <- setting[[1]]
  nodesize <- setting[[2]]
  ntree <- setting[[3]]
  rf_model_bin <- fit_rf_model_bin(simulated_data = simulated_data, ntree = ntree, mtry = mtry, nodesize = nodesize, covars = model_covars)
  perm_vimp <- get_perm_vimp(rf_model_bin = rf_model_bin)
  minimal_depth_vimp <- get_minimal_depth_vimp(rf_model_bin = rf_model_bin)
  validate_covars(covars, names(perm_vimp))
  validate_covars(covars, names(minimal_depth_vimp))
  perm_vimp <- perm_vimp[covars]
  minimal_depth_vimp <- minimal_depth_vimp[covars]
  ATE_rf <- get_ATE_rf(rf_model_bin = rf_model_bin, simulated_data = simulated_data, covars = covars)
  rf_result_table_numeric <- list(perm = perm_vimp, md = minimal_depth_vimp, ATE = ATE_rf)
  out <- list(numeric = rf_result_table_numeric)
  return(out)
}
