get_start_date <- function(end_date, nr_months) {
  return(end_date %m-% lubridate::period(months = nr_months))
}