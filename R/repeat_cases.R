#' Display the comparison cases that will be repeated for a particular matched sample
#'
#' @name repeat_cases
#' @param matched_df A data frame output by [matched_sample()]. This should contain columns for `arm_col`, all elements of `cov_cols` and `include`. It must have the `Arm` column with levels `"Intervention"` and `"Comparison"`. It may also contain other columns.
#' @param use_attr logical. Should the attributes of `matched_df` (set by [matched_sample()]) be used to specify `cov_cols`?
#' @param cov_cols (only specify if `use_attr == FALSE`) A character vector containing the column names of the covariates to be matched on. These should all be factor / categorical data.
#' @return [repeat_cases()] returns a data frame with a row for each covariate combination for which some treated cases are repeat-sampled and the following columns
#' - A column for each of `cov_cols`
#' - `n`: How many such treated cases are in the full dataset
#' - `n_repeated`: How many of these are repeat-sampled
#' - `min_reps`, `median_reps`, `max_reps`: The minimum, median and maximum number of repeats
#' @export
#' @seealso [matched_sample()], [dropped_cases()]
#'
#' @examples
#' ## First use [propscores()] to create a propensity score data frame
#' ## This example uses the joint approach and specifies p(Z=1) such
#' ## that the expected size of the comparison group is 300
#'
#' eg_j_exp300 <- propscores(
#'   df = eg_data,
#'   cov_cols = c("risk_ass", "category", "sus_age_bin"),
#'   arm_col = "Arm",
#'   intervention_level = "Intervention",
#'   cov_dist = "joint",
#'   pz1_fn = pz1_expectedN(300)
#' )
#'
#' ## Now we can use `eg_j_exp300` to find a matched comparison group
#' ## In this version we sample from the comparison group with replacement
#' ## and do not drop any intervention cases for which there are no
#' ## comparison cases to sample
#'
#' match_j_exp300_rep <- matched_sample(
#'   df = eg_data,
#'   propscores = eg_j_exp300,
#'   seed = 20,
#'   sampling = "repeat",
#'   drop_int = FALSE
#' )
#'
#' ## Finally we use [repeat_cases()] to summarise the treated / intervention
#' ## cases that have been repeat-sampled
#'
#' match_j_exp300_rep |> repeat_cases()
#'
#' @importFrom rlang .data

repeat_cases <- function(
    matched_df,
    use_attr = TRUE,
    cov_cols = NULL
) {
  Arm <- include <- n_repeated <- repeats <- NULL
  if (use_attr) {
    if (!is.null(cov_cols)) {
      stop("Since use_attr is TRUE, cov_cols should be NULL")
    }
    cov_cols <- attr(matched_df, "cov_cols")
  } else {
    if (is.null(cov_cols)) {
      stop("Since use_attr is FALSE, cov_cols should be specified")
    }
  }
  if(any(matched_df$include[matched_df$Arm == "Intervention"] == 0))
    warning("Some treated cases are being dropped in this matched data frame. You can see details of the downsampled cases using `dropped_cases()`")
  df_reps <- matched_df |>
    dplyr::filter(Arm == "Comparison") |>
    dplyr::group_by(dplyr::pick(tidyselect::all_of(cov_cols))) |>
    dplyr::summarise(
      n = dplyr::n(),
      n_repeated = sum(include > 1, na.rm=T),
      min_reps = ifelse(n_repeated > 0, min(include[include > 1], na.rm=T), NA),
      median_reps = ifelse(n_repeated > 0, stats::median(include[include > 1], na.rm=T), NA),
      max_reps = ifelse(n_repeated > 0, max(include[include > 1], na.rm=T), NA)
      ) |> dplyr::filter(n_repeated > 0)

  return(df_reps)
}
