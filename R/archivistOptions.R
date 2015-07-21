##    archivist package for R
##
#' @title Default options for Archivist
#'
#' @description
#' \code{setArchivistOptions} and \code{getArchivistOptions} set and get default opitions
#' for many \code{archivist} functions.
#' 
#' @details
#' \code{setArchivistOptions} function sets a parameter that will be stored in internal environment.
#' \code{getArchivistOptions} returns value of given parameter.
#' Both functions are used for setting default values for parameters in archivist functions.
#' Currently works for arguments: silent

#' @return
#' Both functions return value that corresponds to a selected key.
#' 
#' @param key Name of the parameter.
#' 
#' @param value New value of the 'key' parameter.
#' 
#' @author 
#' Przemysław Biecek, \email{przemyslaw.biecek@@gmail.com}
#'
#' @examples
#' # objects preparation
#' \dontrun{
#' # turn off warnings in saveToRepo()
#' setArchivistOptions("silent", FALSE)
#' }
#' @family archivist
#' @rdname archivistOptions
#' @export
setArchivistOptions <- function(key, value) {
  stopifnot( is.character( key ) )
  .ArchivistEnv[[key]] <- value
  value
}

getArchivistOptions <- function(key) {
  stopifnot( is.character( key ) )
  .ArchivistEnv[[key]]
}
