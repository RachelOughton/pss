#' Example forensic marking study data
#'
#' An anonymised and slightly altered version of data from a study investigating forensic marking to protect victims of intimate partner abuse in the UK
#'
#' @format ## `fm_data`
#' A data frame with 999 rows and 8 columns. The columns used
#' \describe{
#'   \item{FM_equip}{Whether the victim was given forensic marking equipment}
#'   \item{risk_ass}{The risk assessment level assigned to the victim (either `MEDIUM` or `HIGH`)}
#'   \item{category}{The category of the principal crime - one of `ourse of conduct` (which includes stalking, harrassment and threats to kill), `Theft / CD` and `Violent/Sexual`}
#'   \item{victim_age}{The age of the victim in years}
#'   \item{suspect_age}{The age of the suspect in years}
#'   \item{sus_age_bin}{A binned version of `suspect_age`}
#'   \item{nprev_sus}{The number of intimate partner abuse incidents committed by the suspect in the previous 12 months}
#'   \item{nprev_sus_bin}{A binned verion of `nprev_sus`}
#' }
"fm_data"
