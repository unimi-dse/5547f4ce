#' @export
printVecNames <- function(v) {
  if(is.null(v) || length(v) == 0)
    return(NULL)
  paste(paste(names(v), v, sep = " = "),
        collapse = ",  ")
}
