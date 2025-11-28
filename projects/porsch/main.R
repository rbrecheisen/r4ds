source("dependencies.R")

library(tidyverse)

df <- readxl::read_excel("D:\\Mosamatic\\NicoleHildebrand\\PORSCH\\PORSCH_complete.xlsx")

preop_vars <- c(
  "gender_castor_x", 
  "age_surgery_x",
  "lengte", 
  "gewicht", 
  "crp",
  "smra", 
  "muscle_area", 
  "vat_area", 
  "sat_area",
  "vat_ra", 
  "sat_ra",
  "datopn", 
  "datont_castor"
)

x <- df |>
  select(any_of(preop_vars)) |>
  mutate(
    datopn = as.Date(datopn),
    datont_castor = as.Date(datont_castor),
    hospital_stay = as.numeric(datont_castor - datopn)
  )