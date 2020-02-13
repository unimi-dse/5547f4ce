#' Shiny App
#'
#' Wraps the shiny app start function of package \code{mctools}.
#'
#' @usage GUI()
#'
#' @export
GUI <- function(){

  shiny::runApp(system.file("shiny/GUI", package = "mctools"))

}
