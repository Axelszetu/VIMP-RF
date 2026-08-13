# Script for simulating ECG+OHCA data
if(FALSE){
  n = 100
}

#Temporary implementation with made-up effect sizes to be used until synthesize script is exported from DST
sim_OHCA_ECG_data <- function(n = 100, effects_first_order, effects_interactions){
  data <- s(n)
  data1 <- data[,c(1,6:46)]
  #effects <- seq(from = 1, to = 0, length.out = 42)*effect_scale
  first_order_term <- as.matrix(data1)%*%effects_first_order
  interaction_term <- numeric(length = n)
  for (i in 1:n){
    interaction_term[i] <- unlist(data1[i,1]*data1[i,2]*effects_interactions[1]) + unlist(data1[i,5]*data1[i,6]*effects_interactions[2]) + unlist(data1[i,9]*data1[i,10]*effects_interactions[3])
  }
  data1$expected_outcome <- plogis(q = first_order_term + interaction_term, location = 0.5)
  outcome <- rbinom(n = n, size = 1, prob = data1$expected_outcome)
  data1$Y <- as.factor(outcome)
  return(data1)
}