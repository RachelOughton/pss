## Working for candidates

candidates(
  df = fm_data,
  propscores = eg_j_est1,
  seeds = 1:10,
  smd_cols = c("suspect_age", "category", "risk_ass", "sus_age_bin"),
  smd_order = 1,
  sampling = "downsample"
)

candidates(
  df = fm_data,
  propscores = eg_j_est1,
  seeds = 1:10,
  smd_cols = c("suspect_age", "category", "risk_ass", "sus_age_bin"),
  smd_order = 2,
  sampling = "downsample"
)

candidates(
  df = fm_data,
  propscores = eg_j_est1,
  seeds = 1:10,
  smd_cols = c("suspect_age", "category", "risk_ass", "sus_age_bin"),
  smd_order = 3,
  sampling = "downsample"
)

stdf= candidates(
  df = fm_data,
  propscores = eg_j_est1,
  seeds = 1:10,
  smd_cols = c("suspect_age", "category", "risk_ass", "sus_age_bin"),
  smd_order = 3,
  sampling = "downsample"
)

## Recreating failed test

eg_j_est015 = propscores(
  df = fm_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "Arm",
  intervention_level = "Intervention",
  cov_dist = "joint",
  pz1_fn = pz1_estimate(0.15)
)


candidates(
  df = fm_data,
  propscores = eg_j_est015,
  seeds = 3*(1:10),
  smd_cols = c("risk_ass", "category", "sus_age_bin"),
  smd_order = 2
)

## Including a continuous cov

candidates(
  df = fm_data,
  propscores = eg_j_est015,
  seeds = 3*(1:10),
  smd_cols = c("risk_ass", "category", "suspect_age"),
  smd_order = 2
)


