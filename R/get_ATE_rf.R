#Function for computing ATE for a random forest model

get_ATE_rf <- function(rf_model_bin, simulated_data){
  ATE <- numeric(ncol(simulated_data)-2)
  names(ATE) <- covar_no_age
  for (i in (1:length(ATE))){
    cf_data_1 <- simulated_data
    cf_data_1[,i] <- 1
    cf_data_0 <- simulated_data
    cf_data_0[,i] <- 0
    exposed_predicted_risks <- predict.rfsrc(object = rf_model_bin, newdata = cf_data_1)$predicted[,2]
    unexposed_predicted_risks <- predict.rfsrc(object = rf_model_bin, newdata = cf_data_0)$predicted[,2]
    risk_difference <- mean(exposed_predicted_risks) - mean(unexposed_predicted_risks)
    ATE[i] <- risk_difference
  }
  return(ATE)
}
