install.packages(c("lvplot"))

library(tidyverse)
library(lvplot)

View(diamonds)

diamonds |> 
  filter(carat < 3) |>
  ggplot(aes(x = carat)) +
    geom_histogram(binwidth = 0.01) +
    scale_x_continuous(n.breaks = 15)

# Display scheduled departure times in two plots where the left
# shows the flights that were not canceled. The right those that
# were canceled. 
nycflights13::flights |> 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + (sched_min / 60)
  ) |> 
  ggplot(aes(x = sched_dep_time)) +
  geom_freqpoly(aes(color = cancelled, y = after_stat(density)),
                binwidth = 1/4) +
  facet_wrap(~ cancelled)

ggplot(mpg, aes(x = class, y = hwy)) +
  geom_boxplot()

# The fct_reorder() function takes the x-variable, here class, and sorts the 
# variable values (factors) by the second variable, here hwy, according to some
# function, here median. So x becomes a new list of factors that have been sorted
# by the median hwy variable.
ggplot(mpg, aes(x = fct_reorder(class, hwy, median), y = hwy)) +
  geom_boxplot() +

  # Flip the plot 90 degrees
  coord_flip()

diamonds |> 
  filter(carat < 3) |>
  ggplot(aes(x = price, y = cut)) +
  geom_boxplot()

diamonds |> 
  filter(carat < 3) |>
  ggplot(aes(x = price, y = cut)) +
  geom_lv()

diamonds |> 
  count(color, cut) |>  
  ggplot(aes(x = color, y = cut)) +
  geom_tile(aes(fill = n))

diamonds |> 
  filter(x >= 4) |> 
  ggplot(aes(x = x, y = y)) +
  geom_point() +
  coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))
