##    archivist package for R
##
#' @title Search for an Object in a Repository using Tags
#'
#' @description
#' desc
#' 
#' 
#' @details
#' details
#' 
#' @param tag A character string denoting a Tag to seek for. See details.
#' 
#' @param dir A character denoting an existing directory from which objects will be searched.
#' 
#' @param repo Only if working on Github Repository. A character string containing a name of Github Repository.
#' 
#' @param user Only if working on Github Repository. A character string containing a name of Github User.
#'
#' @author autor
#'
#' @examples
#' #example
#' @family archivist
#' @rdname searchInRepo
#' @export
searchInLocalRepo <- function( tag, dir ){
  stopifnot( is.character( c( tag, dir ) ) )
  
}

#' @rdname searchInRepo
#' @export
searchInGithubRepo <- function( tag, repo, user ){
  stopifnot( is.character( c( tag, repo, user ) ) )
  
}