#Function for making table summarizing VIMP results
make_vimp_table <- function(perm_vimp, minimal_depth_vimp, ATE_rf, ATE_logreg, effects){
  name_order <- names(effects)
  
  result_raw <- data.frame(
    "Effects" = effects,
    "Permutation" = perm_vimp[name_order],
    "Minimal depth" = minimal_depth_vimp[name_order],
    "ATE RF" = ATE_rf[name_order],
    "ATE logreg" = ATE_logreg[name_order],
    row.names = name_order,
    check.names = FALSE
  )
  
  result_ranked <- data.frame(
    "Effects" = rank(-effects),
    "Permutation" = rank(-perm_vimp)[name_order],
    "Minimal depth" = rank(minimal_depth_vimp)[name_order],
    "ATE RF" = rank(-ATE_rf)[name_order],
    "ATE logreg" = rank(-ATE_logreg)[name_order],
    row.names = name_order,
    check.names = FALSE
  )
  
  out <- list(result_raw, result_ranked)
  return(out)
}
