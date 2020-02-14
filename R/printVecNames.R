#' Vector print
#'
#' Chains the elements of a vector along with their names in a string in the format
#' \code{"el_1 = val_1, el_2 = val_2, ..."}.
#'
#' @param v A vector to be printed
#'
#' @return A string containing the elements of the vector separated by "\code{,}"
#'
#' @examples
#' printVecNames(c("State 1" = "sunny, "State 2" = "cloudy", "State 3" = "rainy"))
#'
#' @export
printVecNames <- function(v) {
  if(is.null(v) || length(v) == 0)
    return(NULL)
  return(paste(paste(names(v), v, sep = " = "),
          collapse = ",  "))
}
