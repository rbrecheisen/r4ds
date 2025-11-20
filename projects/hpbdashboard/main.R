library(tidyverse)

source("../utils/os.R")

# ----------------------------------------------------------------------------------
# General info about dataset
# ----------------------------------------------------------------------------------
# (1)  How many liver procedures did we perform in the last N months? 


# ----------------------------------------------------------------------------------
# File paths
# ----------------------------------------------------------------------------------
excel_file_path_windows = "D:\\Castor\\ESPRESSO_v3.0_participant_data_excel_2025_11_19-15_49_42\\ESPRESSO_v3.0_excel_export_20251119034941.xlsx"
excel_file_path_macos = "/Users/ralph/Library/CloudStorage/OneDrive-MaastrichtUniversity/Research/Data/ESPRESSO_v3.0_excel_export_20251120045651.xlsx"
excel_file_path_names <- if(is_windows()) excel_file_path_windows else excel_file_path_macos


# ----------------------------------------------------------------------------------
# Load data
# ----------------------------------------------------------------------------------
study_results <- readxl::read_excel(excel_file_path_names)


# ----------------------------------------------------------------------------------
# Clean up column names
# ----------------------------------------------------------------------------------
study_results_clean_cols <- janitor::clean_names(study_results)


# ----------------------------------------------------------------------------------
# Create lower-case column names for some columns
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
