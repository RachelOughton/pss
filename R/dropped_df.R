#' Display the treatment cases that will be dropped under a particular matched sample
#'
#' @name dropped_df
#' @param matched_df A data frame output by [matched_sample()]. This should contain columns for `arm_col`, all elements of `cov_cols` and `include`. It must have the `Arm` column with levels `"Intervention"` and `"Comparison"`. It may also contain other columns.
#' @param use_attr logical. Should the attributes of `matched_df` (set by [matched_sample()]) be used to specify `cov_cols`?
#' @param cov_cols (only specify if `use_attr == FALSE`) A character vector containing the column names of the covariates to be matched on. These should all be factor / categorical data.
#' @return [dropped_df()] returns a data frame with the following columns
#' - A column for each of `cov_cols`
#' - `n_dropped`: how many treated / intervention cases with this combination of `cov_cols` have been dropped / downsampled
#' - `n_kept`: how many treated / intervention cases with this combination of `cov_cols` have been kept
#' The rows will be ordered in descending order of `n_dropped`
#' @export
#' @seealso [matched_sample()]
#'
#' @examples
#' ## First use `propscore_df` to create a propensity score data frame
#' ## This example uses the joint approach and specifies p(Z=1) such
#' ## that the expected size of the comparison group is 300
#'
#' eg_j_exp300 = propscore_df(
#'    df = eg_data,
#'    cov_cols = c("risk_ass", "category", "sus_age_bin"),
#'    arm_col = "Arm",
#'    intervention_level = "Intervention",
#'    cov_dist = "joint",
#'    pz1_fn = pz1_expectedN(300)
#'    )
#'
#' ## Now we can use `eg_j_exp300` to find a matched comparison group
#' ## In this version we sample from the comparison group with replacement
#' ## and do not drop any intervention cases for which there are no
#' ## comparison cases to sample
#'
#' match_j_exp300_replace = matched_sample(
#'    df = eg_data,
#'    propscore_df = eg_j_exp300,
#'    seed = 20,
#'    replace = TRUE,
#'    downsample = FALSE,
#'    drop_int = FALSE
#'    )
#'
#' ## Finally we use [dropped_df()] to summarise the treated / intervention
#' ## cases that have been dropped or downsampled
#' ## included `include` times
#'
#' match_j_exp300_replace |> dropped_df()
#'
#' @importFrom rlang .data

dropped_df = function(
    matched_df,
    use_attr = TRUE,
    cov_cols = NULL
){
  Arm <- include <- n_dropped <- NULL
  if(use_attr){
    if(!is.null(cov_cols))
      stop("Since use_attr is TRUE, cov_cols should be NULL")
    cov_cols = attr(matched_df, "cov_cols")
  } else{
    if(is.null(cov_cols)){
      stop("Since use_attr is FALSE, cov_cols should be specified")
    }
  }
  df_int = matched_df |>
    dplyr::filter(Arm == "Intervention") |>
    dplyr::group_by(dplyr::pick(tidyselect::all_of(cov_cols))) |>
    dplyr::summarise(
      n_dropped = sum(include == 0),
      n_kept = sum(include == 1)
    )
  df_int = df_int |> dplyr::arrange(dplyr::desc(n_dropped))
  return(df_int)
}
