#' Find table of probabilities for [propscores()]
#'
#' Find table of estimates of \eqn{p(x)}{p(x)}, \eqn{p(x|Z=1)} and their ratio. Arguments will be passed on during [propscores()]
#' @param df A data frame containing treatment group and comparison cohort data
#' @param cov_cols A character vector containing the column names of the covariates to be matched on. These should all be factor / categorical data.
#' @param cov_list A list of character vectors indicating which groups are to be treated jointly. If `cov_dist` in [propscores()] is "marginal" or "joint" then `cov_list` will be formed from `cov_cols` and passed on to [.props_fun()]. If `cov_dist` is a list of groups of covariates to be treated jointly then the covariates to be treated marginally are filled in automatically.
#' @return [.props_fun()] returns a function that creates a data frame containing `px_int` (\eqn{p(x|Z=1)} ), `px_comp` \eqn{p(x)}{p(x)} and `ratio` (`px_int / px_comp`) for every combination of the levels of the covariates in `cov_cols`, using the approach specified via `cov_dist`.
#' @keywords internal
#' @export



.props_fun <- function(
    df,
    cov_cols,
    cov_list
) {
  df <- df |> dplyr::ungroup()
  # Try to solve no visible binding
  Arm <- count <- comb_int <- comb_comp <- cov_list_unlist <- NULL

  ## Check that all names in cov_list are in cov_cols, and none appears more than once
  cov_list_unlisted <- unlist(cov_list)
  missing_covs <- setdiff(cov_list_unlisted, cov_cols)

  if (length(missing_covs) > 0) {
    stop(
      sprintf(
        "These covariates appear in cov_list but not in cov_cols: %s",
        paste(missing_covs, collapse = ", ")
      )
    )
  }

  if (length(cov_list_unlisted) != length(unique(cov_list_unlisted))) {
    stop("At least one covariate appears twice in cov_list")
  }


  ## Split dataset by arm

  df_int <- df |> dplyr::filter(Arm == "Intervention")
  df_comp <- df |> dplyr::filter(Arm == "Comparison")
  n_int <- nrow(df_int)
  n_comp <- nrow(df_comp)


  ## Need to find the covariates still being treated marginally
  ## and add them into cov_list. Then find each probability table. Then combine them.

  marg_covs <- cov_cols[!(cov_cols %in% cov_list_unlisted)]
  for (i in marg_covs) {
    cov_list[[length(cov_list) + 1]] <- i
  }

  df_cov_list <- list()
  for (i in 1:length(cov_list)) {
    df_cov_list_i <- df |>
      dplyr::group_by(dplyr::pick(tidyselect::all_of(cov_list[[i]]))) |>
      dplyr::summarise(
        comb_int = sum(Arm == "Intervention"),
        comb_comp = sum(Arm == "Comparison"),
        prop_int = comb_int / n_int,
        prop_comp = comb_comp / n_comp
      ) |>
      dplyr::select(tidyselect::all_of(c(cov_list[[i]], "prop_int", "prop_comp")))
    names(df_cov_list_i) <- c(
      cov_list[[i]],
      sprintf("p_int_%s", paste(cov_list[[i]], collapse = ".")),
      sprintf("p_comp_%s", paste(cov_list[[i]], collapse = "."))
    )
    df_cov_list[[i]] <- df_cov_list_i
  }

  ## This is probably quite ugly but it works
  # inner_text <- paste(sprintf("levels(df$%s)", cov_cols), collapse = ", ")
  # full_text <- paste0("df_probs_cov_list = expand.grid(", inner_text, ")")
  # eval(parse(text = full_text))
  # names(df_probs_cov_list) <- cov_cols
  #
  df_probs_cov_list <- do.call(
    expand.grid,
    c(
      lapply(df[cov_cols], levels),
      KEEP.OUT.ATTRS = FALSE,
      stringsAsFactors = FALSE
    )
  )

  df_out <- df_probs_cov_list
  for (covi in cov_cols){
    df_out[[covi]] = factor(df_out[[covi]], levels = levels(df[[covi]]))
  }

  for (i in 1:length(cov_list)) {
    df_out <- dplyr::left_join(df_out, df_cov_list[[i]], by = cov_list[[i]])
    ## Replace any NAs with zero
    df_out <- df_out |>
      dplyr::mutate(
        dplyr::across(
          dplyr::starts_with("p_int"),
          ~ tidyr::replace_na(.x, 0)
        ),
        dplyr::across(
          dplyr::starts_with("p_comp"),
          ~ tidyr::replace_na(.x, 0)
        )
      )
  }

  ## Now we need to multiply all the rows starting 'p_int' and all the rows starting 'p_comp'

  p_int_df <- df_out |>
    dplyr::select(tidyselect::starts_with("p_int"))
  df_out$px_int <- apply(p_int_df, 1, prod)

  p_comp_df <- df_out |>
    dplyr::select(tidyselect::starts_with("p_comp"))
  df_out$px_comp <- apply(p_comp_df, 1, prod)

  ## Find ratio
  df_out$ratio <- df_out$px_int / df_out$px_comp
  #trying to solve NaN issues in joint approach- needs to be row-wise!
  df_out$ratio[(df_out$px_int==0)&(df_out$px_comp==0)] = 0

  ## Find count_comp, which we will need later
  df_comp <- df |> dplyr::filter(Arm == "Comparison")
  df_int <- df |> dplyr::filter(Arm == "Intervention")

  df_count_comp <- df_comp |>
    dplyr::group_by(dplyr::pick(tidyselect::all_of(cov_cols)), .drop = F) |>
    dplyr::summarise(
      count_comp = dplyr::n()
    )
  df_out <- dplyr::left_join(df_out, df_count_comp, by = cov_cols)
  df_count_int <- df_int |>
    dplyr::group_by(dplyr::pick(tidyselect::all_of(cov_cols)), .drop = F) |>
    dplyr::summarise(
      count_int = dplyr::n()
    )
  df_out <- dplyr::left_join(df_out, df_count_int, by = cov_cols)
  df_out <- df_out |>
    dplyr::mutate(
      dplyr::across(
        dplyr::starts_with("count_int"),
        ~ tidyr::replace_na(.x, 0)
      ),
      dplyr::across(
        dplyr::starts_with("count_comp"),
        ~ tidyr::replace_na(.x, 0)
      )
    )

  return(df_out)
}

