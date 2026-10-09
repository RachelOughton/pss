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


## For C-stat, do a min and max case (not sure completely how right now)
## Do I want some kind of progress bar? I don't think I want to rely on another package
## but I could use the length of seeds (ie. if it's over 50 then print what percentage done for 10% bands?)
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

## Check some things specific to summary_table (lots will be checked by matched_sample)
  df_out = data.frame(
    seed = seeds,
    n_int = rep(NA, n_seeds),
    n_comp = rep(NA, n_seeds)
  )
  smd_linear_names = sprintf("SMD_%s", smd_cols)
  for (name in smd_linear_names)
    df_out[[name]] = NA
  if(smd_order > length(smd_cols))
    stop("You can't have smd_order greater than the length of smd_cols.")

  smd_col_classes = df |> dplyr::select(smd_cols) |> lapply(class) |> unlist()
  if((any(!(smd_col_classes %in% c("factor", "character"))))&(smd_order > 1))
    warning(sprintf(
      "The interaction SMD will not include %s as it does not have class factor or character",
      paste(smd_cols[!(smd_col_classes %in% c("factor", "character"))], collapse = ", ")
      ))
  smd_int_cols = smd_cols[smd_col_classes %in% c("factor", "character")]

  if(length(seeds) > 10){
    prog_ints = round((1:10)*(length(seeds)/10))
    prog_perc = (1:10)*10
  }

  for (j in 1:length(seeds)){
    if(j %in% prog_ints){
      message(sprintf("%g percent complete", prog_perc[prog_ints == j]))
    }
    df_j = matched_sample(
      df = df,
      propscore_df = propscore_df,
      cov_cols = cov_cols,
      use_attr = use_attr,
      arm_col = arm_col,
      intervention_level = intervention_level,
      seed = seeds[j],
      replace = replace,
      downsample = downsample,
      drop_int = drop_int
    ) |> suppressMessages()
    df_j = df_j |> expand_matched_df()

    ## Need to do the match and make an expanded df!!
    df_out$n_int[j] = sum(df_j$Arm == "Intervention")
    df_out$n_comp[j] = sum(df_j$Arm == "Comparison")
    for (i in 1:length(smd_cols)){
      df_out[[smd_linear_names[i]]][j] = smd::smd(
        x = df_j[[smd_cols[[i]]]],
        g = df_j$Arm
      )$estimate
    }

    order = 2
    ## Do we want square and cubes of things? Let's say not
    ## Have I renamed something inside the loop that then breaks something?
    ## Need to think carefully about higher order interactions - smd_int and smd_cols
    while (order <= smd_order){

      eg_list = list()
      for (l in 1:order){
        eg_list[[l]] = smd_int_cols
      }
      eg_smd = do.call(expand.grid, eg_list)
      eg_smd = apply(eg_smd, c(1,2), as.character)

      eg_smd_sorted = as.data.frame(t(apply(eg_smd, 1, sort))) ## To keep it in the same aspect ratio
      eg_smd_sorted = unique(eg_smd_sorted)
      n_unique = sapply(1:nrow(eg_smd_sorted), function(i){length(unique(as.character(eg_smd_sorted[i,])))})
      eg_smd_sorted = eg_smd_sorted[n_unique == ncol(eg_smd_sorted), ]
      smd_int_prev = eg_smd_sorted # to pass onto next order, if there is one

      for (k in 1:nrow(eg_smd_sorted)){ # go through each interaction
        SMD_name_k = sprintf("SMD_%s", paste(eg_smd_sorted[k,], collapse=".")) # name of new column
        df_int_k = df_j |> select(as.character(eg_smd_sorted[k,])) # data for new column

        df_int_k[[SMD_name_k]] = sapply( # create single column for interaction (to be x in smd())
          1:nrow(df_j),
          function(i){
            # as.character turns these to numbers, but actually since it's temporary and it only matters
            # what the distributions are, I don't think that matters
            paste(as.character(df_int_k[i, ]), collapse = ".")
          }
        )
        df_int_k$Arm = df_j$Arm # add arm (to be g in smd())
        df_out[[SMD_name_k]][j] = smd::smd( # in the first run this adds the value to all - does it work from j=2 onwards?
          x = df_int_k[[SMD_name_k]],
          g = df_int_k$Arm
        )$estimate
      }
      order = order + 1
    }

  }
  return(df_out)
}
