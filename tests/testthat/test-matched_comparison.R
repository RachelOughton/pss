## Tests for matched_sample

## Do one with replace adn downsample both TRUE
## One with replace and downsample both FALSE


eg_j_est1 = propscore_df(
  df = eg_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "Arm",
  intervention_level = "Intervention",
  cov_dist = "joint",
  pz1_fn = pz1_estimate(0.1)
)

eg_m_resc15 = propscore_df(
  df = eg_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "Arm",
  intervention_level = "Intervention",
  cov_dist = "marginal",
  pz1_fn = pz1_rescale(1.5)
)

eg_mix_exp100 = propscore_df(
  df = eg_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "Arm",
  intervention_level = "Intervention",
  cov_dist = list(c("risk_ass", "category")),
  pz1_fn = pz1_expectedN(100)
)

## Check it can't handle both true or both false

test_that("error1",{
  expect_error(
    matched_sample(
      df = eg_data,
      propscore_df = eg_j_est1,
      cov_cols = c("category", "risk_ass", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      seed = 20,
      replace = T,
      downsample = T,
      drop_int = F
    )
  )
})

test_that("error2",{
  expect_error(
    matched_sample(
      df = eg_data,
      propscore_df = eg_j_est1,
      cov_cols = c("category", "risk_ass", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      use_attr = FALSE,
      seed = 20,
      replace = F,
      downsample = F,
      drop_int = F
    )
  )
})

test_that("error3",{
  expect_error(
    matched_sample(
      df = eg_data,
      propscore_df = eg_j_est1,
      seed = 20,
      replace = F,
      downsample = F,
      drop_int = F
    )
  )
})

## Not using attributes

test_that("With replacement, not dropping", {
  expect_snapshot(
    matched_sample(
      df = eg_data,
      propscore_df = eg_mix_exp100,
      cov_cols = c("category", "risk_ass", "sus_age_bin"),
      arm_col = "Arm",
      use_attr = F,
      intervention_level = "Intervention",
      seed = 20,
      replace = T,
      downsample = F,
      drop_int = F
    )
  )})


test_that("With replacement, not dropping", {
  expect_snapshot(
    matched_sample(
      df = eg_data,
      propscore_df = eg_m_resc15,
      cov_cols = c("category", "risk_ass", "sus_age_bin"),
      arm_col = "Arm",
      use_attr = F,
      intervention_level = "Intervention",
      seed = 20,
      replace = T,
      downsample = F,
      drop_int = F
    )
  )})


test_that("downsampling, dropping", {
  expect_snapshot(
    matched_sample(
      df = eg_data,
      propscore_df = eg_m_resc15,
      cov_cols = c("category", "risk_ass", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      use_attr = F,
      seed = 20,
      replace = F,
      downsample = T,
      drop_int = T
    )
  )})

## Using attributes


test_that("With replacement, not dropping", {
  expect_snapshot(
    matched_sample(
      df = eg_data,
      propscore_df = eg_mix_exp100,
      seed = 20,
      replace = T,
      downsample = F,
      drop_int = F
    )
  )})


test_that("With replacement, not dropping", {
  expect_snapshot(
    matched_sample(
      df = eg_data,
      propscore_df = eg_m_resc15,
      seed = 20,
      replace = T,
      downsample = F,
      drop_int = F
    )
  )})


test_that("downsampling, dropping", {
  expect_snapshot(
    matched_sample(
      df = eg_data,
      propscore_df = eg_m_resc15,
      seed = 20,
      replace = F,
      downsample = T,
      drop_int = T
    )
  )})

## Checking equaliy

test_that("equal1",{
  expect_equal(
    matched_sample(
      df = eg_data,
      propscore_df = eg_m_resc15,
      seed = 20,
      replace = F,
      downsample = T,
      drop_int = T
    ),
    matched_sample(
      df = eg_data,
      propscore_df = eg_m_resc15,
      seed = 20,
      use_attr = F,
      cov_cols = c("category", "risk_ass", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      replace = F,
      downsample = T,
      drop_int = T
    )
  )
})


