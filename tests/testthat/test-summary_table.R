## Tests for summary_table

## Set up some propscore_df to use

eg_j_est015 = propscore_df(
  df = eg_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "Arm",
  intervention_level = "Intervention",
  cov_dist = "joint",
  pz1_fn = pz1_estimate(0.15)
)


eg_m_resc125 = propscore_df(
  df = eg_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "Arm",
  intervention_level = "Intervention",
  cov_dist = "marginal",
  pz1_fn = pz1_rescale(1.25)
)

eg_mix_exp300 = propscore_df(
  df = eg_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "Arm",
  intervention_level = "Intervention",
  cov_dist = list(c("sus_age_bin", "category")),
  pz1_fn = pz1_expectedN(300)
)

## Snapshot tests

test_that("Joint, estimate 0.15", {
  expect_snapshot(
    summary_table(
      df = eg_data,
      propscore_df = eg_j_est015,
      seeds = 3*(1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin"),
      smd_order = 2
    )
  )})


test_that("Marginal, rescale to 1.25", {
  expect_snapshot(
    summary_table(
      df = eg_data,
      propscore_df = eg_m_resc125,
      seeds = 3*(1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin"),
      smd_order = 2
    )
  )})

test_that("semi-marginal, expectedN 300", {
  expect_snapshot(
    summary_table(
      df = eg_data,
      propscore_df = eg_mix_exp300,
      seeds = 3*(1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin", "suspect_age"),
      smd_order = 2
    )
  )})


