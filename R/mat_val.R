#' Transition matrix validation
#'
#' Validates a transition matrix. Checks that each entry of the matrix is a non-negative
#' number and that each row add up to 1.
#'
#' @param M A candidate transition matrix.
#'
#' @return A character string specifing the cause of invalidation, or the matrix itself if it is valid.
#'
#' @examples
#' A <- matrix(c(0.33, 0.66, 0.00, 0.00,
#'                0.16, 0.17, 0.66, 0.00,
#'                0.50, 0.00, 0.50, 0.00,
#'                0.00, 0.00, 0.00, 0.00), nrow = 4, byrow = TRUE)
#' mat_val(A)
#' mat_val(matrixBuilder(A))
#'
#' @export
# Transition matrix validation function
mat_val <- function(M) {
  if(is.null(M) || !as.logical(prod(!is.na(M))) || length(which(M<0)) > 0 ) {
    "Invalid transition matrix"
  } else if(!as.logical(prod(base::rowSums(M) == 1))) {
    "Each row of the transition matrix must add up to 1"
  } else {
    M
  }
}
