#
make_simulation_results_long <- function(rf_hyperparameter_results) {
  
  simulation_results_long <- dplyr::bind_rows(
    lapply(
      seq_along(rf_hyperparameter_results),
      function(simulation_id) {
        
        simulation_result <- rf_hyperparameter_results[[simulation_id]]$numeric
        
        dplyr::bind_rows(
          lapply(
            names(simulation_result),
            function(setting_name) {
              
              result <- simulation_result[[setting_name]]
              
              result |>
                tibble::rownames_to_column("variable") |>
                tidyr::pivot_longer(
                  cols = -variable,
                  names_to = "measure",
                  values_to = "value"
                ) |>
                dplyr::mutate(
                  simulation = simulation_id,
                  setting = setting_name
                )
            }
          )
        )
      }
    )
  )
  simulation_results_long <- simulation_results_long |>
    dplyr::group_by(simulation, setting, measure) |>
    dplyr::mutate(
      rank = if (dplyr::first(measure) == "md") {
        stats::rank(value)
      } else {
        stats::rank(-abs(value))
      }
    ) |>
    dplyr::ungroup()
  
  return(simulation_results_long)
}