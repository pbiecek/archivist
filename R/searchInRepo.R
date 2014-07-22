##    archivist package for R
##
#' @title Search for an Object in a Repository using Tags
#'
#' @description
#' \code{searchInRepo} searchs for an object in a repository using it's \code{Tag}.
#' 
#' 
#' @details
#' \code{searchInRepo} searchs for an object in a repository using it's \code{Tag}.
#' \code{Tags} can be an object's \code{name}, \code{class} or \code{archivisation date}. Further more, for various object's 
#' classes a much more different \code{Tags} can be searched. See examples below.
#' 
#' Supported \code{Tags} for various objects are (so far):
#'  to be done
#'  
#' 
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
#' # not work
#' searchInLocalRepo( "class:ggplot", dir = getwd() )
#' searchInLocalRepo( "name:prettyPlot", dir = "/home/folder/here" )
#' searchInGithubRepo( "name:myLMmodel", user="USERNAME", repo="REPO" )
#' searchInGithubRepo( "myLMmodel:call", user="USERNAME", repo="REPO" )
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