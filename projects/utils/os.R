is_windows <- function() {
  return (Sys.info()[["sysname"]] == "Windows")
}

is_macos <- function() {
  return (Sys.info()[["sysname"]] == "Darwin")
}