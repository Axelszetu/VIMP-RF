#Fit logistic regression model
fit_logreg_model <- function(simulated_data){
  ff <- as.formula(paste("Y ~", paste(covar_no_age, collapse = "+")))
  model <- glm(formula = ff, family = binomial(link = "logit"), data = simulated_data)
  return(model)
}