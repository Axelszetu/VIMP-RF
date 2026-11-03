# Script for simulating ECG+OHCA data
if(FALSE){
  n = 100
}

#Temporary implementation with made-up effect sizes
sim_OHCA_ECG_data <- function(n = 100, effects_first_order, effects_interactions = NULL){
  data <- synthesize_ECG_OHCA_Rcode(n)
  binary_covars <- setdiff(names(data), c("ecg_age", "time.event.0", "time.event.1",
                                         "time.event.2", "study_time_num", "new_event"))
  data1 <- data[, ..binary_covars]
  #effects <- seq(from = 1, to = 0, length.out = 42)*effect_scale
  first_order_term <- as.matrix(data1)%*%effects_first_order
  interaction_term <- numeric(length = n)
  if(!is.null(effects_interactions)){
    for (i in 1:n){
      interaction_term[i] <- unlist(data1[i,1]*data1[i,2]*effects_interactions[1]) + unlist(data1[i,5]*data1[i,6]*effects_interactions[2]) + unlist(data1[i,9]*data1[i,10]*effects_interactions[3])
    }
  }
  data1$expected_outcome <- plogis(q = first_order_term + interaction_term)
  outcome <- rbinom(n = n, size = 1, prob = data1$expected_outcome)
  data1$Y <- as.factor(outcome)
  return(data1)
}
