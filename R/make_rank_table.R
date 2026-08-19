#Function for making table comparing average vimp rank across values of a single hyperparameter
make_rank_table <- function(
    simulation_results_long,
    measure_name,
    settings,
    variable_names
) {
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
