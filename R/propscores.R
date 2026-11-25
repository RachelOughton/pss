#' Propensity score data frame
#'
#' @description
#' [propscores()] generates a data frame of propensity score estimates from study / trial data, to be used in the propensity score sampling method, using the Bayes Theorem factorisation of the propensity score
#' \deqn{p(Z=1 \mid x) = \frac{p(x \mid Z=1) p(Z=1)}{p(x)}}{p(Z=1 | x) = p(x | Z=1)p(Z=1) / p(x)}
#'
#'
#' Of the functions listed, only [propscores()] should be used directly.
#'
#' One of [pz1_estimate()], [pz1_rescale()] or [pz1_expectedN()] should be given (with its own argument `n_pz1`) as the `pz1_fn` argument, to determine which method is used to specify \eqn{p(Z=1)}{p(Z=1)}.
#'
#'
#' @name propscores
#' @param df A data frame containing treatment group and comparison cohort data
#' @param cov_cols A character vector containing the column names of the covariates to be matched on. These should all be factor / categorical data.
#' @param arm_col The name of the column indicating which rows are treated cases and which are comparison cases. These should be factor or character, with only two levels / options.
#' @param intervention_level The value in the `arm_col` for the treatment cases
#' @param cov_dist Either "joint" for fully joint distribution, "marginal" for fully marginal distribution, or a list of of character vectors indicating groups of covariates that should be considered jointly.
#' @param pz1_fn One of the functions used to specify p(Z=1): [pz1_rescale()], [pz1_estimate()] or [pz1_expectedN()]. Each of these has one numerical argument, `n_pz1`, whose meaning depends on the function being used.
#' @param n_pz1 An argument to `pz1_fn`. Its meaning depends on the function used for `pz1_fn`.
#'
#' @return [propscores()] returns a data frame with a row for each combination of values of `cov_cols` and the following columns
#' - a column for each element of `cov_cols`
#' - `px_int`, the estimate of \eqn{p(x | Z=1)}
#' - `px_comp`, the estimate of \eqn{p(x)}
#' - `count_comp`, the number of cases in the comparison cohort
#' - `count_int`, the number of cases in the intervention cohort
#' - `PropScore`, which contains the estimated propensity score
#' - Some further columns, depending on which method is used
#'
#' The data frame is assigned attributes `cov_cols`, `arm_col` and `intervention_level`, storing the information for use in subsequent functions such as [matched_sample()] (if `use_attr` is set to `TRUE`).
#' @seealso [quantile_bin()], [breaks_bin()]

#' @export
#'
#' @examples
#' # Creates a propensity score data frame from `fm_data`
#' # using the joint approach, and rescaling so that the
#' # highest propensity score is 1.
#' propscores(
#'   df = fm_data,
#'   cov_cols = c("risk_ass", "category", "sus_age_bin"),
#'   arm_col = "FM_equip",
#'   intervention_level = TRUE,
#'   cov_dist = "joint",
#'   pz1_fn = pz1_rescale(1)
#' )
#'
#' # Creates a propensity score data frame from `fm_data`
#' # using the fully marginal approach, and setting p(Z=1)
#' # so that the expected size of the matched comparison
#' # group will be 300
#' propscores(
#'   df = fm_data,
#'   cov_cols = c("risk_ass", "category", "sus_age_bin"),
#'   arm_col = "FM_equip",
#'   intervention_level = TRUE,
#'   cov_dist = "marginal",
#'   pz1_fn = pz1_expectedN(300)
#' )
#'
#' # Creates a propensity score data frame from `fm_data`
#' # for which "risk_ass" and "category" are considered
#' # jointly and "sus_age_bin" marginally, and setting p(Z=1)
#' # so that the expected size of the matched comparison
#' # group will be 300
#' propscores(
#'   df = fm_data,
#'   cov_cols = c("risk_ass", "category", "sus_age_bin"),
#'   arm_col = "FM_equip",
#'   intervention_level = TRUE,
#'   cov_dist = "marginal",
#'   pz1_fn = pz1_expectedN(300)
#' )
#' @importFrom rlang .data


propscores <- function(
  df,
  cov_cols,
  arm_col,
  intervention_level,
  cov_dist,
  pz1_fn
) {
  df <- pss_check_data(
    df = df,
    cov_cols = cov_cols,
    arm_col = arm_col,
    intervention_level = intervention_level
  )
  # Getting to data frame with ratios
  ## Using closures

  ## Will need to sort this out in order to combine the three functions into the mixed one.
  ## create cov_dist_list for marginal and joint cases
  if(is.list(cov_dist)){
    cov_dist_vec = unlist(cov_dist)
    if(any(!(cov_dist_vec) %in% cov_cols)){
      stop(sprintf("You have included %s in cov_dist but not in cov_cols",
                   cov_dist_vec[!(cov_dist_vec %in% cov_cols)]))
    }
    cov_dist_list <- cov_dist
  } else if (tolower(cov_dist) == "marginal") {
    cov_dist_list <- as.list(cov_cols)
  } else if (tolower(cov_dist) == "joint") {
    cov_dist_list <- list()
    cov_dist_list[[1]] <- cov_cols
  } else {
    stop("`cov_list` needs to be either 'joint', 'marginal' or a list of character vectors of covariates to be treated jointly.")
  }
  df_out <- .props_fun(df, cov_cols, cov_dist_list)

  ## Estimating propensity score given chosen method

  pz1_fun <- pz1_fn
  pz1 <- pz1_fun(df_out)
  message(sprintf("p(z=1) has been set to %g", pz1))

  df_out$PropScore <- pz1 * df_out$ratio
  attributes(df_out) <- c(
    attributes(df_out),
    list(
      cov_cols = cov_cols,
      arm_col = arm_col,
      intervention_level = intervention_level
    )
  )
  df_out
}


### PZ1 functions

#' @describeIn propscores Specify \eqn{p(Z=1)} using the estimate method. The argument given is the estimate used
#' @return `pz1_estimate` returns the estimate of \eqn{p(Z=1)} using the 'estimate' method (eg. a value provided by an expert). The argument is used as the estimate.
#' @export

pz1_estimate <- function(
  n_pz1 # the estimate to be used
) {
  pz1_fn <- function(
    df
  ) {
    pz1 <- n_pz1
    if(pz1 < 0)
        stop(sprintf("n_pz1 should be positive but you have entered %g", pz1))
    df$PropScore <- n_pz1 * df$ratio
    return(pz1)
  }
  return(pz1_fn)
}


#' @describeIn propscores Specify \eqn{p(Z=1)} using the rescale method. The argument given is the value the largest estimated propensity score should take
#' @return `pz1_rescale` finds the value of \eqn{p(Z=1)} such that the largest propensity score will be `n_pz1` (the argument given to `pz1_fn`)
#' @export

pz1_rescale <- function(
  n_pz1 # the value the largest propensity score should take
) {
  pz1_fn <- function(
    df
  ) {
    if(n_pz1 < 0)
      stop(sprintf("n_pz1 should be positive but you have entered %g", pz1))

    df_finite <- df |> dplyr::filter(!is.infinite(.data$ratio))
    max_ratio <- max(df_finite$ratio, na.rm=T)
    pz1 <- n_pz1 / max_ratio
    return(pz1)
  }
  return(pz1_fn)
}

#' @describeIn propscores Specify \eqn{p(Z=1)} using the expectedN method. The argument given should be the expected size of the matched comparison group
#' @return `pz1_expectedN` finds the value of \eqn{p(Z=1)} such that the expected size of the matched comparison group will be `n_pz1` (the argument to `pz1_fn`).
#' @export

pz1_expectedN <- function(
  n_pz1 # the expected size of the matched comparison group
) {
  pz1_fn <- function(
    df
  ) {
    if(n_pz1 < 0)
      stop(sprintf("n_pz1 should be positive but you have entered %g", pz1))

    ## should already have count_comp for every combination
    df_noninf <- df |> dplyr::filter(!is.infinite(.data$ratio))
    nj_rat <- df_noninf$count_comp * df_noninf$ratio
    sum_comp <- sum(nj_rat, na.rm=T)

    pz1 <- n_pz1 / sum_comp

    return(pz1)
  }
  return(pz1_fn)
}
