get_rf_IPA <- function(rf_IPA_data, setting, covars){
  midpoint <- nrow(rf_IPA_data) %/% 2L
  train <- rf_IPA_data[seq_len(midpoint), ]
  test <- rf_IPA_data[seq.int(midpoint + 1L, nrow(rf_IPA_data)), ]
  mtry <- setting[[1]]
  nodesize <- setting[[2]]
  ntree <- setting[[3]]
  rf_model_bin <- fit_rf_model_bin(simulated_data = train, ntree = ntree, mtry = mtry, nodesize = nodesize, covars)
  out <- riskRegression::Score(list(rf_model_bin),
                               data = test,
                               formula = Y ~ 1,
                               summary = "IPA",
                               metrics = "brier",
                               contrasts = FALSE,
                               se.fit = FALSE)
  return(out)
}
