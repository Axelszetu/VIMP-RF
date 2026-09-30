#Function for computing ATE within logreg model
get_ATE_logreg <- function(logreg_model, simulated_data, covars = abnorm_cols){
  validate_covars(covars, names(simulated_data))
  validate_covars(covars, all.vars(delete.response(terms(logreg_model))))
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
    exposed_predicted_risks <- predict.glm(object = logreg_model, newdata = cf_data_1, type = "response")
    unexposed_predicted_risks <- predict.glm(object = logreg_model, newdata = cf_data_0, type = "response")
    risk_difference <- mean(exposed_predicted_risks) - mean(unexposed_predicted_risks)
    ATE[i] <- risk_difference
  }
  return(ATE)
}
