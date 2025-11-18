required_packages <- c(
  "arrow",
  "httr",
  "dplyr"
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