#Function for making table comparing average vimp rank across values of a single hyperparameter
make_average_rank_table <- function(
    simulation_results_long,
    measure_name,
    settings,
    variable_names = unique(simulation_results_long$variable[
      simulation_results_long$scale == "rank" &
      simulation_results_long$measure == measure_name &
      simulation_results_long$setting %in% settings
    ])
) {
  #These ranks have already been computed within the chosen comparison set.
  for (setting_name in settings) {
    available <- simulation_results_long$variable[
      simulation_results_long$scale == "rank" &
      simulation_results_long$measure == measure_name &
      simulation_results_long$setting == setting_name
    ]
    validate_covars(variable_names, available, "variable_names")
  }
  simulation_results_long |>
    dplyr::filter(
      measure == measure_name,
      scale == "rank",
      setting %in% settings,
      variable %in% variable_names
    ) |>
    dplyr::group_by(variable, setting) |>
    dplyr::summarise(
      mean_rank = mean(value, na.rm = TRUE),
      .groups = "drop"
    ) |>
    tidyr::pivot_wider(
      names_from = setting,
      values_from = mean_rank
    ) |>
    dplyr::arrange(match(variable, variable_names)) |>
    dplyr::select(
      variable,
      dplyr::all_of(settings)
    )
}
