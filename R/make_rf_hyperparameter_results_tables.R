#Function to make tables comparing VIMP rankins across hyperparameter values for each measure
make_rf_hyperparameter_results_tables <- function(rf_hyperparameter_results, variable_names) {
  
  simulation_results_long <-
    make_simulation_results_long(rf_hyperparameter_results)
  
  hyperparameter_settings <- list(
    mtry = c(
      "mtry_low",
      "reference",
      "mtry_high"
    ),
    nodesize = c(
      "nodesize_low",
      "reference",
      "nodesize_high"
    ),
    ntree = c(
      "ntree_low",
      "reference",
      "ntree_high"
    )
  )
  
  measures <- c(
    "perm",
    "md",
    "ATE"
  )
  
  result <- lapply(
    measures,
    function(measure_name) {
      
      lapply(
        hyperparameter_settings,
        function(settings) {
          
          make_rank_table(
            simulation_results_long,
            measure_name = measure_name,
            settings = settings,
            variable_names = variable_names
          )
        }
      )
    }
  )
  
  names(result) <- measures
  
  return(result)
}