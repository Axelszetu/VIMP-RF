# Preserve empirical ECG margins while independently randomizing each column.
permute_ECG_null_data <- function(data, covars = abnorm_cols) {
  data <- data.table::copy(data)
  n <- nrow(data)
  for (covar in covars) {
    data[[covar]] <- data[[covar]][sample.int(n)]
  }
  # The outcome calculation in sim_OHCA_ECG_data with both effect terms zero.
  data$expected_outcome <- plogis(rep(0, n))
  data$Y <- as.factor(rbinom(n = n, size = 1, prob = data$expected_outcome))
  return(data)
}
