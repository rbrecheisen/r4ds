library(httr)

BASE_URL <- "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_"

YEAR <- 2013
MONTHS <- 1:12

download_TLC_data_month <- function(year, month, save_path = ".") {
  month <- sprintf("%02d", month)  # Ensure month format is "01", "02", ..., "12"
  file_url <- paste0(BASE_URL, year, "-", month, ".parquet")
  file_name <- paste0(save_path, "/yellow_tripdata_", year, "_", month, ".parquet")

    response <- GET(file_url, write_disk(file_name, overwrite = TRUE))
  
  if (http_status(response)$category == "Success") {
    message("Downloaded: ", file_name)
  } else {
    message("Failed to download: ", file_url)
  }
}

download_TLC_data <- function(data_dir) {
  for(month in MONTHS) {
    download_TLC_data_month(YEAR, month, data_dir)
  }  
}
