make_simulation_results_long <- function(rf_hyperparameter_results) {
  
  x <- rf_hyperparameter_results
  
  # tar_rep appends tar_batch, tar_rep and tar_seed to each repetition.
  # The tar_rep entries therefore identify the end of each repetition.
  rep_positions <- which(grepl("_tar_rep$", names(x)))
  
  if (length(rep_positions) == 0) {
    stop("Could not find any tar_rep metadata entries.")
  }
  
  out <- vector("list", length(rep_positions))
  
  start_pos <- 1L
  
  for (i in seq_along(rep_positions)) {
    
    rep_pos <- rep_positions[i]
    
    # Within each repetition:
    # results ..., tar_batch, tar_rep, tar_seed
    batch_pos <- rep_pos - 1L
    seed_pos  <- rep_pos + 1L
    
    result_positions <- start_pos:(batch_pos - 1L)
    simulation_result <- x[result_positions]
    
    # Prefix shared by all result objects in this tar_rep repetition.
    # E.g. rf_hyperparameter_results_<hash>_
    rep_prefix <- sub(
      "tar_rep$",
      "",
      names(x)[rep_pos]
    )
    
    numeric_df <- dplyr::bind_rows(
      lapply(
        seq_along(simulation_result),
        function(j) {
          
          object_name <- names(simulation_result)[j]
          object <- simulation_result[[j]]
          
          # Remove target/hash prefix, leaving e.g.
          # reference, mtry_low, ..., logreg
          if (!startsWith(object_name, rep_prefix)) {
            stop(
              "Unexpected tar_rep result name: ",
              object_name
            )
          }
          
          setting_name <- substring(
            object_name,
            nchar(rep_prefix) + 1L
          )
          
          numeric_result <- object$numeric
          
          if (is.null(numeric_result)) {
            stop(
              "No numeric component found for setting: ",
              setting_name
            )
          }
          
          dplyr::bind_rows(
            lapply(
              names(numeric_result),
              function(measure_name) {
                
                values <- numeric_result[[measure_name]]
                
                data.frame(
                  simulation = i,
                  setting = setting_name,
                  variable = names(values),
                  measure = measure_name,
                  scale = "numeric",
                  value = unname(values),
                  stringsAsFactors = FALSE
                )
              }
            )
          )
        }
      )
    )
    
    # Calculate ranks separately within each simulation,
    # setting and VIMP measure.
    rank_df <- numeric_df |>
      dplyr::group_by(
        simulation,
        setting,
        measure
      ) |>
      dplyr::mutate(
        value = if (dplyr::first(measure) == "md") {
          
          rank(value)
          
        } else if (dplyr::first(measure) == "perm") {
          
          rank(-value)
          
        } else {
          
          # ATE and ATE_logreg
          rank(-abs(value))
        },
        scale = "rank"
      ) |>
      dplyr::ungroup()
    
    out[[i]] <- dplyr::bind_rows(
      numeric_df,
      rank_df
    )
    
    # Next repetition begins after tar_seed
    start_pos <- seed_pos + 1L
  }
  
  simulation_results_long <- dplyr::bind_rows(out)
  
  return(simulation_results_long)
}
