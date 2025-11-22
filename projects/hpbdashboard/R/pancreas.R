resection_types = c(
  "PPPD",
  "Klassieke whipple",
  "PRPD",
  "Pancreas lichaam/staart resectie met of zonder mistresectie",
  "Appleby",
  "Totale pancreatectomie",
  "Enucleatie pancreastumor",
  "Galwegresectie",
  "Frey",
  "Pancreaticojejunostomie",
  "Overig",
  "Operatie niet doorgegaan"
)

operatie_pancreas_techniek = c(
  "Open procedure",
  "Volledig laparoscopische "
)
# ----------------------------------------------------------------------------------
# Calculate number of liver procedures
# ----------------------------------------------------------------------------------
get_nr_pancreas_procedures <- function(
  data, 
  end_date,
  nr_months_lookback,
  resection_types,
  procedure_types
) {
}