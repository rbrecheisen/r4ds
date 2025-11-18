#------------------------------------------------------------------------
# Packages
#------------------------------------------------------------------------

library(tidyverse)

#------------------------------------------------------------------------
# Load helper scripts
#------------------------------------------------------------------------

source("projects/tlc/install_packages.R")
source("projects/tlc/download_tlc_data.R")
source("projects/tlc/build_df.R")

#------------------------------------------------------------------------
# Set global vars
#------------------------------------------------------------------------

data_dir <- "D:/r4ds/tlc"

#------------------------------------------------------------------------
# Download TLC data as .parquet files
#------------------------------------------------------------------------

#download_tlc_data(data_dir)

#------------------------------------------------------------------------
# Build (lazy) dataframe from .parquet data
#------------------------------------------------------------------------

df <- build_df(data_dir)

#------------------------------------------------------------------------
# Show daily trip volume over time
#------------------------------------------------------------------------

df |>

  # Choose date range between 2012 and 2014
  filter(tpep_pickup_datetime >= as.POSIXct("2012-01-01"),
         tpep_pickup_datetime <  as.POSIXct("2015-01-01")) |>
  
  # Convert pickup times to dates
  mutate(date = as.Date(tpep_pickup_datetime)) |>
  
  # Count number of trips (dates)
  count(date) |>
  
  # Collect output data to dataframe
  collect() |>
  
  # Plot trip volume over time
  ggplot(aes(x = date, y = n)) + 
    geom_line() +
    labs(
      title = "Trip volume over time",
      x = "Date",
      y = "Number of trips"
    )
