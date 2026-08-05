library(targets)
# library(tarchetypes)

# Set target options:
tar_option_set(
  packages = c("tibble")
)

tar_source("R")

list(
  tar_target(
    name = simulated_data,
    command = {
      sim_OHCA_ECG_data(1000)
    }
  ),
  tar_target(
    name = rf_model,
    command = {
      fit_rf_model(simulated_data)
    }
  ),
  tar_target(
    name = perm_vimp,
    command = {
      get_perm_vimp(rf_model)
    }
  ),
  tar_target(
    name = minimal_depth_vimp,
    command = {
      get_minimal_depth_vimp(rf_model)
    }
  ),
  tar_target(
    name = ATE_rf,
    command = {
      get_ATE_rf(rf_model)
    }
  ),
  tar_target(
    name = logreg_model,
    command = fit_logreg_model(simulated_data)
  ),
  tar_target(
    name = ATE_logreg,
    command = {
      get_ATE_logreg
    }
  ),
  tar_target(
    name = vimp_table,
    command = {
      make_vimp_table(perm_vimp, minimal_depth_vimp, ATE_rf, ATE_logreg, sim_parameters)
    }
  )
)