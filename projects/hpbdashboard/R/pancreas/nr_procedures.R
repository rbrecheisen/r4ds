source("../utils/dates.R")


# ----------------------------------------------------------------------------------
# Calculate number of liver procedures
# ----------------------------------------------------------------------------------
get_nr_pancreas_procedures <- function(
  data, 
  end_date,
  nr_months_lookback,
  resection_types,
  procedure_types
) {
  start_date <- get_start_date(end_date, nr_months_lookback)

  result <- data |>
    filter(
      lever_pancreas == "pancreas",
      date_operatie >= start_date,
      date_operatie <= end_date,
      operatie_pancreas %in% resection_types,
      operatie_pancreas_techniek %in% procedure_types
    )
  nr <- nrow(result)

  return(nr)
}