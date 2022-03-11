#' Prepare our administrative data for analysis
#'
#' \code{clean_data} returns a dataset which has been transformed and cleaned for subsequent functions in this
#'     package.
#'
#' This function takes our raw administrative data, in a number of different forms,
#'    and prepares it in a way which allows the other functions in this package
#'    to easily work with it. It is recommended to run this package on all data
#'    regardless of setup.
#'
#' @param dat dataset
#' @param style long, the default, is one diagnosis column per row whereas wide is multiple diagnosis columns
#' @param id unique patient identifier variable name
#' @param prefix_dx the variable prefix for the diagnosis columns (defaults to "dx"), in quotes
#'
#' @return dataframe with multiple rows per patient, which has re-structured their
#'     administrative data
#'
#' @examples
#' clean_data(dat = i10_wide, id = patient_id, style = "wide", prefix_dx = "dx")
#'
#' @export


#' @importFrom rlang .data
clean_data <- function(dat = NULL,
                       style = "long",
                       id = NULL,
                       prefix_dx = "dx") {

  id2 <- rlang::quo_name(rlang::enquo(id))

  if (style == "wide" | style == "Wide") {
    dat_dx <- tidyr::pivot_longer(dat, dplyr::starts_with(prefix_dx), values_to = "dx") # here we reshape our diagnoses
    var1 <- c(id2, "dx")
    dat_dx <- dat_dx[tidyselect::all_of(var1)]

    dat2 <- dat_dx

  }

  else { # if the data is already long we change the variable names for later steps
    dat2 <- dplyr::rename(dat, "dx" = prefix_dx)
    var3 <- c(id2,"dx")
    dat2 <- dat2[tidyselect::all_of(var3)]
  }

  check_dx(dat2$dx)

  dat2 <- dplyr::filter(dat2, !is.na(.data$dx)) # removes any missing diagnosis rows
  dat2 <- dplyr::filter(dat2, .data$dx != "") # removes empty string rows

  return(dat2)

}
