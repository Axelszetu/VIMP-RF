# Input: run (1,...,k), variable, measure, rank; score is not needed.
# Return the cumulative summary table and a named ggplot list, one per measure.
make_cumulative_rank_plots <- function(ranks) {
  ranks <- ranks[, c("run", "variable", "measure", "rank")]
  if (nrow(ranks) == 0L || anyNA(ranks) ||
      any(!is.finite(ranks$run)) || any(!is.finite(ranks$rank))) {
    stop("Ranks must contain complete, finite run and rank values.")
  }
  runs <- sort(unique(ranks$run))
  if (!identical(as.numeric(runs), as.numeric(seq_along(runs))) ||
      any(with(ranks, table(run, variable, measure)) != 1L)) {
    stop("Supply runs 1,...,k with one rank per run/variable/measure.")
  }

  variables <- unique(as.character(ranks$variable))
  measures <- unique(as.character(ranks$measure))
  summaries <- lapply(variables, function(variable) {
    do.call(rbind, lapply(measures, function(measure) {
      x <- ranks[ranks$variable == variable & ranks$measure == measure, ]
      r <- x$rank[order(x$run)]
      l <- seq_along(r)
      mean_rank <- cumsum(r) / l
      mcse <- lower <- upper <- rep(NA_real_, length(r))
      has_interval <- l >= 2L
      # Clamp roundoff below zero in the cumulative sum of squared deviations.
      ss <- pmax(0, cumsum(r^2) - l * mean_rank^2)
      mcse[has_interval] <- sqrt(ss[has_interval] /
                                  (l[has_interval] - 1) / l[has_interval])
      half_width <- stats::qt(0.975, df = l[has_interval] - 1) * mcse[has_interval]
      lower[has_interval] <- mean_rank[has_interval] - half_width
      upper[has_interval] <- mean_rank[has_interval] + half_width
      data.frame(variable = variable, measure = measure, l = l,
                 mean_rank = mean_rank, mcse = mcse, lower = lower, upper = upper)
    }))
  })
  summary <- do.call(rbind, summaries)

  plots <- lapply(measures, function(measure) {
    plot_data <- summary[summary$measure == measure, ]
    p <- ggplot2::ggplot(plot_data,
      ggplot2::aes(x = l, y = mean_rank)) +
      ggplot2::geom_ribbon(data = plot_data[plot_data$l >= 2L, ],
        ggplot2::aes(ymin = lower, ymax = upper), alpha = 0.2, colour = NA) +
      ggplot2::geom_point(data = plot_data[plot_data$l == 1L, ], size = 1.5)
    if (length(runs) > 1L) {
      p <- p + ggplot2::geom_line()
    }
    p + ggplot2::facet_wrap(~ variable) +
      ggplot2::scale_x_continuous(breaks = unique(c(1L, round(pretty(runs))))) +
      ggplot2::labs(
      title = measure, x = "Number of runs included (l)",
      y = "Cumulative average rank",
      subtitle = "Approximate pointwise 95% Monte Carlo t intervals",
      caption = "Conditional on the fixed dataset; rank 1 is most important."
    ) + ggplot2::theme_minimal()
  })
  names(plots) <- measures
  list(summary = summary, plots = plots)
}
