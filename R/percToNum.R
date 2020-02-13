#' Percentage to numeric
#'
#' Turns a character vector or matrix of percentages into numeric (dividing by 100).
#'
#' @param Y A vector or matrix of strings that contains characters interpreted as numbers, except \code{\%}.
#'
#' @return The numeric vector or matrix resulting. \code{dimnames} is left unchanged.
#'
#' @examples
#' percToNum(c("2.13%", "5%", "-12.12%", "4%", "1.2%"))
#'
#' @export
percToNum <- function(Y) {
  if( is.vector(Y)) {
    nam <- names(Y)
    vec <- as.numeric(sub("%","",Y))/100
    names(vec) <- nam
    return(vec)
  }

  else if( is.matrix(Y) ) {
    nam <- dimnames(Y)
    m <- nrow(Y)
    n <- ncol(Y)
    vec <- as.numeric(sub("%","",Y))/100
    return(matrix(vec, nrow = m, ncol = n, dimnames = nam))
  }

  return(NULL)
}
