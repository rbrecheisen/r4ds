library(tidyverse)

source("../utils/os.R")
source("R/liver/nr_procedures.R")
source("R/pancreas/nr_procedures.R")
source("R/nr_days_between.R")


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
# Reformat certain columns with correct data type
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
    operatie_lever_number_operatie_niet_doorgegaan = as.integer(operatie_lever_number_operatie_niet_doorgegaan),

    resectie_ablatie_number_resectie_open_procedure = as.integer(resectie_ablatie_number_resectie_open_procedure),
    resectie_ablatie_number_resectie_volledig_laparoscopische_procedure = as.integer(resectie_ablatie_number_resectie_volledig_laparoscopische_procedure),
    resectie_ablatie_number_resectie_laparoscopisch_met_conversie_naar_open = as.integer(resectie_ablatie_number_resectie_laparoscopisch_met_conversie_naar_open),
    resectie_ablatie_number_resectie_volledig_robot = as.integer(resectie_ablatie_number_resectie_volledig_robot),
    resectie_ablatie_number_resectie_robot_met_conversie_naar_laparoscopie = as.integer(resectie_ablatie_number_resectie_robot_met_conversie_naar_laparoscopie),
    resectie_ablatie_number_resectie_robot_met_conversie_naar_open = as.integer(resectie_ablatie_number_resectie_robot_met_conversie_naar_open),
    resectie_ablatie_number_resectie_overig = as.integer(resectie_ablatie_number_resectie_overig),
    resectie_ablatie_number_ablatie_percunatale_ablatie = as.integer(resectie_ablatie_number_ablatie_percunatale_ablatie),
    resectie_ablatie_number_ablatie_open_ablatie = as.integer(resectie_ablatie_number_ablatie_open_ablatie),
    resectie_ablatie_number_ablatie_laparoscopische_ablatie = as.integer(resectie_ablatie_number_ablatie_laparoscopische_ablatie),
    resectie_ablatie_number_ablatie_onbekend = as.integer(resectie_ablatie_number_ablatie_onbekend),

    operatie_pancreas = janitor::make_clean_names(operatie_pancreas, allow_dupes = TRUE),
    operatie_pancreas_techniek = janitor::make_clean_names(operatie_pancreas_techniek, allow_dupes = TRUE)
  ) |>
  # Remove rows with a date in the future
  filter(date_operatie <= Sys.Date())

# print(study_results_clean_cols_correct_types$operatie_pancreas)

# ----------------------------------------------------------------------------------
# Show nr. of liver and pancreas rows
# ----------------------------------------------------------------------------------
study_results_clean_cols_correct_types |>
  summarize(
    liver = sum(lever_pancreas == "lever", na.rm = TRUE),
    pancreas = sum(lever_pancreas == "pancreas", na.rm = TRUE),
  )


# ----------------------------------------------------------------------------------
# Print relevant column names
# ----------------------------------------------------------------------------------
# print(names(study_results_clean_cols_correct_types)[startsWith(names(study_results_clean_cols_correct_types), "operatie_lever_")])
# print(names(study_results_clean_cols_correct_types)[startsWith(names(study_results_clean_cols_correct_types), "resectie_ablatie_")])
# print(names(study_results_clean_cols_correct_types)[startsWith(names(study_results_clean_cols_correct_types), "operatie_pancreas")])

# ----------------------------------------------------------------------------------
# Get earliest and latest operation dates
# ----------------------------------------------------------------------------------
date_min <- min(study_results_clean_cols_correct_types$date_operatie, na.rm = TRUE)
print(paste0("Earliest date: ", date_min))
date_max <- max(study_results_clean_cols_correct_types$date_operatie, na.rm = TRUE)
print(paste0("Latest date: ", date_max))


nr <- get_nr_liver_procedures(
  data = study_results_clean_cols_correct_types,
  end_date = date_max,
  nr_months_lookback = 36,
  resection_types = c(
    "wigresectie", 
    "segmentresectie",
    "hemihepatectomie",
    "extended_hemihepatectomie",
    "galwegresectie",
    "cholecystectomie",
    "klierdissectie",
    "anders",
    "operatie_niet_doorgegaan"
  ),
  procedure_types = c(
    "resectie_open_procedure",
    "resectie_volledig_laparoscopische_procedure",
    "resectie_laparoscopisch_met_conversie_naar_open",
    "resectie_volledig_robot",
    "resectie_robot_met_conversie_naar_laparoscopie",
    "resectie_robot_met_conversie_naar_open",
    "ablatie_percunatale_ablatie",
    "ablatie_open_ablatie",
    "ablatie_laparoscopische_ablatie",
    "ablatie_onbekend"
  )
)

print("")
print(paste0("Aantal lever procedures tussen ", date_min, " en ", date_max, " = ", nr))

nr <- get_nr_pancreas_procedures(
  data = study_results_clean_cols_correct_types,
  end_date = date_max,
  nr_months_lookback = 36,
  resection_types = c(
    "pppd",
    "klassieke_whipple",
    "prpd",
    "pancreas_lichaam_staart_resectie_met_of_zonder_mistresectie",
    "appleby",
    "totale_pancreatectomie",
    "enucleatie_pancreastumor",
    "galwegresectie",
    "frey",
    "pancreaticojejunostomie",
    "overig",
    "operatie_niet_doorgegaan"
  ),
  procedure_types = c(
    "open_procedure",
    "volledig_laparoscopische_procedure",
    "laparoscopisch_met_conversie_naar_open",
    "exploratie_zonder_resectie",
    "volledig_robot",
    "robot_met_conversie_naar_open",
    "robot_met_conversie_naar_laparoscopie",
    "overig"
  )
)

print("")
print(paste0("Aantal pancreas procedures tussen ", date_min, " en ", date_max, " = ", nr))

nr_days <- get_nr_days_between(
  data = study_results_clean_cols_correct_types,
  end_date = date_max,
  nr_months_lookback = 36,
  lever_pancreas = "lever",
  date_column1 = "date_mdo",
  date_column2 = "date_operatie"
)

print("")
print(paste0("Gemiddeld aantal dagen tussen MDO en operatie (lever): ", nr_days))