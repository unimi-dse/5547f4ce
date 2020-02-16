#' Transition martix builder from inexact transition rate matrix
#'
#' Adjusts an inexact transition matrix, which may have zero-rows and zero-columns and/or may
#' showcase sums of rows that slightly differ from 1. This two aspects may
#' occur as a result of parsing a transition rate matrix as given by ESMA website (see
#' \code{\link{ESMAtransRateReader}}), where certain credit ratings are never experienced
#' and decimal representation of fractions leads to approximation errors.
#'
#' @param T A transition rate matrix
#'
#' @return The adjusted transition matrix
#'
#' @examples
#'  A <- matrix(c(0.33, 0.66, 0.00, 0.00,
#'                0.16, 0.17, 0.66, 0.00,
#'                0.50, 0.00, 0.50, 0.00,
#'                0.00, 0.00, 0.00, 0.00), nrow = 4, byrow = TRUE)
#'  matrixBuilder(A)
#'
#' @export
matrixBuilder <- function(T) {
  nam <- colnames(T)

  # Remove unexplored states, i.e. 0-sum rows/cols
  z <- which(rowSums(T) == 0)
  if( length(z) > 0 ) {
    nam <- nam[-z]
    T <- T[-z,-z]
  }

  m <- nrow(T)
  n <- ncol(T)
  if("Withdrawals" %in% nam)
    T <- rbind(T, c(rep(x=0, length.out = (n-1)) , 1) )

  # Adjusts inexact sum due to approximation.
  # Takes deviations from 1 and equally distributes them to
  # non-zero entries of each row.
  whichErr <- which(rowSums(T) != 1)
  for(i in whichErr) {
    diff <- 1 - sum(T[i,])
    nz <- which(T[i,] != 0)
    len <- length(nz)
    T[i,nz] <- T[i,nz] + diff/len
  }

  dimnames(T) <- list(nam, nam)
  return(T)
}
