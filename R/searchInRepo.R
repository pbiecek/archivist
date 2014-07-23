##    archivist package for R
##
#' @title Search for an Object in a Repository using Tags
#'
#' @description
#' \code{searchInRepo} searches for an object in a repository using it's \code{Tag}.
#' 
#' 
#' @details
#' \code{searchInRepo} searches for an object in a repository using it's \code{Tag}.
#' \code{Tags} can be an object's \code{name}, \code{class} or \code{archivisation date}. 
#' Furthermore, for various object's classes more different \code{Tags} can be searched. 
#' See \link{Tags}. If a \code{Tag} is a list of lenght 2, \code{md5hashes} of all 
#' objects created from date \code{dataFrom} to data \code{dataTo} are returned.
#'   
#' @return
#' \code{searchInRepo} returns as value a \code{md5hash} which is an object's hash that was generated while
#' saving an object to the Repository in a moment a \link{saveToRepo} function was called. If the desired object
#' is not in a Repository a logical value \code{FALSE} is returned.
#' 
#' @param tag A character denoting a Tag to seek for or a list of length 2 with \code{dataFrom} and \code{dataTo} arguments See details.
#' 
#' @param dir A character denoting an existing directory from which objects will be searched.
#' 
#' @param repo Only if working on Github Repository. A character string containing a name of Github Repository.
#' 
#' @param user Only if working on Github Repository. A character string containing a name of Github User.
#'
#' @author
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
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