#Function for computing ATE within logreg model
get_ATE_logreg <- function(logreg_model, simulated_data, covars = abnorm_cols){
  validate_covars(covars, names(simulated_data))
  validate_covars(covars, all.vars(delete.response(terms(logreg_model))))
  if (nrow(simulated_data) == 0L) stop("ATE requires nonempty prediction data.")
  #For a binomial factor response, glm predicts the second factor level.
  response <- model.response(model.frame(logreg_model))
  valid_response <- if (is.factor(response)) {
    identical(levels(response), c("0", "1")) && !anyNA(response)
  } else {
    (is.numeric(response) || is.logical(response)) && is.null(dim(response)) &&
      length(response) > 0L && !anyNA(response) && all(response %in% c(0, 1))
  }
  if (!identical(logreg_model$family$family, "binomial") || !valid_response) {
    stop("Logistic ATE requires a binomial 0/1 response with Y=1 as the predicted event; factor levels must be c('0', '1').")
  }
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
    for (risks in list(exposed_predicted_risks, unexposed_predicted_risks)) {
      if (!is.numeric(risks) || length(risks) != nrow(simulated_data) ||
          any(!is.finite(risks)) || any(risks < 0 | risks > 1)) {
        stop("Logistic ATE requires one finite Y=1 probability in [0, 1] per row.")
      }
    }
    risk_difference <- mean(exposed_predicted_risks) - mean(unexposed_predicted_risks)
    ATE[i] <- risk_difference
  }
  return(ATE)
}
