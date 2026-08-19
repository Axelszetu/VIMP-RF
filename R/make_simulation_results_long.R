#Function for taking a target created with tar_rep and creating a long format data frame to use for summary
make_simulation_results_long <- function(rf_hyperparameter_results) {
  
  x <- rf_hyperparameter_results
  
  # Identify the metadata entries marking the end of each repetition
  rep_positions <- which(grepl("_tar_rep$", names(x)))
  
  out <- vector("list", length(rep_positions))
  
  start_pos <- 1
  
  for (i in seq_along(rep_positions)) {
    
    rep_pos <- rep_positions[i]
    
    # tar_batch, tar_rep, tar_seed occur at the end of each repetition
    batch_pos <- rep_pos - 1
    seed_pos <- rep_pos + 1
    
    batch <- x[[batch_pos]]
    rep <- x[[rep_pos]]
    
    # Everything before tar_batch belongs to this repetition
    result_positions <- start_pos:(batch_pos - 1)
    
    simulation_result <- x[result_positions]
    
    simulation_id <- i
    
    rep_df <- list()
    k <- 1
    
    for (j in seq_along(simulation_result)) {
      
      object_name <- names(simulation_result)[j]
      object <- simulation_result[[j]]
      
      # Remove target/hash prefix and keep only setting name
      setting <- sub(
        "^rf_hyperparameter_results_[^_]+_",
        "",
        object_name
      )
      
      if (setting != "logreg") {
        
        # RF structure:
        # setting -> scale -> measure -> named vector
        for (scale in names(object)) {
          
          for (measure in names(object[[scale]])) {
            
            values <- object[[scale]][[measure]]
            
            rep_df[[k]] <- data.frame(
              simulation = simulation_id,
              setting = setting,
              variable = names(values),
              measure = measure,
              scale = scale,
              value = unname(values),
              stringsAsFactors = FALSE
            )
            
            k <- k + 1
          }
        }
        
      } else {
        
        # Logistic regression structure:
        # logreg -> ATE_logreg -> scale -> named vector
        logreg <- object$ATE_logreg
        
        for (scale in names(logreg)) {
          
          values <- logreg[[scale]]
          
          rep_df[[k]] <- data.frame(
            simulation = simulation_id,
            setting = "logreg",
            variable = names(values),
            measure = "ATE_logreg",
            scale = scale,
            value = unname(values),
            stringsAsFactors = FALSE
          )
          
          k <- k + 1
        }
      }
    }
    
    out[[i]] <- do.call(rbind, rep_df)
    
    # Next repetition starts after tar_seed
    start_pos <- seed_pos + 1
  }
  
  out <- do.call(rbind, out)
  rownames(out) <- NULL
  
  out
}
