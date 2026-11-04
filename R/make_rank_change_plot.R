make_rank_change_plot <- function(rank_table,
                                  low,
                                  reference,
                                  high,
                                  title = NULL) {
  
  plot_data <- rank_table |>
    select(
      variable,
      low = all_of(low),
      reference = all_of(reference),
      high = all_of(high)
    ) |>
    pivot_longer(
      cols = c(low, reference, high),
      names_to = "setting",
      values_to = "mean_rank"
    )
  
  plot_data$setting <- factor(
    plot_data$setting,
    levels = c("low", "reference", "high")
  )
  
  # Display variables in input row order, from top to bottom
  variable_order <- rev(unique(plot_data$variable))
  
  plot_data$variable <- factor(
    plot_data$variable,
    levels = variable_order
  )
  
  ggplot(
    plot_data,
    aes(
      x = mean_rank,
      y = variable,
      group = variable
    )
  ) +
    geom_line(linewidth = 0.5) +
    geom_point(
      aes(shape = setting),
      size = 2.5
    ) +
    scale_x_reverse() +
    labs(
      x = "Mean rank",
      y = NULL,
      shape = "Setting",
      title = title
    ) +
    theme_minimal() +
    theme(
      panel.grid.major.y = element_blank(),
      legend.position = "bottom"
    )
}
