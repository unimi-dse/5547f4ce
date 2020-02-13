#' Matrix rows print
#'
#' Chains the rows of a matrix into a single string in the format
#' "\code{V1 = \{...\}, V2 = \{...\}, ...}".
#'
#' @param M A matrix
#'
#' @return A string containing the rows of M.
#'
#' @examples
#' printRows(round(mat_gen(3,0.2),3))
#'
#' @export
printRows <- function(M) {
  vec <- is.vector(M)
  mat <- (is.matrix(M) || is.data.frame(M))
  nonnull <- !is.null(M)
  out <- ""
  if((vec || mat) && nonnull) {
    if(mat)
      n <- nrow(M)
    if(vec)
      n <- length(M)
    i <- 0
    if( n > 1 ) {
      for( i in c(1:(n-1)) ) {
        out <- paste(out,
                     sprintf("V%d = ", i),
                     "{",
                     paste(M[i,], collapse = " "),
                     "}, ",
                     sep = "")
      }
    }
    i <- i+1
    out <- paste(out,
                 sprintf("V%d = ", i),
                 "{",
                 paste(M[i,], collapse = " "),
                 "}",
                 sep = "")
  }
  return(out)
}
