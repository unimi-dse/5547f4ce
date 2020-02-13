#' Transition matrix generator
#'
#' Generate a transition matrix (square matrix whose rows sum 1), given its
#' dimension and a probability of non-connection.
#'
#' @param n The dimension (nrow = ncol) of the matrix to be created
#' @param p The probability that one generic element of the matrix will be set to 0.
#'
#' @note Entering a probability of non-connection overcomes the problem that, when
#' generating a continuosly and uniformly distributed sequence, the probability to
#' obtain 0 is 0.
#'
#' @examples
#' mat_gen(4,0.2)
#'
#' @importFrom stats runif
#' @export
mat_gen <- function(n,p) {
  outMat <- diag(n)
  for(i in c(1:n)) {
    newRow <- runif(n)
    assign0 <- (runif(n) < p)
    newRow[assign0] <- 0
    newRow <- newRow/sum(newRow)
    outMat[i,] <- newRow
  }
  return(outMat)
}
