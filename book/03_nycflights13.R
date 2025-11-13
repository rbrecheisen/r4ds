install.packages(c("nycflights13"))
library(nycflights13)
library(tidyverse)
flights
flights |>
  filter(dep_delay > 120)
flights |>
  filter(month == 1 & day == 1)
flights |>
  filter(month %in% c(1, 2))
flights |>
  arrange(year, month, day, dep_time)
flights |> 
  distinct(origin, dest)
flights |> 
  distinct(origin, dest, .keep_all = TRUE)
flights |> 
  count(origin, dest, sort = TRUE)
