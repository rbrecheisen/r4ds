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

flights |>
  filter(arr_delay >= 120)
x <- flights |>
  filter(dest %in% c("IAH", "HOU"))
View(x)
flights
glimpse(flights)
x <- flights |>
  filter(carrier %in% c("UA", "AA", "DL"))
View(x)
x <- flights |>
  filter(month %in% c(7, 8, 9))
View(x)
x <- flights |>
  filter(arr_delay > 120 & dep_delay <= 0)
View(x)
x <- flights |>
  filter(dep_delay >= 60 & arr_delay <= 30)
View(x)

# Sort flights so longest delays are on top. Then sort by departure time to find the earliest flights
# at the top
x <- flights |>
  arrange(dep_time, dep_delay)
View(x)
