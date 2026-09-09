get_rf_IPA <- function(rf_IPA_data, setting, covars){
  train <- rf_IPA_data[1:floor(nrow(rf_IPA_data)/2)]
  test <- rf_IPA_data[floor(nrow(rf_IPA_data)/2):nrow(rf_IPA_data)]
  mtry <- setting[[1]]
  nodesize <- setting[[2]]
  ntree <- setting[[3]]
  rf_model_bin <- fit_rf_model_bin(simulated_data = train, ntree = ntree, mtry = mtry, nodesize = nodesize, covars)
  ff <- as.formula(paste("Y ~", paste(covars, collapse = "+")))
  out <- riskRegression::Score(list(rf_model_bin),
                               data = test,
                               formula = Y ~ 1,
                               summary = "IPA",
                               metrics = "brier",
                               contrast = FALSE,
                               se.fit = FALSE)
  return(out)
}
