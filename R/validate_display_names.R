validate_display_names <- function(variables, display_names) {
  labels <- display_names[variables]
  missing <- variables[is.na(labels) | trimws(labels) == ""]
  if (length(missing) > 0L) {
    stop("Missing display labels for: ", paste(missing, collapse = ", "))
  }
}
