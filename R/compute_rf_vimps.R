#Function that, for a given combination of mtry, nodesize and ntree fits a rf model, and computes permutation-based variable importance, minimal depth, and ATE.
if(FALSE){
  setting <- reference
  setting[[3]] <- 5
}
compute_rf_vimps <- function(setting, simulated_data){
  mtry <- setting[[1]]
  nodesize <- setting[[2]]
  ntree <- setting[[3]]
  rf_model_bin <- fit_rf_model_bin(simulated_data = simulated_data, ntree = ntree, mtry = mtry, nodesize = nodesize)
  perm_vimp <- get_perm_vimp(rf_model_bin = rf_model_bin)
  minimal_depth_vimp <- get_minimal_depth_vimp(rf_model_bin = rf_model_bin)
  ATE_rf <- get_ATE_rf(rf_model_bin = rf_model_bin, simulated_data = simulated_data)
  rf_result_table_numeric <- list(perm = perm_vimp, md = minimal_depth_vimp, ATE = ATE_rf)
  rf_result_table_rank <- list(perm = rank(-perm_vimp), md = rank(minimal_depth_vimp), ATE = rank(-abs(ATE_rf)))
  out <- list(numeric = rf_result_table_numeric, rank = rf_result_table_rank)
  return(out)
}
