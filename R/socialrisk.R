#' Social Risk
#'
#' \code{socialrisk} returns a summary dataset containing indicators of social risk,
#'     which vary based on the taxonomy command, for each patient.
#'
#' This function uses data which has been properly prepared to identify and flag
#'     social risks.
#'
#' @param dat dataset which has been properly prepared in long format
#' @param id variable of the unique patient identifier
#' @param dx the column with the diagnoses (defaults to 'dx')
#' @param taxonomy the taxonomy one wishes to use for social risk, with options of
#'     "cms" (default), "mha", and "siren"
#'
#' @return dataframe with one row per patient, a column for their patient id,
#'     a column with whether they have any social risk, a column with the number
#'     of social risk domains, and columns with indicator variables for each social risk
#'
#' @examples
#' data <- clean_data(dat = i10_wide, id = patient_id, style = "wide", prefix_dx = "dx")
#' socialrisk(dat = data, id = patient_id, dx = dx, taxonomy = "cms")
#'
#' @export

#' @importFrom rlang .data
socialrisk <- function(dat = NULL,
                       id = NULL,
                       dx = "dx",
                       taxonomy = "cms"){

  id2 <- rlang::quo_name(rlang::enquo(id))

  if (taxonomy == "cms"){

    dat1 <- dat %>%
      dplyr::mutate(z55 = dplyr::if_else(stringr::str_starts(dx, "Z55"), 1 , 0),
                    z56 = dplyr::if_else(stringr::str_starts(dx, "Z56"), 1 , 0),
                    z57 = dplyr::if_else(stringr::str_starts(dx, "Z57"), 1 , 0),
                    z59 = dplyr::if_else(stringr::str_starts(dx, "Z59"), 1 , 0),
                    z60 = dplyr::if_else(stringr::str_starts(dx, "Z60"), 1 , 0),
                    z62 = dplyr::if_else(stringr::str_starts(dx, "Z62"), 1 , 0),
                    z63 = dplyr::if_else(stringr::str_starts(dx, "Z63"), 1 , 0),
                    z64 = dplyr::if_else(stringr::str_starts(dx, "Z64"), 1 , 0),
                    z65 = dplyr::if_else(stringr::str_starts(dx, "Z65"), 1 , 0))

    dat2 <- dat1 %>%
      dplyr::group_by({{id}}) %>%
      dplyr::summarize(
        z55_education = max(.data$z55),
        z56_employment = max(.data$z56),
        z57_occupation = max(.data$z57),
        z59_housing = max(.data$z59),
        z60_social = max(.data$z60),
        z62_upbringing = max(.data$z62),
        z63_family = max(.data$z63),
        z64_psychosocial = max(.data$z64),
        z65_psychosocial_other = max(.data$z65)) %>%
      dplyr::ungroup()

    dat3 <- dat2 %>%
      dplyr::mutate(number_domains = .data$z55_education + .data$z56_employment +
                      .data$z57_occupation + .data$z59_housing + .data$z60_social +
                      .data$z62_upbringing + .data$z63_family + .data$z64_psychosocial +
                      .data$z65_psychosocial_other,
                    any_social_risk = dplyr::if_else(.data$number_domains >= 1, 1, 0))

    dat4 <- dat3 %>%
      dplyr::select(id2, .data$any_social_risk, .data$number_domains,
                    .data$z55_education, .data$z56_employment, .data$z57_occupation,
                    .data$z59_housing, .data$z60_social, .data$z62_upbringing,
                    .data$z63_family, .data$z64_psychosocial,
                    .data$z65_psychosocial_other)

    return(dat4)

  }

  else if (taxonomy == "mha"){

    z_employment_codes <- c("Z560", "Z569", "Z5689", "Z578", "Z566", "Z575",
                            "Z5731", "Z563", "Z574", "Z572", "Z579", "Z565",
                            "Z562", "Z5739", "Z570", "Z561", "Z571", "Z564",
                            "Z5682", "Z5681", "Z576", "Z577")
    z_family_codes <- c("Z62810", "Z6221", "Z62811", "Z634", "Z62820", "Z630",
                        "Z635", "Z6379", "Z62812", "Z62819", "Z641", "Z62891",
                        "Z636", "Z6372", "Z62898", "Z6332", "Z62821", "Z62822",
                        "Z6229", "Z629", "Z62890", "Z640", "Z620", "Z6222",
                        "Z631", "Z621", "Z6331", "Z626", "Z623", "Z6371")
    z_housing_codes <- c("Z590", "Z593", "Z591", "Z592")
    z_psychosocial_codes <- c("Z639", "Z638", "Z658", "Z659", "Z644")
    z_ses_codes <- c("Z609", "Z599", "Z653", "Z602", "Z608", "Z598",
                     "Z559", "Z651", "Z604", "Z558", "Z596", "Z553",
                     "Z597", "Z554", "Z603", "Z594", "Z600", "Z652",
                     "Z550", "Z654", "Z605", "Z650", "Z552", "Z595",
                     "Z655", "Z551")

    dat1 <- dat %>%
      dplyr::mutate(z_employment = dplyr::if_else(dx %in% z_employment_codes, 1, 0),
                    z_family = dplyr::if_else(dx %in% z_family_codes, 1, 0),
                    z_housing = dplyr::if_else(dx %in% z_housing_codes, 1, 0),
                    z_psychosocial = dplyr::if_else(dx %in% z_psychosocial_codes, 1, 0),
                    z_ses = dplyr::if_else(dx %in% z_ses_codes, 1, 0))

    dat2 <- dat1 %>%
      dplyr::group_by({{id}}) %>%
      dplyr::summarize(
        employment = max(.data$z_employment),
        family = max(.data$z_family),
        housing = max(.data$z_housing),
        psychosocial = max(.data$z_psychosocial),
        ses = max(.data$z_ses)) %>%
      dplyr::ungroup()

    dat3 <- dat2 %>%
      dplyr::mutate(number_domains = .data$employment + .data$family + .data$housing +
                      .data$psychosocial + .data$ses,
                    any_social_risk = dplyr::if_else(.data$number_domains >= 1, 1, 0))

    dat4 <- dat3 %>%
      dplyr::select(id2, .data$any_social_risk, .data$number_domains,
                    .data$employment, .data$family, .data$housing,
                    .data$psychosocial, .data$ses)

    return(dat4)

  }


  else if (taxonomy == "siren") {

    message("Note: The SIREN Compendium assigns multiple domains to each code, resulting in non-mutally exclusive groups.")

    access_code <- c("Z597","Z598","Z608","Z759","Z753","Z7689","Z91120","Z9189")
    education_code <- c("Z7689","Z550","Z551","Z552","Z553","Z554","Z558","Z559")
    employment_code <- c("Z7689","Z560","Z561","Z562","Z563","Z564","Z565","Z566",
                         "Z5689","Z569","Z638","Z728","Z7289","Z7389")
    finances_code <- c("Z597","Z598","Z595","Z596")
    food_code <- c("Z7389","Z594")
    housing_code <- c("Z598","Z590","Z591","Z77011","Z77120")
    immigration_code <- c("Z590","Z603")
    incarceration_code <- c("Z638","Z608","Z6332","Z650","Z651","Z652","Z653")
    language_code <- c("Z608","Z7689","Z609")
    race_eth_code <- c("Z605")
    safety_code <- c("Z7689","Z9189","Z62810","Z62811","Z62812","Z62813","Z62819",
                     "Z62820","Z62821","Z62822","Z62890","Z62891","Z62898","Z629",
                     "Z630","Z654","Z8489","Z91410","Z91411")
    soc_connect_code <- c("Z9189","Z630","Z608","Z638","Z602",
                          "Z604","Z635","Z639","Z659","Z734")
    stress_code<- c("Z9189","Z638","Z7389","Z563","Z566","Z6379","Z732","Z733")
    transportation_code <- c("Z7689","Z598")
    utilities_code <- c("Z598","Z591","Z594")
    veteran_code <- c("Z5682","Z6331","Z6371","Z655","Z9182")

    dat1 <- dat %>%
      dplyr::mutate(z_access = dplyr::if_else(dx %in% access_code, 1, 0),
                    z_education = dplyr::if_else(dx %in% education_code, 1, 0),
                    z_employment = dplyr::if_else(dx %in% employment_code, 1, 0),
                    z_finances = dplyr::if_else(dx %in% finances_code, 1, 0),
                    z_food = dplyr::if_else(dx %in% food_code, 1, 0),
                    z_housing = dplyr::if_else(dx %in% housing_code, 1, 0),
                    z_immigration = dplyr::if_else(dx %in% immigration_code, 1, 0),
                    z_incarceration = dplyr::if_else(dx %in% incarceration_code, 1, 0),
                    z_language = dplyr::if_else(dx %in% language_code, 1, 0),
                    z_race_eth = dplyr::if_else(dx %in% race_eth_code, 1, 0),
                    z_safety = dplyr::if_else(dx %in% safety_code, 1, 0),
                    z_soc_connect = dplyr::if_else(dx %in% soc_connect_code, 1, 0),
                    z_stress = dplyr::if_else(dx %in% stress_code, 1, 0),
                    z_transportation = dplyr::if_else(dx %in% transportation_code, 1, 0),
                    z_utilities = dplyr::if_else(dx %in% utilities_code, 1, 0),
                    z_veteran = dplyr::if_else(dx %in% veteran_code, 1, 0))

    dat2 <- dat1 %>%
      dplyr::group_by({{id}}) %>%
      dplyr::summarize(
        access = max(.data$z_access),
        education = max(.data$z_education),
        employment = max(.data$z_employment),
        finances = max(.data$z_finances),
        food = max(.data$z_food),
        housing = max(.data$z_housing),
        immigration = max(.data$z_immigration),
        incarceration = max(.data$z_incarceration),
        language = max(.data$z_language),
        race_eth = max(.data$z_race_eth),
        safety = max(.data$z_safety),
        soc_connect = max(.data$z_soc_connect),
        stress = max(.data$z_stress),
        transportation = max(.data$z_transportation),
        utilities = max(.data$z_utilities),
        veteran = max(.data$z_veteran)) %>%
      dplyr::ungroup()

    dat3 <- dat2 %>%
      dplyr::mutate(number_domains = .data$access + .data$education + .data$employment +
                      .data$finances + .data$food + .data$housing + .data$immigration +
                      .data$incarceration + .data$language + .data$race_eth + .data$safety +
                      .data$soc_connect + .data$stress + .data$transportation + .data$utilities +
                      .data$veteran,
                    any_social_risk = dplyr::if_else(.data$number_domains >= 1, 1, 0))

    dat4 <- dat3 %>%
      dplyr::select(id2, .data$any_social_risk, .data$number_domains, .data$access,
                    .data$education, .data$employment, .data$finances, .data$food,
                    .data$housing, .data$immigration, .data$incarceration, .data$language,
                    .data$race_eth, .data$safety, .data$soc_connect, .data$stress,
                    .data$transportation, .data$utilities, .data$veteran)

  }

  else {stop("Please specify an allowed taxonomy, either: cms, aha, or siren.")

  }

}


