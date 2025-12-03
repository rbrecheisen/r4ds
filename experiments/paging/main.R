# app.R
library(shiny)
library(shiny.router)

# --- Page UIs -------------------------------------------------------------

home_page <- div(
  h2("Home page"),
  p("This is the home page."),
  br(),
  actionLink("to_about", "Go to About page")
)

about_page <- div(
  h2("About page"),
  p("This is the about page."),
  br(),
  actionLink("to_home", "Back to Home page")
)

# --- App UI with router ---------------------------------------------------

ui <- fluidPage(
  titlePanel("shiny.router + actionLink demo"),
  tags$hr(),
  router_ui(
    route("/", home_page),     # default route
    route("about", about_page) # second page
  )
)

# --- Server ---------------------------------------------------------------

server <- function(input, output, session) {
  # Initialize router
  router_server(root_page = "/")

  # Use actionLink clicks to change the current page
  observeEvent(input$to_about, {
    change_page("about")
  })

  observeEvent(input$to_home, {
    change_page("/")
  })
}

# --- Run app --------------------------------------------------------------

shinyApp(ui, server)
