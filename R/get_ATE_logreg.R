#Function for computing ATE within logreg model
get_ATE_logreg <- function(logreg_model, simulated_data){
  ATE <- numeric(ncol(simulated_data)-2)
  names(ATE) <- covar_no_age
  for (i in (1:length(ATE))){
    cf_data_1 <- simulated_data
    cf_data_1[,i] <- 1
    cf_data_0 <- simulated_data
    cf_data_0[,i] <- 0
    exposed_predicted_risks <- predict.glm(object = logreg_model, newdata = cf_data_1, type = "response")
    unexposed_predicted_risks <- predict.glm(object = logreg_model, newdata = cf_data_0, type = "response")
    risk_difference <- mean(exposed_predicted_risks) - mean(unexposed_predicted_risks)
    ATE[i] <- risk_difference
  }
  return(ATE)
}
