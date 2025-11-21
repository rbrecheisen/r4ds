library(tidyverse)

# ----------------------------------------------------------------------------------
# General info about dataset
# ----------------------------------------------------------------------------------
#
# How many liver procedures did we perform in the last N months?
#
# We have different resection types, e.g., "wedge", "hemi", "extended_hemi, other", etc. We
# also have different procedure types, e.g., "ablation", "resection", "both". Also
# make sure you're able to visualize the number of "canceled" procedures. Not sure
# if this value is part of the resection types or procedure types.


# ----------------------------------------------------------------------------------
# File paths
# ----------------------------------------------------------------------------------
excel_file_path_indexes <- "D:\\Castor\\ESPRESSO_v3.0_participant_data_excel_2025_11_19-15_49_42\\ESPRESSO_v3.0_excel_export_20251119034941.xlsx"
excel_file_path_names <- "D:\\Castor\\ESPRESSO_v3.0_participant_data_excel_2025_11_20-12_22_30\\ESPRESSO_v3.0_excel_export_20251120122229.xlsx"


# ----------------------------------------------------------------------------------
# Load data
# ----------------------------------------------------------------------------------
study_results <- readxl::read_excel(excel_file_path_names)


# ----------------------------------------------------------------------------------
# Clean up column names
# ----------------------------------------------------------------------------------
study_results_clean_cols <- janitor::clean_names(study_results)


# ----------------------------------------------------------------------------------
# Convert columns to correct data type
# ----------------------------------------------------------------------------------
study_results_clean_cols_correct_types <- study_results_clean_cols |>
  mutate(
    lever_pancreas = tolower(lever_pancreas),
    sex = tolower(sex)
  )


# ----------------------------------------------------------------------------------
# Count nr. liver and pancreas rows
# ----------------------------------------------------------------------------------
study_results_clean_cols_correct_types |>
  summarize(
    liver = sum(lever_pancreas == "lever", na.rm = TRUE),
    pancreas = sum(lever_pancreas == "pancreas", na.rm = TRUE)
  )


# ----------------------------------------------------------------------------------
# Count nr. of liver procedures
# ----------------------------------------------------------------------------------
nr <- nr_liver_procedures(
  arg_data = study_results_clean_cols_correct_types,
  arg_start_date = as.Date("2025-11-20"),
  arg_end_date = as.Date("2025-11-21"),
  arg_resection_types = "all",
  arg_procedure_types = "all",
  arg_resection_procedure_types = "all",
  arg_ablation_procedure_types = "all"
)