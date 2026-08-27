#Function for making plot of MC distribution of variable importance measures
make_rank_distribution_plot <- function(
    plot_data,
    variables,
    conf_level = 0.95,
    n_boot = 2000,
    show_violin = TRUE,
    show_errorbar = TRUE
) {
  
  library(ggplot2)
  library(dplyr)
  
  plot_data <- plot_data %>%
    filter(variable %in% variables) %>%
    mutate(
      variable = factor(
        variable,
        levels = rev(variables)
      )
    )
  
  summary_stats <- plot_data %>%
    group_by(variable, measure) %>%
    summarise(
      mean_rank = mean(value, na.rm = TRUE),
      .groups = "drop"
    )
  
  if (show_errorbar) {
    alpha <- (1 - conf_level) / 2
    
    boot_summary <- plot_data %>%
      group_by(variable, measure) %>%
      summarise(
        mean_rank = mean(value, na.rm = TRUE),
        boot_values = list(
          replicate(
            n_boot,
            mean(sample(value, replace = TRUE), na.rm = TRUE)
          )
        ),
        .groups = "drop"
      ) %>%
      mutate(
        lower = sapply(
          boot_values,
          quantile,
          probs = alpha,
          na.rm = TRUE
        ),
        upper = sapply(
          boot_values,
          quantile,
          probs = 1 - alpha,
          na.rm = TRUE
        )
      )
  }
  
  p <- ggplot(
    plot_data,
    aes(
      x = value,
      y = variable,
      fill = measure,
      color = measure
    )
  )
  
  if (show_violin) {
    p <- p +
      geom_violin(
        aes(group = interaction(variable, measure)),
        position = position_dodge(width = 0.8),
        alpha = 0.25,
        scale = "width",
        trim = FALSE
      )
  }
  
  if (show_errorbar) {
    p <- p +
      geom_errorbar(
        data = boot_summary,
        aes(
          x = mean_rank,
          xmin = lower,
          xmax = upper,
          y = variable,
          color = measure
        ),
        position = position_dodge(width = 0.8),
        width = 0,
        linewidth = 0.8,
        inherit.aes = FALSE
      )
  }
  
  p <- p +
    geom_point(
      data = summary_stats,
      aes(
        x = mean_rank,
        y = variable,
        color = measure
      ),
      position = position_dodge(width = 0.8),
      size = 2,
      inherit.aes = FALSE
    ) +
    labs(
      x = "Variable importance rank",
      y = NULL,
      color = "Method",
      fill = "Method"
    ) +
    theme_minimal() +
    theme(
      legend.position = "bottom"
    )
  
  p
}