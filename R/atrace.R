##    archivist package for R
##
#' @title Add Tracing For All Objects Created By Given Function
#'
#' @description
#' \code{atrace} add call to \link{saveToLocalRepo} at the end of a given function.
#' 
#' @details
#' Function \code{atrace} calls the \link{tace} function.
#' 
#' @param FUN the function to be traced (quoted name)
#' 
#' @param object name of object that should be traced
#' 
#' @param repoDir repo in which results should be stored
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' @examples
#' # read the object from local directory
#' createLocalRepo("arepo_test", default=TRUE)
#' atrace("lm", z)
#' lm(Sepal.Length~Sepal.Width, data=iris)
#' asearch("class:lm")
#' @family archivist
#' @rdname atrace
#' @export
atrace <- function(FUN = "lm", object = "z", repoDir = aoptions("repoDir")){
  stopifnot( is.character( md5hash ) )
  trace(FUN, exit = quote(saveToLocalRepo(get(object), repoDir=repoDir)))
}
