#Fit logistic regression model
fit_logreg_model <- function(simulated_data, covars = covar_no_age){
  validate_covars(covars, setdiff(names(simulated_data), "Y"))
  ff <- as.formula(paste("Y ~", paste(covars, collapse = "+")))
  model <- glm(formula = ff, family = binomial(link = "logit"), data = simulated_data)
  return(model)
}
