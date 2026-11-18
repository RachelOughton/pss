## Tests for candidates

## Set up some propscores to use

eg_j_est015 = propscores(
  df = eg_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "Arm",
  intervention_level = "Intervention",
  cov_dist = "joint",
  pz1_fn = pz1_estimate(0.15)
)


eg_m_resc125 = propscores(
  df = eg_data,
  cov_cols = c("risk_ass", "category", "sus_age_bin"),
  arm_col = "Arm",
  intervention_level = "Intervention",
  cov_dist = "marginal",
  pz1_fn = pz1_rescale(1.25)
)

eg_mix_exp300 = propscores(
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
    candidates(
      df = eg_data,
      propscores = eg_j_est015,
      seeds = 3*(1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin"),
      smd_order = 2
    )
  )})


test_that("Marginal, rescale to 1.25", {
  expect_snapshot(
    candidates(
      df = eg_data,
      propscores = eg_m_resc125,
      seeds = 3*(1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin"),
      smd_order = 2
    )
  )})

test_that("semi-marginal, expectedN 300", {
  expect_snapshot(
    candidates(
      df = eg_data,
      propscores = eg_mix_exp300,
      seeds = 3*(1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin", "suspect_age"),
      smd_order = 2
    )
  )})


## Downsampling

test_that("Joint, estimate 0.15", {
  expect_snapshot(
    candidates(
      df = eg_data,
      propscores = eg_j_est015,
      seeds = 3*(1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin"),
      smd_order = 2,
      sampling = "downsample"
    )
  )})


test_that("Marginal, rescale to 1.25", {
  expect_snapshot(
    candidates(
      df = eg_data,
      propscores = eg_m_resc125,
      seeds = 3*(1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin"),
      smd_order = 2,
      sampling = "downsample"
    )
  )})

test_that("semi-marginal, expectedN 300", {
  expect_snapshot(
    candidates(
      df = eg_data,
      propscores = eg_mix_exp300,
      seeds = 3*(1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin", "suspect_age"),
      smd_order = 2,
      sampling = "downsample"
    )
  )})



## Add some tests for downsampling, also check that explicitly using repeat sampling gives equal to above


test_that("equal1",{
  expect_equal(
    candidates(
      df = eg_data,
      propscores = eg_mix_exp300,
      seeds = 3*(1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin", "suspect_age"),
      smd_order = 2
    ),
    candidates(
      df = eg_data,
      propscores = eg_mix_exp300,
      seeds = 3*(1:10),
      smd_cols = c("risk_ass", "category", "sus_age_bin", "suspect_age"),
      smd_order = 2,
      sampling = "repeat"
    )
  )
})

## Suggested by chat GPT, 18 Nov 2026


test_that("plot_smd uses absolute SMD values for thresholding", {

  summary_df <- data.frame(
    seed = c(1, 2),
    SMD_age = c(-0.25, 0.05),
    SMD_risk = c(0.05, -0.08)
  )

  p <- plot_smd(
    summary_df = summary_df,
    smd_thresh = 0.1
  )

  # Seed 1 has an SMD of -0.25 and should be flagged
  expect_equal(
    unique(p$data$alpha[p$data$seed == 1]),
    0.3
  )

  # Seed 2 has all SMDs within the threshold
  expect_equal(
    unique(p$data$alpha[p$data$seed == 2]),
    1
  )
})



test_that("expand_matched_df rejects missing include values", {

  dat <- data.frame(
    id = 1:2,
    include = c(1, NA)
  )

  expect_error(
    expand_matched_df(dat),
    "missing|NA|finite"
  )
})


test_that("expand_matched_df rejects infinite include values", {

  dat <- data.frame(
    id = 1:2,
    include = c(1, Inf)
  )

  expect_error(
    expand_matched_df(dat),
    "missing|NA|finite"
  )
})


test_that("expand_matched_df rejects fractional include values", {

  dat <- data.frame(
    id = 1:2,
    include = c(1, 1.5)
  )

  expect_error(
    expand_matched_df(dat)
  )
})


test_that("expand_matched_df rejects negative include values", {

  dat <- data.frame(
    id = 1:2,
    include = c(1, -1)
  )

  expect_error(
    expand_matched_df(dat)
  )
})


test_that("expand_matched_df correctly expands valid data", {

  dat <- data.frame(
    id = 1:3,
    include = c(2, 0, 1)
  )

  result <- expand_matched_df(dat)

  expect_equal(result$id, c(1, 1, 3))
  expect_false("include" %in% names(result))
})






