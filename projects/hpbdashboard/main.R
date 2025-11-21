library(tidyverse)

source("../utils/os.R")
source("R/liver.R")


# ----------------------------------------------------------------------------------
# File paths
# ----------------------------------------------------------------------------------
excel_file_path_windows = "C:\\Users\\r.brecheisen\\OneDrive - Maastricht University\\Research\\Data\\ESPRESSO_v3.0_excel_export_20251120045651.xlsx"
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
    sex = tolower(sex),
    date_mdo = as.Date(date_mdo, format = "%d-%m-%Y"),
    date_operatie = as.Date(date_operatie, format = "%d-%m-%Y"),
    datum_ontslag = as.Date(datum_ontslag, format = "%d-%m-%Y"),
    operatie_lever_number_wigresectie = as.integer(operatie_lever_number_wigresectie),
    operatie_lever_number_segmentresectie = as.integer(operatie_lever_number_segmentresectie),
    operatie_lever_number_hemihepatectomie = as.integer(operatie_lever_number_hemihepatectomie),
    operatie_lever_number_extended_hemihepatectomie = as.integer(operatie_lever_number_extended_hemihepatectomie),
    operatie_lever_number_galwegresectie = as.integer(operatie_lever_number_galwegresectie),
    operatie_lever_number_cholecystectomie = as.integer(operatie_lever_number_cholecystectomie),
    operatie_lever_number_klierdissectie = as.integer(operatie_lever_number_klierdissectie),
    operatie_lever_number_anders = as.integer(operatie_lever_number_anders),
    operatie_lever_number_operatie_niet_doorgegaan = as.integer(operatie_lever_number_operatie_niet_doorgegaan)
  ) |>
  # Remove rows with a date in the future
  filter(date_operatie <= Sys.Date())


# ----------------------------------------------------------------------------------
# Show nr. of liver and pancreas rows
# ----------------------------------------------------------------------------------
study_results_clean_cols_correct_types |>
  summarize(
    liver = sum(lever_pancreas == "lever", na.rm = TRUE),
    pancreas = sum(lever_pancreas == "pancreas", na.rm = TRUE),
  )


# ----------------------------------------------------------------------------------
# Get earliest and latest operation dates
# ----------------------------------------------------------------------------------
date_min <- min(study_results_clean_cols_correct_types$date_operatie, na.rm = TRUE)
date_max <- max(study_results_clean_cols_correct_types$date_operatie, na.rm = TRUE)


# ----------------------------------------------------------------------------------
# Count nr. of liver procedures
# ----------------------------------------------------------------------------------
nr <- nr_liver_procedures(
  data = study_results_clean_cols_correct_types,
  start_date = date_min,
  end_date = date_max,
  resection_type = "",
  procedure_types = "",
  resection_procedure_types = "",
  ablation_procedure_types = ""
)
print(nr)