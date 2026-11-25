## Tests for matched_sample

## Do one with replace adn downsample both TRUE
## One with replace and downsample both FALSE


eg_j_est1 = propscores(
  df = fm_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "FM_equip",
  intervention_level = TRUE,
  cov_dist = "joint",
  pz1_fn = pz1_estimate(0.1)
)

eg_m_resc15 = propscores(
  df = fm_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "FM_equip",
  intervention_level = TRUE,
  cov_dist = "marginal",
  pz1_fn = pz1_rescale(1.5)
)

eg_mix_exp100 = propscores(
  df = fm_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "FM_equip",
  intervention_level = TRUE,
  cov_dist = list(c("risk_ass", "category")),
  pz1_fn = pz1_expectedN(100)
)

## Check it can't handle both true or both false

test_that("error1",{
  expect_error(
    matched_sample(
      df = fm_data,
      propscores = eg_j_est1,
      cov_cols = c("category", "risk_ass", "sus_age_bin"),
      arm_col = "FM_equip",
      intervention_level = TRUE,
      seed = 20,
      sampling = "something",
      drop_int = F
    )
  )
})

test_that("error3 - not sure what!",{
  expect_error(
    matched_sample(
      df = fm_data,
      propscores = eg_j_est1,
      seed = 20,
      sampling = "something",
      drop_int = F
    )
  )
})

## Not using attributes

test_that("With replacement, not dropping", {
  expect_snapshot(
    matched_sample(
      df = fm_data,
      propscores = eg_mix_exp100,
      cov_cols = c("category", "risk_ass", "sus_age_bin"),
      arm_col = "FM_equip",
      use_attr = F,
      intervention_level = TRUE,
      seed = 20,
      sampling = "repeat",
      drop_int = F
    )
  )})


test_that("With replacement, not dropping", {
  expect_snapshot(
    matched_sample(
      df = fm_data,
      propscores = eg_m_resc15,
      cov_cols = c("category", "risk_ass", "sus_age_bin"),
      arm_col = "FM_equip",
      use_attr = F,
      intervention_level = TRUE,
      seed = 20,
      sampling = "repeat",
      drop_int = F
    )
  )})


test_that("downsampling, dropping", {
  expect_snapshot(
    matched_sample(
      df = fm_data,
      propscores = eg_m_resc15,
      cov_cols = c("category", "risk_ass", "sus_age_bin"),
      arm_col = "FM_equip",
      intervention_level = TRUE,
      use_attr = F,
      seed = 20,
      sampling = "downsample",
      drop_int = T
    )
  )})

## Using attributes


test_that("With replacement, not dropping. Upper case repeat", {
  expect_snapshot(
    matched_sample(
      df = fm_data,
      propscores = eg_mix_exp100,
      seed = 20,
      sampling = "RepEat",
      drop_int = F
    )
  )})


test_that("With replacement, not dropping", {
  expect_snapshot(
    matched_sample(
      df = fm_data,
      propscores = eg_m_resc15,
      seed = 20,
      sampling = "repeat",
      drop_int = F
    )
  )})


test_that("downsampling, dropping", {
  expect_snapshot(
    matched_sample(
      df = fm_data,
      propscores = eg_m_resc15,
      seed = 20,
      sampling = "downsample",
      drop_int = T
    )
  )})

## Checking equaliy

test_that("equal1",{
  expect_equal(
    matched_sample(
      df = fm_data,
      propscores = eg_m_resc15,
      seed = 20,
      sampling = "Downsample",
      drop_int = T
    ),
    matched_sample(
      df = fm_data,
      propscores = eg_m_resc15,
      seed = 20,
      use_attr = F,
      cov_cols = c("category", "risk_ass", "sus_age_bin"),
      arm_col = "FM_equip",
      intervention_level = TRUE,
      sampling = "downsample",
      drop_int = T
    )
  )
})

## Suggested by chat GPT, 18 Nov 2026


test_that("matching works with non-standard treatment variable names", {

  dat <- data.frame(
    treatment = c("Yes", "Yes", "No", "No"),
    x = factor(c("A", "B", "A", "B"))
  )

  ps <- propscores(
    df = dat,
    cov_cols = "x",
    arm_col = "treatment",
    intervention_level = "Yes",
    cov_dist = "joint",
    pz1_fn = pz1_rescale(1)
  )

  matched <- matched_sample(
    df = dat,
    propscores = ps,
    seed = 123,
    sampling = "repeat"
  )

  # All intervention cases should be retained
  expect_equal(
    sum(matched$include[matched$Arm == "Intervention"]),
    2
  )

  # Both groups should be represented in the standardised Arm column
  expect_true(all(c("Intervention", "Comparison") %in%
                    unique(matched$Arm)))
})



