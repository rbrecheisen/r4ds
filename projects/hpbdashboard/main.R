library(tidyverse)

# ----------------------------------------------------------------------------------
# General info about dataset
# ----------------------------------------------------------------------------------
# (1)  How many liver procedures did we do in the last N monhts? 
# There are different resection types, procedure types (resection, ablation),
# resection type and ablation type.

# ----------------------------------------------------------------------------------
# Load data
# ----------------------------------------------------------------------------------
study_results <- readxl::read_excel("D:\\Castor\\ESPRESSO_v3.0_participant_data_excel_2025_11_19-15_49_42\\ESPRESSO_v3.0_excel_export_20251119034941.xlsx")
study_results
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
    lever_pancreas = readr::parse_number(lever_pancreas)
  )

# ----------------------------------------------------------------------------------
# Count nr. liver and pancreas rows
# ----------------------------------------------------------------------------------
study_results_clean_cols_correct_types |>
  summarize(
    liver = sum(lever_pancreas == 0, na.rm = TRUE),
    pancreas = sum(lever_pancreas == 1, na.rm = TRUE)
  )
