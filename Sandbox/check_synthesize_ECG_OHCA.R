# Run from the repository root: Rscript --vanilla Sandbox/check_synthesize_ECG_OHCA.R
source("R/synthesize_ECG_OHCA_Rcode.R")
source("R/sim_OHCA_ECG_data.R")

local({
  # Expected output after removing the redundant event indicators.
  expected_columns <- c(
    "sex", "time.event.0", "ecg_age",
    "diag12sl_atrial_fibrillation", "diag12sl_atrial_flutter",
    "diag12sl_first_degree_av_block", "diag12sl_sec_deg_avblock_type_i",
    "diag12sl_sec_deg_avblock_type_ii", "diag12sl_third_degree_av_block",
    "diag12sl_lbbb", "diag12sl_rbbb", "diag12sl_left_ant_fascic_block",
    "diag12sl_left_post_fascic_block", "diag12sl_bifascicular_block",
    "diag12sl_early_repolarization", "diagmanual_qwave", "diagmanual_stdep",
    "diagmanual_stele", "diagmanual_lvh", "qtcprol_all", "statin_hyperlipidemia",
    "diabetes_med", "vasodilator", "digoxin", "antiarrhythmics", "betablocker",
    "ca_channel_blocker", "other_qt_prolong", "cancer", "cardiomp", "cerebro_vasc",
    "copd", "hf", "ihd", "liver", "peri_vasc", "prev_mi", "renal", "valve_hd",
    "other_arrhythm", "other_card", "afib_aflu", "hypertension", "cong_hd",
    "time.event.1", "time.event.2", "study_time_num", "new_event"
  )
  set.seed(42)
  d <- synthesize_ECG_OHCA_Rcode(1000)
  latent_times <- as.matrix(d[, c("time.event.0", "time.event.1", "time.event.2"),
                            with = FALSE])
  binary_columns <- expected_columns[c(1, 4:44)]
  stopifnot(
    data.table::is.data.table(d), nrow(d) == 1000L,
    identical(names(d), expected_columns), all(is.finite(as.matrix(d))),
    all(latent_times > 0), all(d$study_time_num == apply(latent_times, 1, min)),
    all(d$new_event == apply(latent_times, 1, which.min) - 1L),
    setequal(d$new_event, 0:2),
    all(as.matrix(d[, ..binary_columns]) %in% 0:1)
  )
  set.seed(42)
  stopifnot(identical(d, synthesize_ECG_OHCA_Rcode(1000)))
  single <- synthesize_ECG_OHCA_Rcode(1)
  stopifnot(nrow(single) == 1L, identical(names(single), expected_columns),
            all(is.finite(as.matrix(single))))

  effects <- c(0.3, -0.2, rep(0, 40))
  for (interactions in list(NULL, c(0.1, 0.2, 0.3))) {
    binary <- sim_OHCA_ECG_data(1000, effects, interactions)
    x <- as.matrix(binary[, ..binary_columns])
    eta <- as.vector(x %*% effects)
    if (!is.null(interactions)) {
      eta <- eta + x[, 1] * x[, 2] * interactions[1] +
        x[, 5] * x[, 6] * interactions[2] + x[, 9] * x[, 10] * interactions[3]
    }
    stopifnot(
      nrow(binary) == 1000L,
      identical(names(binary), c(binary_columns, "expected_outcome", "Y")),
      !anyNA(binary), is.factor(binary$Y), setequal(binary$Y, c("0", "1")),
      isTRUE(all.equal(binary$expected_outcome, plogis(eta)))
    )
  }
  print(table(d$new_event))
  print(summary(d$study_time_num))
  cat("PASS: output format, competing risks, reproducibility and binary wrapper checks\n")
})
