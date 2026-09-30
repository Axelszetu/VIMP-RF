#Function for computing ATE for a random forest model

get_ATE_rf <- function(rf_model_bin, simulated_data, covars = abnorm_cols){
  validate_covars(covars, names(simulated_data))
  validate_covars(covars, rf_model_bin$xvar.names)
  for (covar in covars) {
    if (anyNA(simulated_data[[covar]]) ||
        !all(simulated_data[[covar]] %in% c(0, 1))) {
      stop("ATE requires binary 0/1 covariates without missing values: ", covar)
    }
  }
  ATE <- numeric(length(covars))
  names(ATE) <- covars
  for (i in seq_along(covars)){
    #Independent copies also preserve the input when it is a data.table.
    cf_data_1 <- data.table::copy(simulated_data)
    cf_data_1[[covars[i]]][] <- 1
    cf_data_0 <- data.table::copy(simulated_data)
    cf_data_0[[covars[i]]][] <- 0
    exposed_predicted_risks <- predict.rfsrc(object = rf_model_bin, newdata = cf_data_1)$predicted[,2]
    unexposed_predicted_risks <- predict.rfsrc(object = rf_model_bin, newdata = cf_data_0)$predicted[,2]
    risk_difference <- mean(exposed_predicted_risks) - mean(unexposed_predicted_risks)
    ATE[i] <- risk_difference
  }
  return(ATE)
}
