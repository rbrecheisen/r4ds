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

?flights

# Sort flights so longest delays are on top. Then sort by departure time to find the earliest flights
# at the top
x <- flights |>
  arrange(dep_delay, dep_time)
View(x)

# Create new column to store air speed and sort by it
x <- flights |>
  mutate(fastest = 60 * distance / air_time) |>
  arrange(desc(fastest))
View(x)

# Check if there was a flight on every day of 2013
x <- flights |>
  group_by(year, month, day) |> # groups data by each unique day
  summarize(n = n(), .groups = "drop") |> # calculates nr. flights in each day
  count()
View(x)

# Check which flights traveled the farthest/least distance
x <- flights |>
  arrange(desc(distance))
View(x)
x <- flights |>
  arrange(distance)
View(x)

x <- flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1
  )
View(x)

flights |>
  select(year, month, day)
flights |>
  select(year:day)
flights |>
  select(year, year)
View(x)

variables <- c("year", "month", "day")
flights |>
  select(any_of(variables))

flights |> select(contains("TIME", ignore.case = FALSE))
flights |>
  rename(air_time_min = air_time) |>
  relocate(air_time_min)
