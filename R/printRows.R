#' @export
printRows <- function(M) {
  if(is.null(M))
    return(NULL)
  out <- ""
  n <- nrow(M)
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

  out

}
