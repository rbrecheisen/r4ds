library(tidyverse)

View(diamonds)

diamonds |> 
  filter(carat < 3) |>
  ggplot(aes(x = carat)) +
    geom_histogram(binwidth = 0.01) +
    scale_x_continuous(n.breaks = 15)
