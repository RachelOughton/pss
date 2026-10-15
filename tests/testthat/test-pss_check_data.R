## Expected errors

# Giving numerical argument
expect_error(
  pss_check_data(
    df = eg_data,
    cov_cols = c("risk_ass", "category", "suspect_age"),
    arm_col = "Arm",
    intervention_level = "Intervention"
    )
  )

# Giving a cov col name that isn't in the dataset
expect_error(
  pss_check_data(
    df = eg_data,
    cov_cols = c("risk_ass", "category1", "sus_age_bin"),
    arm_col = "Arm",
    intervention_level = "Intervention",
    cov_dist = props_joint_fn()
  )
)

test_that("my output looks right", {
  expect_snapshot(
    pss_check_data(
      df = eg_data,
      cov_cols = c("risk_ass", "category", "sus_age_bin"),
      arm_col = "Arm",
      intervention_level = "Intervention"
    )
  )})

## Suggested by chatGPT

test_that("character covariates are converted to factors", {
  dat <- data.frame(
    group = c("treated", "treated", "control", "control"),
    x = c("A", "B", "A", "B")
  )

  expect_message(
    out <- pss_check_data(
      df = dat,
      cov_cols = "x",
      arm_col = "group",
      intervention_level = "treated"
    ),
    "Column x has been coerced to a factor with 2 levels"
  )

  expect_true(is.factor(out$x))
  expect_true(all(c("Intervention", "Comparison") %in% out$Arm))
})


test_that("NA rows for arm_col are removed", {
  dat <- data.frame(
    group = c("treated", "treated", "control", "control", NA),
    x = c("A", "B", "A", "B", "B")
  )

  expect_message(
    out <- pss_check_data(
      df = dat,
      cov_cols = "x",
      arm_col = "group",
      intervention_level = "treated"
    ),
    "There are 1 NA values in the group column. These rows will be lost."
  )

  expect_false(any(is.na(out$Arm)))
  expect_true(all(c("Intervention", "Comparison") %in% out$Arm))
})



