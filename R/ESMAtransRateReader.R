#' Transition rate matrix reader from ESMA website
#'
#' Reads a .csv file in the given format available at \url{https://cerep.esma.europa.eu/cerep-web/statistics/transitionMatrice.xhtml}
#' ("CSV export") and parses it. The content of such file includes the name of the credit rating agency, the period and time horizon
#' of statistics, the cardinal matrix of transitions and the transition rate matrix.
#'
#' @param filepath The character string of the path at which the .csv file is stored.
#'
#' @return list
#' \describe{
#'   \item{title}{The name of the CRA}
#'   \item{mat}{The transition rate matrix}
#' }
#'
#' @examples
#' \dontrun{
#'   ESMAtransRateReader("cerep878219543695070733.csv")
#'   ESMAtransRateReader(system.file(
#'                        'extdata', "cerepJCRA.csv",
#'                        package = 'mctools'))
#' }
#'
#' @importFrom utils read.csv
#' @export
ESMAtransRateReader <- function(filepath) {
  conn <- file(filepath, open = "r")

  # TITLE GETTER #
  first_line <- readLines(conn,n=1)
  pattern="\\[(.*?)\\]"
  result <- regmatches(first_line,regexec(pattern,first_line))
  title <- result[[1]][2]

  # TRANSITION MATRIX GETTER #
  lin <- readLines(conn, warn = F)
  close(conn)
  # Searches for start line
  start <- grep("Transition rate", lin)
  lin <- lin[-c(1:start)]
  # Searches for end line
  end <- which(lin == "")[1]
  lin <- lin[-c(end:length(lin))]
  # Removes quotes
  lin <- gsub("\"", "", lin)
  # Removes corner cell
  lin[1] <- sub("BOP / EOP,", "", lin[1])
  # Builds transition matrix
  tab <- read.csv(textConnection(lin))
  mat <- as.matrix(tab)
  mat <- mctools::percToNum(mat)
  mat <- mctools::matrixBuilder(mat)

  return(list("title" = title,"mat" = mat))
}




