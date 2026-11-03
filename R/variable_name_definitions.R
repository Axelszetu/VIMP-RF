#Variable name definitions:
abnorm_cols <- c("diag12sl_atrial_fibrillation", "diag12sl_atrial_flutter", "diag12sl_first_degree_av_block", "diag12sl_sec_deg_avblock_type_i", "diag12sl_sec_deg_avblock_type_ii", "diag12sl_third_degree_av_block", "diag12sl_lbbb", "diag12sl_rbbb", "diag12sl_left_ant_fascic_block", "diag12sl_left_post_fascic_block", "diag12sl_bifascicular_block", "diag12sl_early_repolarization", "diagmanual_qwave", "diagmanual_stdep", "diagmanual_stele", "diagmanual_lvh", "qtcprol_all")
# Proposed display labels inferred from raw names; clinical review is pending.
# Q-wave criteria, ST thresholds, LVH criteria and QTc definition need confirmation.
ecg_display_names <- c(
  diag12sl_atrial_fibrillation = "Atrial fibrillation",
  diag12sl_atrial_flutter = "Atrial flutter",
  diag12sl_first_degree_av_block = "First-degree atrioventricular block",
  diag12sl_sec_deg_avblock_type_i = "Second-degree atrioventricular block, type I",
  diag12sl_sec_deg_avblock_type_ii = "Second-degree atrioventricular block, type II",
  diag12sl_third_degree_av_block = "Third-degree atrioventricular block",
  diag12sl_lbbb = "Left bundle branch block",
  diag12sl_rbbb = "Right bundle branch block",
  diag12sl_left_ant_fascic_block = "Left anterior fascicular block",
  diag12sl_left_post_fascic_block = "Left posterior fascicular block",
  diag12sl_bifascicular_block = "Bifascicular block",
  diag12sl_early_repolarization = "Early repolarization",
  diagmanual_qwave = "Q waves",
  diagmanual_stdep = "ST-segment depression",
  diagmanual_stele = "ST-segment elevation",
  diagmanual_lvh = "Left ventricular hypertrophy",
  qtcprol_all = "Prolonged QTc interval"
)
comorbs <- c("cancer", "cardiomp", "cerebro_vasc", "cong_hd", "copd", "hf", "ihd", "liver", "peri_vasc", "prev_mi", "renal", "valve_hd", "other_arrhythm", "other_card", "afib_aflu", "hypertension")
comorb_display_names <- c(
  cancer = "Malignant disease",
  cardiomp = "Cardiomyopathy",
  cerebro_vasc = "Cerebrovascular disease",
  cong_hd = "Congenital heart disease",
  copd = "Chronic obstructive pulmonary disease",
  hf = "Heart failure",
  ihd = "Ischaemic heart disease",
  liver = "Liver disease",
  peri_vasc = "Peripheral vascular disease",
  prev_mi = "Previous myocardial infarction",
  renal = "Renal disease",
  valve_hd = "Valvular heart disease",
  other_arrhythm = "Other cardiac arrhythmias",
  other_card = "Other cardiac diseases",
  afib_aflu = "Atrial fibrillation or flutter",
  hypertension = "Hypertension"
)
drugs <- c("statin_hyperlipidemia", "diabetes_med", "vasodilator", "digoxin", "antiarrhythmics", "betablocker", "ca_channel_blocker", "other_qt_prolong")
# Lipid-modifying and glucose-lowering drug use also define hyperlipidemia and
# diabetes, respectively, in the Hindborg manuscript.
drug_display_names <- c(
  statin_hyperlipidemia = "Lipid-modifying drugs",
  diabetes_med = "Glucose-lowering drugs",
  vasodilator = "Vasodilators",
  digoxin = "Digoxin",
  antiarrhythmics = "Antiarrhythmics",
  betablocker = "Beta blockers",
  ca_channel_blocker = "Calcium channel blockers",
  other_qt_prolong = "Other QT-prolonging medications"
)
covar <- c(abnorm_cols, "ecg_age", "sex", drugs, comorbs)
covar_no_age <- c(abnorm_cols, "sex", drugs, comorbs)
effects_first_order <- c(rep(1,4), rep(0.5,4), numeric(length = 34))
effects_interactions <- c(1,1,1)
names(effects_interactions) <- c("1x2", "5x6", "9x10")
names(effects_first_order) <- c("sex", abnorm_cols, drugs, comorbs)

#Hyperparameters to examine
mtry_parameters <- c(3,8,16)
nodesize_parameters <- c(1,5,20)
#ntree_parameters <- c(250, 500, 2000)
ntree_parameters <- c(25, 50, 200)
lambda_parameters <- c(0.1, 0.55, 1)
parameter_sizes_names <- c("low", "medium", "high")
names(mtry_parameters) <- parameter_sizes_names
names(nodesize_parameters) <- parameter_sizes_names
names(ntree_parameters) <- parameter_sizes_names
names(lambda_parameters) <- parameter_sizes_names
