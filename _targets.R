library(targets)
library(tarchetypes)

# Set target options:
tar_option_set(
  packages = c("tibble", "riskRegression", "lava", "data.table", "randomForestSRC", "survival", "ggplot2")
)

tar_source("R")

#ntree_parameters <- c(25, 50, 200)

list(
  tar_target(
    name = simulated_data,
    command = {
      sim_OHCA_ECG_data(1000, effects_first_order, effects_interactions)
    }
  ),
  tar_target(
    name = rf_model_bin,
    command = {
      fit_rf_model_bin(simulated_data)
    }
  ),
  tar_target(
    name = perm_vimp,
    command = {
      get_perm_vimp(rf_model_bin)
    }
  ),
  tar_target(
    name = minimal_depth_vimp,
    command = {
      get_minimal_depth_vimp(rf_model_bin)
    }
  ),
  tar_target(
    name = ATE_rf,
    command = {
      get_ATE_rf(rf_model_bin, simulated_data)
    }
  ),
  tar_target(
    name = logreg_model,
    command = {
      fit_logreg_model(simulated_data)
    }
  ),
  tar_target(
    name = ATE_logreg,
    command = {
      get_ATE_logreg(logreg_model, simulated_data)
    }
  ),
  tar_target(
    name = vimp_table,
    command = {
      make_vimp_table(perm_vimp, minimal_depth_vimp, ATE_rf, ATE_logreg, effects_first_order)
    }
  ),
  tar_rep(
    name = rf_hyperparameter_results,
    command = {
      rf_hyperparameter_settings <- make_rf_hyperparameter_settings(mtry_parameters = mtry_parameters, nodesize_parameters = nodesize_parameters, ntree_parameters = ntree_parameters)
      result <- run_analaysis_hyperparameters(n = 200, effects_first_order = effects_first_order, effects_interactions = effects_interactions, rf_hyperparameter_settings = rf_hyperparameter_settings)
      result
    },
    batches = 2,
    reps = 2
  )
)