if(FALSE){
  test_data <- sim_OHCA_ECG_data(n = 1000, effects_first_order = effects_first_order)
  plot <- make_correlation_plot(data = test_data[,..abnorm_cols])
  plot
}
make_correlation_plot <- function(data, display_names = NULL){
  if (!is.null(display_names)) {
    validate_display_names(colnames(data), display_names)
  }
  cor_mat <- cor(data)
  
  cor_long <- as.data.frame(as.table(cor_mat))
  names(cor_long) <- c("var1", "var2", "correlation")
  
  p <- ggplot(cor_long, aes(x = var1, y = var2, fill = correlation)) +
    geom_tile() +
    scale_fill_gradient2(
      midpoint = 0,
      name = "Correlation"
    ) +
    coord_equal() +
    labs(x = NULL, y = NULL) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1)
    )
  if (!is.null(display_names)) {
    p <- p +
      scale_x_discrete(labels = display_names) +
      scale_y_discrete(labels = display_names)
  }
  p
}
