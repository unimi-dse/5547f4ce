#' Shiny App
#'
#' Wraps the start function of shiny app for Markov Chain analysis. Check
#' \url{https://github.com/unimi-dse/5547f4ce/blob/master/README.md}
#' for a complete description of available tools.
#'
#' @usage GUI()
#'
#' @export
GUI <- function(){

  shiny::runApp(system.file("shiny/GUI", package = "mctools"))

}
