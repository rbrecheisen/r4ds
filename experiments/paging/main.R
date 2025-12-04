# --------------------------------------------------------------------------
# Install and load dependencies
# --------------------------------------------------------------------------
required_packages <- c("shiny", "shiny.router")
install_if_missing <- function(pkgs) {
  missing <- pkgs[!(pkgs %in% installed.packages()[, "Package"])]
  if(length(missing)) {
    message("Installing missing packages: ", paste(missing, collapse = ", "))
    install.packages(missing, dependencies = TRUE)
  }
}
install_if_missing(required_packages)
invisible(lapply(required_packages, library, character.only = TRUE))
library(shiny)
library(shiny.router)


# --------------------------------------------------------------------------
# Upload page
# --------------------------------------------------------------------------
upload_page <- div(
  h2("Upload your Excel data"),
  p("This is the upload page"),
  br(),
  actionLink("to_preparation", "Go to preparation page")
)


# --------------------------------------------------------------------------
# Data preparation page
# --------------------------------------------------------------------------
preparation_page <- div(
  h2("Preparing your data"),
  p("This is a page for preparing your data"),
  br(),
  actionLink("to_visualization", "Go to visualization page"),
  actionLink("to_upload", "Back to upload page")
)


# --------------------------------------------------------------------------
# Data preparation page
# --------------------------------------------------------------------------
visualization_page <- div(
  h2("Visualizing your data"),
  p("This is a page for visualizing your data nicely"),
  br(),
  actionLink("to_preparation", "Back to preparation page"),
  actionLink("to_upload", "Back to upload page")
)


# --------------------------------------------------------------------------
# Main UI with router
# --------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Shiny template"),
  tags$hr(),
  router_ui(
    route("/", upload_page),
    route("upload", upload_page),
    route("preparation", preparation_page),
    route("visualization", visualization_page)
  )
)


# --------------------------------------------------------------------------
# Main server
# --------------------------------------------------------------------------
server <- function(input, output, session) {
  router_server(root_page = "/")
  observeEvent(input$to_preparation, {
    change_page("preparation")
  })
  observeEvent(input$to_visualization, {
    change_page("visualization")
  })
  observeEvent(input$to_upload, {
    change_page("/")
  })
}


# --------------------------------------------------------------------------
# Run app
# --------------------------------------------------------------------------
shinyApp(ui, server)
