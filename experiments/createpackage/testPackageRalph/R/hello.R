#' Say hello
#'
#' A very small example function.
#'
#' @param name A character string.
#'
#' @return A character string greeting.
#' @export
#'
#' @examples
#' hello("Ralph")
hello <- function(name = "world") {
  paste("Hello,", name)
}