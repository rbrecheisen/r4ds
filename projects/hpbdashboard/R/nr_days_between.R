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
  
  date_diffs <- as.numeric(data[[date_column2]] - data[[date_column1]])

  result <- result |>
    summarize(
      mean_days = round(mean(date_diffs, na.rm = TRUE)),
      median_days = round(median(date_diffs, na.rm = TRUE)),
      min_days = min(date_diffs, na.rm = TRUE),
      max_days = max(date_diffs, na.rm = TRUE)
    )
  
  return(result)
}