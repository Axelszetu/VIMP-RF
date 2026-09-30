#Check that a requested set contains unique names available in the input.
validate_covars <- function(covars, available, argument = "covars"){
  if (!is.character(covars) || length(covars) == 0L ||
      anyNA(covars) || any(!nzchar(covars)) || anyDuplicated(covars)) {
    stop(argument, " must be a non-empty character vector of unique names.")
  }
  missing_covars <- setdiff(covars, available)
  if (length(missing_covars) > 0L) {
    stop(argument, " contains unavailable variables: ",
         paste(missing_covars, collapse = ", "))
  }
  invisible(covars)
}
