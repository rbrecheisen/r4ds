# Resection types
RESECTION_TYPES = c(
  "wedge" = "Wigresectie",
  "segment" = "Segmentresectie",
  "hemi" = "Hemihepatectomie",
  "extended_hemi" = "Extended hemihepatectomie",
  "bile_ducts" = "Galwegresectie",
  "cholecystectomy" = "Cholecystectomie",
  "gland" = "Klierdissectie",
  "other" = "Anders",
  "canceled" = "Operatie niet doorgegaan"
)

# Procedure types
PROCEDURE_TYPES = c(
  "resection" = "Resectie",
  "ablation" = "Ablatie",
  "resection_ablation" = "Resectie en ablatie",
  "not_applicable" = "Niet van toepassing"
)

# Resection procedure types
RESECTION_PROCEDURE_TYPES = c(
  "open" = "Open procedure",
  "laparoscopic" = "Volledig laparoscopische procedure",
  "laparoscopic_converted" = "Laparoscopisch met conversie",
  "robot" = "Volledig robot",
  "robot_converted_laparoscopic" = "Robot met conversie naar laparoscopie",
  "robot_converted_open" = "Robot met conversie naar open",
  "no_resection" = "Exploratie zonder resectie",
  "other" = "Overig"
)

# Ablation procedure types
ABLATION_PROCEDURE_TYPES = c(
  "percutaneous" = "Percutanale ablatie",
  "open" = "Open ablatie",
  "laparoscopic" = "Laparoscopische ablatie",
  "unknown" = "Onbekend"
)


# ----------------------------------------------------------------------------------
# Calculate number of liver procedures
# ----------------------------------------------------------------------------------
nr_liver_procedures <- function(
  data, 
  start_date, 
  end_date,
  resection_types,
  procedure_types,
  resection_procedure_types,
  ablation_procedure_types
) {

  # 

  # Filter and count the resulting rows
  # QUESTION: How to filter on one-hot encoded columns?
  result <- data |>
    filter(
      lever_pancreas == "lever",
      date_operatie >= start_date,
      date_operatie <= end_date
    )
  nr <- nrow(result)

  return (nr)
}