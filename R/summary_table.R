#' Create a summary table for a vector of seeds
#'
#'
#' @name summary_table
#' @param df A data frame from which to generate matched samples
#' @param propscore_df A data frame (created by [propscore_df()], or with the same format) giving a propensity score (in column `PropScore`) for every covariate being matched on
#' @param seeds A vector of random seeds to be used
#' @param smd_cols A character vector of columns for which to assess balance. This can be the same as `cov_cols` but it doens't have to be.
#' @param smd_order An integer denoting the highest order of interaction for which to calculate the standardised mean difference (SMD)
#' @param replace logical. Passed to [matched_sample()]. Should the comparison cases be sampled with replacement?
#' @param downsample logical. Passed to [matched_sample()]. Should the treatment cases be downsampled when there aren't enough comparison cases? Only one of `replace` and `downsample` should be TRUE.
#' @param drop_int logical. Passed to [matched_sample()]. Should cases in the intervention/treated group be dropped if there are no equivalent cases in the comparison cohort to sample from?

#' @param use_attr logical. Should the attributes of `propscore_df` (set by [propscore_df()]) be used to specify `cov_cols`, `arm_col` and `intervention_level`?
#' @param cov_cols (only specify if `use_attr == FALSE`) A character vector containing the column names of the covariates to be matched on. These should all be factor / categorical data.
#' @param arm_col (only specify if `use_attr == FALSE`) The name of the column indicating which rows are treated cases and which are comparison cases. These should be factor or character, with only two levels / options.
#' @param intervention_level (only specify if `use_attr == FALSE`) The value in the `arm_col` for the treatment cases

#' @return [summary_table()] returns a data frame with a row for each random seed and columns
#' - seed
#' - `n_int`: the number of treated / intervention cases included in the matched sample for that seed
#' - `n_comp`: the number of comparison cases included in the matched sample for that seed
#' - `SMD_...`: column for each covariate and covariate interaction, giving the calculated SMD

#' @export
#' @seealso [matched_sample()], [expand_matched_df()]
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
#' ## Finally we use `expand_matched_df` to expand this so that each row is
#' ## included `include` times
#'
#' match_j_exp300_replace |> expand_matched_df()
#'
#' @importFrom rlang .data

summary_table = function(
    df,
    propscore_df,
    seeds,
    smd_cols,
    smd_order,
    replace = TRUE,
    downsample = FALSE,
    drop_int = FALSE,
    use_attr = TRUE,
    cov_cols = NULL,
    arm_col = NULL,
    intervention_level = NULL
    ){
  n_seeds = length(seeds)
  ## Do I need to have lots of checks or will these be done by `matched_sample` in the loop?
  ## Lots more checking needed!

  df_out = data.frame(
    seed = seeds,
    n_int = rep(NA, n_seeds),
    n_comp = rep(NA, n_seeds)
  )
  smd_linear_names = sprintf("SMD_%s", smd_cols)
  ## Use expand.grid to find all the combinations for smd_order
  ## expand.grid(letters[1:3], letters[4:5], letters[6:7])

}
