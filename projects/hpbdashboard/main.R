library(tidyverse)

# ----------------------------------------------------------------------------------
# General info about dataset
# ----------------------------------------------------------------------------------
# (1)  How many liver procedures did we perform in the last N months? 
# (2)  How many pancreas procedures did we perform in the last N months?


# ----------------------------------------------------------------------------------
# File paths
# ----------------------------------------------------------------------------------
excel_file_path_indexes <- "D:\\Castor\\ESPRESSO_v3.0_participant_data_excel_2025_11_19-15_49_42\\ESPRESSO_v3.0_excel_export_20251119034941.xlsx"
excel_file_path_names <- "D:\\Castor\\ESPRESSO_v3.0_participant_data_excel_2025_11_20-12_22_30\\ESPRESSO_v3.0_excel_export_20251120122229.xlsx"


# ----------------------------------------------------------------------------------
# Load data
# ----------------------------------------------------------------------------------
study_results <- readxl::read_excel(excel_file_path_names)
View(study_results)


# ----------------------------------------------------------------------------------
# Clean up column names
# ----------------------------------------------------------------------------------
study_results_clean_cols <- janitor::clean_names(study_results)
View(study_results_clean_cols)


# ----------------------------------------------------------------------------------
# Convert columns to correct data type
# ----------------------------------------------------------------------------------
study_results_clean_cols_correct_types <- study_results_clean_cols |>
  mutate(
    site_abbreviation = tolower(site_abbreviation),
    lever_pancreas = tolower(lever_pancreas),
    sex = tolower(sex)
  )
View(study_results_clean_cols_correct_types)


# ----------------------------------------------------------------------------------
# Count nr. liver and pancreas rows
# ----------------------------------------------------------------------------------
study_results_clean_cols_correct_types |>
  summarize(
    liver = sum(lever_pancreas == "lever", na.rm = TRUE),
    pancreas = sum(lever_pancreas == "pancreas", na.rm = TRUE)
  )
