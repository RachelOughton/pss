## Working for summary_table

summary_table(
  df = eg_data,
  propscore_df = eg_j_est1,
  seeds = 1:10,
  smd_cols = c("suspect_age", "category", "risk_ass", "sus_age_bin"),
  smd_order = 1,
  downsample = T,
  replace = F
)

summary_table(
  df = eg_data,
  propscore_df = eg_j_est1,
  seeds = 1:10,
  smd_cols = c("suspect_age", "category", "risk_ass", "sus_age_bin"),
  smd_order = 2,
  downsample = T,
  replace = F
)

summary_table(
  df = eg_data,
  propscore_df = eg_j_est1,
  seeds = 1:10,
  smd_cols = c("suspect_age", "category", "risk_ass", "sus_age_bin"),
  smd_order = 3,
  downsample = T,
  replace = F
)
