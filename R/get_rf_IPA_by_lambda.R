get_rf_IPA_by_lambda <- function(ORs, n = 40000, setting = c(17, 20, 100), covars){
  lambdas <- log(ORs)
  rf_IPAs <- lapply(lambdas, function(lambda){
    effects_first_order <- c(0, lambda, numeric(40))
    IPA_data <- sim_OHCA_ECG_data(n = n, effects_first_order = effects_first_order)
    get_rf_IPA(rf_IPA_data = IPA_data, setting = setting, covars = covars)
  })
  names(rf_IPAs) <- as.character(ORs)
  rf_IPAs
}