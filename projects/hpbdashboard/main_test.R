library(tidyverse)

source("R/liver.R")

excel_file_path_names <- "D:\\Castor\\ESPRESSO_v3.0_participant_data_excel_2025_11_20-12_22_30\\ESPRESSO_v3.0_excel_export_20251120122229.xlsx"

nr_liver_procedures(
  arg_data = readxl::read_excel(excel_file_path_names),
  arg_start_date = as.Date("2025-11-20"),
  arg_end_date = as.Date("2025-11-21"),
  arg_resection_types = "all",
  arg_procedure_types = "all",
  arg_resection_procedure_types = "all",
  arg_ablation_procedure_types = "all"
)
