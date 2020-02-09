#' Percentage to numeric
#'
#' @description
#' Turns a character vector or matrix of percentages into numeric (dividing by 100).
#'
#' @param x A vector or matrix of strings that contains characters interpreted as numbers, except \code{%}.
#'
#' @return The numeric vector or matrix resulting. \code{dimnames} is left unchanged.
#'
#' @example
#' percToNum(c("2.13%", "5%", "-12.12%", "4%", "1.2%"))
#'
#' @export
percToNum <- function(x) {
  if( is.vector(x)) {
    nam <- names(x)
    vec <- as.numeric(sub("%","",x))/100
    names(vec) <- nam
    return(vec)
  }

  else if( is.matrix(x) ) {
    nam <- dimnames(x)
    m <- nrow(x)
    n <- ncol(x)
    vec <- as.numeric(sub("%","",x))/100
    return(matrix(vec, nrow = m, ncol = n, dimnames = nam))
  }

}
