##    archivist package for R
##
#' @title Default options for Archivist
#'
#' @description
#' The function \code{aoptions} sets and gets default options
#' for other \code{archivist} functions.
#' 
#' @details
#' The function \code{aoptions} with two arguments sets default values 
#' of arguments for other \code{archivist} functions (stored in an internal environment).
#' The function \code{aoptions} with one argument returns value of given parameter.
#' It is used for setting default values for parameters in archivist functions.
#' Currently works for arguments: silent
#' 
#' @return
#' The function returns value that corresponds to a selected key.
#' 
#' @param key Name of the parameter.
#' 
#' @param value New value for the 'key' parameter.
#' 
#' @author 
#' Przemysław Biecek, \email{przemyslaw.biecek@@gmail.com}
#'
#' @examples
#' # objects preparation
#' \dontrun{
#' # turn off warnings in saveToRepo()
#' aoptions("silent", FALSE)
#' aoptions("silent")
#' }
#' 
#' @family archivist
#' @rdname archivistOptions
#' @export
aoptions <- function(key, value=NULL) {
  stopifnot( is.character( key ) )
  if (!is.null(value)) {
    .ArchivistEnv[[key]] <- value
  } 
  .ArchivistEnv[[key]]
}
