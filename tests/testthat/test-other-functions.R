
## Suggested by chat GPT, 1 Nov 2026

test_that("dropped_cases correctly counts kept and dropped intervention cases", {

  matched_df <- data.frame(
    Arm = c(
      "Intervention", "Intervention", "Intervention",
      "Intervention", "Intervention",
      "Comparison", "Comparison"
    ),
    x = factor(c("A", "A", "A", "B", "B", "A", "B")),
    include = c(1, 0, 1, 0, 0, 1, 1)
  )

  result <- dropped_cases(
    matched_df,
    use_attr = FALSE,
    cov_cols = "x"
  )

  result <- result[order(result$x), ]

  expect_equal(result$n_dropped, c(1, 2))
  expect_equal(result$n_kept, c(2, 0))
})
