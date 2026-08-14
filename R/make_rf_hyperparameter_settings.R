#Make list of parameter vectors for examination of results
make_rf_hyperparameter_settings <- function(mtry_parameters, nodesize_parameters, ntree_parameters){
  reference <- c(mtry_parameters["medium"], nodesize_parameters["medium"], ntree_parameters["medium"])
  mtry_low <- c(mtry_parameters["low"], nodesize_parameters["medium"], ntree_parameters["medium"])
  mtry_high <- c(mtry_parameters["high"], nodesize_parameters["medium"], ntree_parameters["medium"])
  nodesize_low <- c(mtry_parameters["medium"], nodesize_parameters["low"], ntree_parameters["medium"])
  nodesize_high <- c(mtry_parameters["medium"], nodesize_parameters["high"], ntree_parameters["medium"])
  ntree_low <- c(mtry_parameters["medium"], nodesize_parameters["medium"], ntree_parameters["low"])
  ntree_high <- c(mtry_parameters["medium"], nodesize_parameters["medium"], ntree_parameters["high"])
  rf_hyperparameter_settings <- list(reference, mtry_low, mtry_high, nodesize_low, nodesize_high, ntree_low, ntree_high)
  names(rf_hyperparameter_settings) <- c(
    "reference", "mtry_low", "mtry_high",
    "nodesize_low", "nodesize_high",
    "ntree_low", "ntree_high"
  )
  return(rf_hyperparameter_settings)
}