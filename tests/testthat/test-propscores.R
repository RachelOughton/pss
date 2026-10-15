## Tests for propscores


## Test it gives correct error message when arm_col is wrong in various ways


test_that("error1",{
  expect_error(
    propscores(
      df = eg_data,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = list(c("risk_ass", "category", "victim_age")),
      pz1_fn = pz1_expectedN(300)
    )
  )
})

## Check case definitely doesn't matter

test_that("Joint, different cases", {
  expect_equal(
    propscores(
      df = eg_data,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = "joint",
      pz1_fn = pz1_rescale(1)
    ),
    propscores(
      df = eg_data,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = "JOINT",
      pz1_fn = pz1_rescale(1)
    )
  )})

test_that("Marginal, different cases", {
  expect_equal(
    propscores(
      df = eg_data,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = "marginal",
      pz1_fn = pz1_rescale(1)
    ),
    propscores(
      df = eg_data,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = "MARGINAL",
      pz1_fn = pz1_rescale(1)
    )
  )})


## Use snapshot testing for actual output


test_that("Joint, rescale to 1.5", {
  expect_snapshot(
    propscores(
       df = eg_data,
       cov_cols = c("risk_ass", "category", "sus_age_bin"),
       arm_col = "Arm",
       intervention_level = "Intervention",
       cov_dist = "joint",
       pz1_fn = pz1_rescale(1)
       )
  )})

test_that("Marginal, estimate of 0.01", {
    expect_snapshot(
      propscores(
        df = eg_data,
        cov_cols = c("risk_ass", "category", "sus_age_bin"),
        arm_col = "Arm",
        intervention_level = "Intervention",
        cov_dist = "marginal",
        pz1_fn = pz1_estimate(0.01)
      )
    )})


test_that("List, expected N of 300", {
  expect_snapshot(
    propscores(
      df = eg_data,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = list(c("risk_ass", "category")),
      pz1_fn = pz1_expectedN(300)
    )
  )})

## Tests if it works with character columns

eg_data_char = eg_data
eg_data_char$risk_ass = as.character(eg_data$risk_ass)
eg_data_char$category = as.character(eg_data$category)


test_that("Char, Joint, rescale to 1.5", {
  expect_snapshot(
    propscores(
      df = eg_data_char,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = "joint",
      pz1_fn = pz1_rescale(1)
    )
  )})

test_that("Char, Marginal, estimate of 0.01", {
  expect_snapshot(
    propscores(
      df = eg_data_char,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = "marginal",
      pz1_fn = pz1_estimate(0.01)
    )
  )})


test_that("Char, List, expected N of 300", {
  expect_snapshot(
    propscores(
      df = eg_data_char,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention",
      cov_dist = list(c("risk_ass", "category")),
      pz1_fn = pz1_expectedN(300)
    )
  )})
