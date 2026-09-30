#Function for making table summarizing VIMP results
make_vimp_table <- function(perm_vimp, minimal_depth_vimp, ATE_rf, ATE_logreg, effects,
                            rank_covars = abnorm_cols, variable_names = rank_covars){
  validate_covars(variable_names, rank_covars, "variable_names")
  for (values in list(effects, perm_vimp, minimal_depth_vimp, ATE_rf, ATE_logreg)) {
    validate_covars(rank_covars, names(values), "rank_covars")
  }
  #Select the comparison set before ranking any measure.
  name_order <- rank_covars
  effects <- effects[name_order]
  perm_vimp <- perm_vimp[name_order]
  minimal_depth_vimp <- minimal_depth_vimp[name_order]
  ATE_rf <- ATE_rf[name_order]
  ATE_logreg <- ATE_logreg[name_order]
  
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
  
  #Display filtering preserves ranks within rank_covars.
  out <- list(result_raw[variable_names, , drop = FALSE],
              result_ranked[variable_names, , drop = FALSE])
  return(out)
}
