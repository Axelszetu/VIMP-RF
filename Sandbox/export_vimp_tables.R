output_file <- "Output/variable_importance_tables.md"

dir.create(dirname(output_file), recursive = TRUE, showWarnings = FALSE)

raw_md <- knitr::kable(
  result_raw,
  format = "pipe",
  digits = 3,
  caption = "Raw variable importance measures"
)

ranked_md <- knitr::kable(
  result_ranked,
  format = "pipe",
  digits = 0,
  caption = "Ranks of variable importance measures"
)

writeLines(
  c(
    "# Variable importance results",
    "",
    "## Raw values",
    "",
    raw_md,
    "",
    "## Ranks",
    "",
    "Rank 1 indicates the variable ranked as most important.",
    "",
    ranked_md
  ),
  con = output_file
)