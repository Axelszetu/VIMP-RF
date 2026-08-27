library(targets)
library(tarchetypes)

# Set target options:
tar_option_set(
  packages = c("tibble", "riskRegression", "lava", "data.table", "randomForestSRC", "survival", "ggplot2")
)

tar_source("R")

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
  ),
  tar_target(
    name = rf_hyperparameter_results_tables,
    command = {
      rf_hyperparameter_results_tables <- make_rf_hyperparameter_results_tables(rf_hyperparameter_results = rf_hyperparameter_results, variable_names = names(effects_first_order)[1:10])
    }
  ),
  tar_rep(
    name = rf_vimp_mc_distribution,
    command = {
      rf_hyperparameter_settings <- list(setting = c(8,5,25))
      result <- run_analaysis_hyperparameters(n = 2000, effects_first_order = effects_first_order, effects_interactions = effects_interactions, rf_hyperparameter_settings = rf_hyperparameter_settings)
      result
    },
    batches = 10,
    reps = 10
  ),
  tar_target(
    name = rf_vimp_mc_distribution_plot,
    command = {
      rf_vimp_mc_distribution_results_long <- make_simulation_results_long(rf_vimp_mc_distribution)
      plot_data <- rf_vimp_mc_distribution_results_long[rf_vimp_mc_distribution_results_long$scale == 'rank', c('variable', 'measure', 'value')]
      plot <- make_rank_distribution_plot(plot_data = plot_data, variables = names(effects_first_order)[1:11])
      plot
    }
  )
)