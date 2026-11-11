# Run from the project root: source("export_analysis_results.R")
# Requires the four saved targets and knitr. Replaces analysis_results.txt.
local({
  read <- targets::tar_read_raw
  text <- character()
  add <- function(x, title) {
    text <<- c(text, paste("##", title), "",
               knitr::kable(x, format = "pipe", digits = 17), "")
  }

  for (target in c("rf_hyperparameter_results_tables",
                   "rf_hyperparameter_results_tables_permuted_null")) {
    tables <- read(target)
    for (measure in c("perm", "md", "ATE")) {
      z <- tables[[measure]]
      x <- z$mtry[c("variable", "reference")]
      for (p in c("mtry", "nodesize", "ntree")) {
        y <- z[[p]][match(x$variable, z[[p]]$variable), ]
        stopifnot(identical(x$variable, y$variable),
                  identical(x$reference, y$reference))
        cols <- paste0(p, c("_low", "_high"))
        x[cols] <- y[cols]
      }
      add(x, paste(target, measure, "(mean ranks)"))
    }
  }

  x <- read("ECG_variables_correlation_matrix")
  x <- x[[2]]
  stopifnot(is.matrix(x), identical(dim(x), c(17L, 17L)))
  add(x, "ECG_variables_correlation_matrix")

  x <- read("rf_IPA_by_lambda")
  OR <- as.numeric(names(x))
  stopifnot(length(OR) == length(x), !anyNA(OR))
  x <- rbind(OR = OR, IPA = sapply(x, function(z) z$IPA$score$IPA[2]))
  colnames(x) <- paste0("Setting ", seq_along(OR))
  add(x, "rf_IPA_by_lambda")

  writeLines(text, "analysis_results.txt")
})
