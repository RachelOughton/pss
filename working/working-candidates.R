## Working for candidates

candidates(
  df = eg_data,
  propscores = eg_j_est1,
  seeds = 1:10,
  smd_cols = c("suspect_age", "category", "risk_ass", "sus_age_bin"),
  smd_order = 1,
  downsample = T,
  replace = F
)

candidates(
  df = eg_data,
  propscores = eg_j_est1,
  seeds = 1:10,
  smd_cols = c("suspect_age", "category", "risk_ass", "sus_age_bin"),
  smd_order = 2,
  downsample = T,
  replace = F
)

candidates(
  df = eg_data,
  propscores = eg_j_est1,
  seeds = 1:10,
  smd_cols = c("suspect_age", "category", "risk_ass", "sus_age_bin"),
  smd_order = 3,
  downsample = T,
  replace = F
)

stdf= candidates(
  df = eg_data,
  propscores = eg_j_est1,
  seeds = 1:10,
  smd_cols = c("suspect_age", "category", "risk_ass", "sus_age_bin"),
  smd_order = 3,
  downsample = T,
  replace = F
)

## Recreating failed test

eg_j_est015 = propscores(
  df = eg_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "Arm",
  intervention_level = "Intervention",
  cov_dist = "joint",
  pz1_fn = pz1_estimate(0.15)
)


candidates(
  df = eg_data,
  propscores = eg_j_est015,
  seeds = 3*(1:10),
  smd_cols = c("risk_ass", "category", "sus_age_bin"),
  smd_order = 2
)
