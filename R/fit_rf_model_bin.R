#Function for fitting random forest for binary classification
if(FALSE){
  tar_load(simulated_data)
  ntree = 10
  mtry = 5
  nodesize = NULL
}

fit_rf_model_bin <- function(simulated_data, ntree = 10, mtry = 5, nodesize = NULL){
  ff <- as.formula(paste("Y ~", paste(covar_no_age, collapse = "+")))
  model <- rfsrc(formula = ff, data = simulated_data, ntree = ntree, mtry = mtry, nodesize = nodesize, pref.type = 'brier')
  return(model)
}