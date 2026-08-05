#Variable name definitions:
abnorm_cols <- c("diag12sl_atrial_fibrillation", "diag12sl_atrial_flutter", "diag12sl_first_degree_av_block", "diag12sl_sec_deg_avblock_type_i", "diag12sl_sec_deg_avblock_type_ii", "diag12sl_third_degree_av_block", "diag12sl_lbbb", "diag12sl_rbbb", "diag12sl_left_ant_fascic_block", "diag12sl_left_post_fascic_block", "diag12sl_bifascicular_block", "diag12sl_early_repolarization", "diagmanual_qwave", "diagmanual_stdep", "diagmanual_stele", "diagmanual_lvh", "qtcprol_all")
comorms <- c("cancer", "cardiomp", "cerebro_vasc", "cong_hd", "copd", "hf", "ihd", "liver", "peri_vasc", "prev_mi", "renal", "valve_hd", "other_arrhythm", "other_card", "afib_aflu", "hypertension")
drugs <- c("statin_hyperlipidemia", "diabetes_med", "vasodilator", "digoxin", "antiarrhythmics", "betablocker", "ca_channel_blocker", "other_qt_prolong")
covar <- c(abnorm_cols, "ecg_age", "sex", drugs, comorbs)
