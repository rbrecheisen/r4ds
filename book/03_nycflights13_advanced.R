install.packages(c("nycflights13"))
library(nycflights13)
library(tidyverse)

View(flights)

# --------------------------------------------------------------------------------------------
# 1. Which airlines have the most consistent on-time performance?
# --------------------------------------------------------------------------------------------

# What does this mean? It means that the variation of arrival times (I guess both departure
# and arrival) is the smallest. Perhaps arrival time is the most important so passengers know 
# that they will arrive on time. Let's focus on arrival times therefore.
# How to do this? Look through the flights of all airlines (group by carrier) and summarize 
# their arrival delays with a mean and standard deviation. Then order the dataset (arrange) by
# arrival delay (ascending). This should give you the top performing airlines.

x <- flights |>
  group_by(carrier) |>
  summarize(
    mean_arr_delay = mean(arr_delay, na.rm = TRUE),
    sd_arr_delay = sd(arr_delay, na.rm = TRUE)
    ) |>
  arrange(sd_arr_delay, .by_group = TRUE)
View(x)


# --------------------------------------------------------------------------------------------
# 2. What are the top 10 routes with the highest average arrival delay?
# --------------------------------------------------------------------------------------------

# What does this mean? What defines a route? A route is a combination of departure and arrival
# locations. For example, EWR -> IAH is such a route. The idea is to group by origin/dest
# combinations and for each group calculate the average arrival delay. Then sort the rows in
# ascending order by averge arrival delay to find the top 10 highest average delays.

x <- flights |>
  group_by(origin, dest) |>
  summarize(
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(desc(avg_arr_delay)) |>
  slice(1:10)
View(x)

# --------------------------------------------------------------------------------------------
# 3. Does departure delay correlate with arrival delay differently for each airline?
# --------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------
# 4. At what time of day do flights tend to depart earliest (least delay)?
# --------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------
# 5. Which destinations are most impacted by weather (proxy: high dep_delay variance)?
# --------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------
# 6. Create a plot showing how arrival delays evolve through the year.
# --------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------
# 7. Which aircraft (tail numbers) show abnormal delay patterns?
# --------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------
# 8. What is the relationship between distance and arrival delay?
# --------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------
# 9. Which airport (origin) performs better when factoring weather, delays, and cancellation rates?
# --------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------
# 10. Identify hidden seasonality: which months have unusually high delay peaks relative to others?
# --------------------------------------------------------------------------------------------
