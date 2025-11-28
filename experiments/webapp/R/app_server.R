#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  res_auth <- shinymanager::secure_server(
    check_credentials = shinymanager::check_credentials("inst/secure/credentials.sqlite")
  )
  mod_main_server("main_1")
}
