# Script for simulating ECG+OHCA data
if(FALSE){
  n = 100
  effect_scale = 1
}

#Temporary implementation with made-up effect sizes to be used until synthesize script is exported from DST
sim_OHCA_ECG_data <- function(n = 100, effect_scale = 1){
  data <- s(n)
  data1 <- data[,c(1,6:46)]
  effects <- seq(from = 1, to = 0, length.out = 42)*effect_scale
  data1$expected_outcome <- plogis(q = as.matrix(data1)%*%effects, location = 0.5)
  outcome <- rbinom(n = n, size = 1, prob = data1$expected_outcome)
  data1$Y <- as.factor(outcome)
  return(data1)
}