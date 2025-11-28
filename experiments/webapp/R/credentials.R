library(shinymanager)

shinymanager::create_db(
  credentials_data = data.frame(
    user = "ralph",
    password = "test123",
    stringsAsFactors = FALSE
  ),
  sqlite_path = "inst/secure/credentials.sqlite"
)