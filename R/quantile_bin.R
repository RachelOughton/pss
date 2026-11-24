#' Bin numeric columns
#'
#' These two functions add binned versions of a numerical column to a data frame. [quantile_bin()] forms the bins using the quantiles of the numerical variables, whereas [breaks_bin()] uses breaks determined by the user. In either case, the intervals are closed at the lower end and open at the top end, so for example the bin "2 to 3" would contain values of 2, but not of 3. [quantile_bin()] can operate on multiple numerical columns, whereas [breaks_bin()] can only work on one column.
#'
#' @name quantile_bin
#' @param df A data frame containing treatment group and comparison cohort data
#' @param cols A character vector containing the column names of the covariates to be binned by [quantile_bin()]. These should be numeric.
#' @param col A single string containing the column name of the numerical covariate to be binned by [breaks_bin()]
#' @param nbins Supplied to [quantile_bin()]. Either a single integer (if all `cols` are to binned into the same number of bins) or a `length(cols)` vector, with a number of bins for each column
#' @param breaks Supplied to [breaks_bin()]. A vector of break points to be used to form the bins. Each bin will contain the lower value (but not the upper value).
#' @param labels Optionally supplied to [breaks_bin()]. Character vector of labels for the bins. This must be of length `length(breaks) + 1`.
#' @param digits Integer. How many digits to round the bin breaks to. Either a single number to be used for all columns, or a vector the length of `cols`. Will round to the nearest integer by default
#' @return [quantile_bin()] returns a data frame with all the columns of `df` plus a new column for each of `cols` with the suffix `_binned`
#' @export
#'
#' @examples
#' ## Create binned variables from victim_age and suspect_age.
#' ## Create three bins for each, and round the breaks to zero digits (default)
#'
#' df_bin = quantile_bin(
#'   df = eg_data,
#'   cols = c("victim_age", "suspect_age"),
#'   nbins = 3
#'   )
#'
#' ## View summary tables of both binned variables
#'
#' df_bin |>
#'   dplyr::group_by(victim_age_binned) |>
#'   dplyr::summarise(
#'     min_vic = min(victim_age), max_vic = max(victim_age),
#'     n=dplyr::n()
#'   )
#'
#' df_bin |>
#'   dplyr::group_by(suspect_age_binned) |>
#'   dplyr::summarise(
#'     min_sus = min(suspect_age), max_sus = max(suspect_age),
#'     n=dplyr::n()
#'   )
#'
#' ## Create binned column for `nprev_sus`
#'
#' df_bin2 = breaks_bin(
#'   df = eg_data,
#'   col = "nprev_sus",
#'   breaks = c(1, 2),
#'   labels = c("Zero", "One", "Two plus")
#' )
#'
#' df_bin2 |>
#'   dplyr::group_by(nprev_sus_binned) |>
#'   dplyr::summarise(
#'    min_nps = min(nprev_sus), max_nps = max(nprev_sus),
#'    n=dplyr::n()
#'  )
#'
#'
#' @importFrom rlang .data
#'

quantile_bin <- function(
    df,
    cols,
    nbins,
    digits = 0
){
  # Check cols are in df and are numeric
  if(!all(cols%in%names(df))){
    stop(
      sprintf(
        "%s is not a column in df",
        paste(cols[!(cols %in% names(df))], collapse = ",")
        )
      )
  }
  col_classes <- df |>
    dplyr::select(tidyselect::all_of(cols)) |>
    lapply(class) |>
    unlist()
  if(any(col_classes != "numeric")){
    stop(
      sprintf(
        "The following columns are not numeric: %s",
              paste(cols[col_classes != "numeric"], collapse = ", ")
          )
      )
  }

  if(length(nbins) == 1){
    nbins = rep(nbins, length(cols))
  } else if (length(nbins) != length(cols)){
    stop("nbins must have length one or the same length as cols")
  }
  if(length(digits) == 1){
    digits = rep(digits, length(cols))
  } else if (length(digits) != length(cols)){
    stop("digits must have length one or the same length as cols")
  }

  # more checks?

  for (i in 1:length(cols)){
    col_i = cols[i]
    nbins_i = nbins[i]
    digits_i = digits[i]
    quant_seq = (1:(nbins_i-1))/nbins_i
    breaks_i = stats::quantile(df[[col_i]], quant_seq, na.rm=TRUE) |> round(digits=digits_i)
    labels_i = rep(NA, nbins_i)
    labels_i[1] = sprintf("Under %g", breaks_i[1])
    labels_i[nbins] = sprintf("Over %g", breaks_i[nbins_i-1])
    for (j in 2:(nbins_i - 1)){
      labels_i[j] = sprintf("%g to %g", breaks_i[j-1], breaks_i[j])
    }
    df = breaks_bin(df=df, col=col_i, breaks = breaks_i, labels = labels_i)
    #
    # col_i_bin = sprintf("%s_bin", col_i)
    # df[[col_i_bin]][!is.na(df[[col_i]])] = labels[1]
    # for (j in 2:(nbins_i - 1)){
    #   labels[j] = sprintf("%g to %g", breaks_i[j-1], breaks_i[j])
    #   df[[col_i_bin]][df[[col_i]] >= breaks_i[j-1]] = labels[j]
    # }
    # df[[col_i_bin]][df[[col_i]]>=breaks_i[nbins_i - 1]]= labels[nbins_i]
    # df[[col_i_bin]] = as.factor(df[[col_i_bin]])
  }
  return(df)

}

#' @describeIn quantile_bin Add a binned column corresponding to a numerical variable where the bins  are formed using the breaks supplied.
#' @return [breaks_bin()] adds a binned version of a numerical column to a dataframe, using specified breaks. Labels can be supplied, or can be automatically formed.
#' @export
#'

breaks_bin <- function(
    df,
    col,
    breaks,
    labels = NULL
){
  # Check all breaks are within the range of df[[col]]
  breaks = sort(unique(breaks))
  n_breaks = length(breaks)
  n_bins = n_breaks+1
  if((min(breaks) < min(df[[col]], na.rm=T))|(max(breaks) > max(df[[col]], na.rm=T)))
    stop("Some breaks are outside the range of the data")

  # Check labels has the correct length

  if(!is.null(labels)){
    if(!is.character((labels))){
      stop("labels should be a character vector")
    }
    if(length(labels) != n_bins){
      stop(sprintf("labels should have length %g", n_bins))
    }
  } else if(is.null(labels)){ # Form labels if not supplied
    labels = rep(NA, n_bins)
    labels[1] = sprintf("Under %g", breaks[1])
    labels[n_bins] = sprintf("%g and over", breaks[n_breaks])
    for (j in 2:(n_breaks)){
      labels[j] = sprintf("%g to %g", breaks[j-1], breaks[j])
    }
  }
  col_bin = sprintf("%s_binned", col)
  # Form bins
  df[[col_bin]][!is.na(df[[col]])] = labels[1]
  for (j in 2:n_breaks){
    df[[col_bin]][df[[col]] >= breaks[j-1]] = labels[j]
  }
  df[[col_bin]][df[[col]]>=breaks[n_breaks]]= labels[n_bins]
  df[[col_bin]] = factor(df[[col_bin]], levels = labels)

  return(df)

}

