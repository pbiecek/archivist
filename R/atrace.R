##    archivist package for R
##
#' @title Add Tracing For All Objects Created By Given Function
#'
#' @description
#' \code{atrace} add call to \link{saveToLocalRepo} at the end of a given function.
#' 
#' @details
#' Function \code{atrace} calls the \link{trace} function.
#' 
#' @param FUN name of a function to be traced (character)
#' 
#' @param object name of an object that should be traced (character)
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' @template roxlate-references
#' @template roxlate-contact
#' 
#' @examples
#' # read the object from local directory
#' \dontrun{
#' createLocalRepo("arepo_test", default=TRUE)
#' atrace("lm", "z")
#' lm(Sepal.Length~Sepal.Width, data=iris)
#' asearch("class:lm")
#' untrace("lm")
#' }
#' @family archivist
#' @rdname atrace
#' @export
atrace <- function(FUN = "lm", object = "z"){
  stopifnot( is.character( aoptions("repoDir") ) )
  trace(FUN, exit = substitute(saveToLocalRepo(get(.object.)), list(.object. = object)))
}
