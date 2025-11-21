# Resection types
RESECTION_TYPES = c(
  "wedge",
  "segment",
  "hemi",
  "extended_hemi",
  "bile_ducts",
  "cholecystectomy",
  "gland",
  "other",
  "canceled",
  "all"
)

# Procedure types
PROCEDURE_TYPES = c(
  "resection",
  "ablation",
  "all"
)

# Resection procedure types
RESECTION_PROCEDURE_TYPES = c(
  "open",
  "laparoscopic",
  "laparoscopic_converted",
  "robot",
  "robot_converted_laparoscopic",
  "robot_converted_open",
  "no_resection",
  "other",
  "all"
)

# Ablation procedure types
ABLATION_PROCEDURE_TYPES = c(
  "percutaneous",
  "open",
  "laparoscopic",
  "unknown",
  "all"
)

# ----------------------------------------------------------------------------------
# Calculate number of liver procedures
# ----------------------------------------------------------------------------------
nr_liver_procedures <- function(
  arg_data,
  arg_start_date, 
  arg_end_date, 
  arg_resection_types, 
  arg_procedure_types, 
  arg_resection_procedure_types, 
  arg_ablation_procedure_types
) {

  # Create local variables
  data <- arg_data
  start_date <- arg_start_date
  end_date <- arg_end_date
  resection_types <- arg_resection_types
  procedure_types <- arg_procedure_types
  resection_procedure_types <- arg_resection_procedure_types
  ablation_procedure_types <- arg_ablation_procedure_types

  # Convert single values to lists
  if(is_character(resection_types)) resection_types <- c(resection_types)
  if(is_character(procedure_types)) procedure_types <- c(procedure_types)
  if(is_character(resection_procedure_types)) resection_procedure_types <- c(resection_procedure_types)
  if(is_character(ablation_procedure_types)) ablation_procedure_types <- c(ablation_procedure_types)

  # Perform error checking of arguments
  if(!is.data.frame(data)) stop("Data should be dataframe")
  if(!is.Date(start_date)) stop("Start date should be date")
  if(!is.Date(end_date)) stop("End date should be date")
  if(!is.vector(resection_types)) stop("Resection types should be vector")
  if(!is.vector(procedure_types)) stop("Resection types should be vector")
  if(!is.vector(resection_procedure_types)) stop("Resection procedure types should be vector")
  if(!is.vector(ablation_procedure_types)) stop("Ablation procedure types should be vector")
  if(any(resection_types == "") || !all(resection_types %in% RESECTION_TYPES)) stop("Unknown resection types")
  if(any(procedure_types == "") || !all(procedure_types %in% PROCEDURE_TYPES)) stop("Unknown procedure types")
  if(any(resection_procedure_types == "") || !all(resection_procedure_types %in% RESECTION_PROCEDURE_TYPES)) stop("Unknown resection procedure types")
  if(any(ablation_procedure_types == "") || !all(ablation_procedure_types %in% ABLATION_PROCEDURE_TYPES)) stop("Unknown ablation procedure types")

  # Perform calculation

  # Return result
  return (0)
}