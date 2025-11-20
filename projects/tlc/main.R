#------------------------------------------------------------------------
# Packages
#------------------------------------------------------------------------

library(tidyverse)
library(scales)

#------------------------------------------------------------------------
# Load helper scripts
#------------------------------------------------------------------------

source("install_packages.R")
source("download_TLC_data.R")
source("build_df.R")
source("../os.R")

#------------------------------------------------------------------------
# Set global vars
#------------------------------------------------------------------------

data_dir <- if(is_windows()) "D:/r4ds/tlc" else "/Users/ralph/data/tlc"

#------------------------------------------------------------------------
# Download TLC data as .parquet files
#------------------------------------------------------------------------

# download_TLC_data(data_dir)

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
    ) +
    scale_y_continuous(
      labels = label_number(scale = 1/1000, suffix = "K")
    )
