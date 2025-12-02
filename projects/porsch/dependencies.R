required_packages <- c(
  "tidyverse",
  "janitor",
  "xgboost",
  "mice"
)

install_if_missing <- function(pkgs) {
  missing <- pkgs[!(pkgs %in% installed.packages()[, "Package"])]
  if(length(missing)) {
    message("Installing missing packages: ", paste(missing, collapse = ", "))
    install.packages(missing, dependencies = TRUE)
  }
}

install_if_missing(required_packages)

invisible(lapply(required_packages, library, character.only = TRUE))

for (file in list.files("R", full.names = TRUE, recursive = TRUE)) {
  source(file)
}