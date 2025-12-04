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
  fileInput(
    inputId = "excel_file",
    label = "Choose your Excel file for upload",
    accept = c(".xlsx", ".xls")
  ),
  br(),
  verbatimTextOutput("upload_info"),
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
  p("Preview of the uploaded data (first 5 rows):"),
  tableOutput("prep_preview"),
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
  verbatimTextOutput("vis_info"),
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
  excel_data <- reactiveVal(NULL)

  # Handle upload of Excel file, create dataframe and store
  observeEvent(input$excel_file, {
    req(input$excel_file)
    df <- readxl::read_excel(input$excel_file$datapath)
    excel_data(df)
  })

  # Output upload info to upload page
  output$upload_info <- renderPrint({
    df <- excel_data()
    if (is.null(df)) {
      cat("No Excel file uploaded yet.")
    } else {
      cat("Excel file loaded.\n")
      cat("Rows:", nrow(df), " | Columns:", ncol(df), "\n")
      cat("Column names:\n")
      print(names(df))
    }
  })

  # When the preparation page is opened, show a preview of the data (first 5 rows)
  output$prep_preview <- renderTable({
    req(excel_data())
    head(excel_data(), 5)
  })

  # When visualization page is opened, show a raw data summary of the uploaded file
  output$vis_info <- renderPrint({
    df <- excel_data()
    if (is.null(df)) {
      cat("Please upload an Excel file on the upload page first.")
    } else {
      cat("Data is available for visualization.\n")
      str(df)
    }
  })

  # Navigation
  observeEvent(input$to_preparation, { change_page("preparation") })
  observeEvent(input$to_visualization, { change_page("visualization") })
  observeEvent(input$to_upload, { change_page("/") })
}


# --------------------------------------------------------------------------
# Run app
# --------------------------------------------------------------------------
shinyApp(ui, server)
