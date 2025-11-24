source("../utils/dates.R")


get_nr_days_between <- function(
  data,
  end_date, 
  nr_months_lookback,
  lever_pancreas,
  date_column1, 
  date_column2
) {
  start_date <- get_start_date(end_date, nr_months_lookback)

  result <- data |>
    filter(
      lever_pancreas == lever_pancreas,
      date_operatie >= start_date,
      date_operatie <= end_date,
    )

  return(0)
}