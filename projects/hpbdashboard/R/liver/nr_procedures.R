source("../utils/dates.R")


# ----------------------------------------------------------------------------------
# Calculate number of liver procedures
# ----------------------------------------------------------------------------------
get_nr_liver_procedures <- function(
  data, 
  end_date,
  nr_months_lookback,
  resection_types,
  procedure_types
) {

  start_date <- get_start_date(end_date, nr_months_lookback)

  resection_types_cols <- paste0("operatie_lever_number_", resection_types)
  procedure_types_cols <- paste0("resectie_ablatie_number_", procedure_types)

  result <- data |>
    filter(
      lever_pancreas == "lever",
      date_operatie >= start_date,
      date_operatie <= end_date,
      (
        dplyr::if_any(dplyr::all_of(resection_types_cols), ~ .x == 1) |
        dplyr::if_any(dplyr::all_of(procedure_types_cols), ~ .x == 1)
      )
    )
  nr <- nrow(result)

  return (nr)
}
