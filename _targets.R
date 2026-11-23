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
      fit_rf_model_bin(simulated_data, covars = covar_no_age)
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
      get_ATE_rf(rf_model_bin, simulated_data, covars = abnorm_cols)
    }
  ),
  tar_target(
    name = logreg_model,
    command = {
      fit_logreg_model(simulated_data, covars = covar_no_age)
    }
  ),
  tar_target(
    name = ATE_logreg,
    command = {
      get_ATE_logreg(logreg_model, simulated_data, covars = abnorm_cols)
    }
  ),
  tar_target(
    name = vimp_table,
    command = {
      make_vimp_table(perm_vimp, minimal_depth_vimp, ATE_rf, ATE_logreg, effects_first_order,
                      rank_covars = abnorm_cols, variable_names = abnorm_cols)
    }
  ),
  tar_target(
    name = rf_IPA_by_lambda,
    command = {
      get_rf_IPA_by_lambda(
        ORs = c(15,20,25),
        covars = abnorm_cols
      )
    }
  ),
  tar_rep(
    name = rf_hyperparameter_results,
    command = {
      rf_hyperparameter_settings <- make_rf_hyperparameter_settings(mtry_parameters = mtry_parameters, nodesize_parameters = nodesize_parameters, ntree_parameters = ntree_parameters)
      result <- run_analysis_hyperparameters(data = simulated_data, rf_hyperparameter_settings = rf_hyperparameter_settings, covars = abnorm_cols, model_covars = covar_no_age)
      result
    },
    batches = 2,
    reps = 2
  ),
  tar_target(
    name = rf_hyperparameter_results_tables,
    command = {
      rf_hyperparameter_results_tables <- make_rf_hyperparameter_results_tables(rf_hyperparameter_results = rf_hyperparameter_results, variable_names = abnorm_cols, rank_covars = abnorm_cols)
    }
  ),
  tar_rep(
    name = rf_hyperparameter_results_permuted_null,
    command = {
      rf_hyperparameter_settings <- make_rf_hyperparameter_settings(
        mtry_parameters = mtry_parameters, nodesize_parameters = nodesize_parameters,
        ntree_parameters = ntree_parameters
      )
      run_permuted_null_hyperparameters(
        data = simulated_data, rf_hyperparameter_settings = rf_hyperparameter_settings,
        covars = abnorm_cols, model_covars = covar_no_age
      )
    },
    batches = 2,
    reps = 2
  ),
  tar_target(
    name = rf_hyperparameter_results_tables_permuted_null,
    command = {
      make_rf_hyperparameter_results_tables(
        rf_hyperparameter_results = rf_hyperparameter_results_permuted_null,
        variable_names = abnorm_cols, rank_covars = abnorm_cols
      )
    }
  ),
  tar_rep(
    name = rf_vimp_mc_distribution,
    command = {
      rf_hyperparameter_settings <- list(setting = c(8,5,25))
      result <- run_analysis_hyperparameters(data = simulated_data, rf_hyperparameter_settings = rf_hyperparameter_settings, covars = abnorm_cols, model_covars = covar_no_age)
      result
    },
    batches = 10,
    reps = 10
  ),
  tar_target(
    name = rf_vimp_mc_distribution_plot,
    command = {
      rf_vimp_mc_distribution_results_long <- make_simulation_results_long(rf_vimp_mc_distribution, rank_covars = abnorm_cols)
      plot_data <- rf_vimp_mc_distribution_results_long[rf_vimp_mc_distribution_results_long$scale == 'rank', c('variable', 'measure', 'value')]
      plot <- make_rank_distribution_plot(plot_data = plot_data, variables = abnorm_cols,
                                          display_names = ecg_display_names)
      plot
    }
  ),
  tar_target(
    name = rf_tuning_grid,
    command = expand.grid(
      mtry = c(1L, 3L, 6L, 21L, 32L, 42L),
      nodesize = c(4L, 16L, 64L, 200L, 2000L),
      ntree = 50L,
      KEEP.OUT.ATTRS = FALSE
    )
  ),
  tar_target(
    name = rf_tuning_results,
    command = {
      results <- run_rf_repetitions(
        data = simulated_data,
        k = 10L,
        ntree = rf_tuning_grid$ntree,
        mtry = rf_tuning_grid$mtry,
        nodesize = rf_tuning_grid$nodesize,
        model_covars = covar_no_age,
        rank_covars = abnorm_cols,
        include_brier = TRUE
      )
      data.frame(
        mtry = rf_tuning_grid$mtry,
        nodesize = rf_tuning_grid$nodesize,
        ntree = rf_tuning_grid$ntree,
        results
      )
    },
    pattern = map(rf_tuning_grid)
  )
)
