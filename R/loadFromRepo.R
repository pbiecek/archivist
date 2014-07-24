##    archivist package for R
##
#' @title Load Object Given as md5hash from Repository
#'
#' @description
#' \code{loadFromLocalRepo} loads an object from a local repository into the workspace.
#' \code{loadFromGithubRepo} loads an object from a github repository into the workspace.
#' 
#' 
#' @details
#' Functions \code{loadFromLocalRepo} and \code{loadFromGithubRepo} load objects from archivist repositories stored in local folder or on Github. Both of them take \code{md5hash} as a
#' parameter. This \code{md5hash} is a string of length 32 that comes out as a result from \link{saveToRepo} function, which uses a cryptographical hash function with MD5 algorithm.
#' 
#' Important: instead of giving whole \code{md5hash} name, user can simply give first few signs of desired \code{md5hash} - an abbreviation.
#' For example \code{a09dd} instead of \code{a09ddjdkf9kj33dcjdnfjgos9jd9jkcv}. But if several tags start with the same pattern 
#' an error will be displayed and you will be asked to give more precise \code{md5hash} abbreviation (try abbreviation with more digits all with whole name).
#' 
#' Note that \code{user} and \code{repo} should be used only when working on Github Repository and ought to be omitted in a local working mode, 
#' when \code{dir} should only be used when working on a local Repository and ought to be omitted in a Github working mode.
#' 
#' You can load one object at one call.
#' 
#' @param dir A character denoting an existing directory from which an object will be loaded.
#' 
#' @param md5hash A hash of an object. A character string being a result of a cryptographical hash function with MD5 algorithm.
#' 
#' @param repo Only if working on Github Repository. A character containing a name of Github Repository.
#' 
#' @param user Only if working on Github Repository. A character containing a name of Github User.
#'
#' @author 
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#' 
#' @examples
#' # not work
#' library(digest)
#' loadFromLocalRepo( md5hash = digest(plot123) , dir = getwd() ) # TODO: is it useful?
#' loadFromLocalRepo( md5hash = "hs82h9kahs72h3nckv0dhsu28sgd73js", 
#'                        dir = "user/folder/here" )
#' loadFromGithubRepo( md5hash = "hs82h9kahs72h3nckv0dhsu28sgd73js", 
#'                            repo = "REPONAME", user = "USERNAME" ) # TODO: here put some real example
#'                            
#' # with md5hash abbreviation
#' loadFromLocalRepo( md5hash = "hs82h9k", 
#'                        dir = "user/folder/here" ) # TODO: here put some real examples
#' 
#' @family archivist
#' @rdname loadFromLocalRepo
#' @export
loadFromLocalRepo <- function( md5hash, dir ){
  stopifnot( is.character( c( md5hash, dir ) ) )
  
}


#' @rdname loadFromLocalRepo
#' @export
loadFromGithubRepo <- function( md5hash, repo, user ){
  stopifnot( is.character( c( md5hash, repo, user ) ) )
  
}