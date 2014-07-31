##    archivist package for R
##
#' @title Load Object Given as md5hash from Repository
#'
#' @description
#' \code{loadFromLocalRepo} loads an object from a local \link{Repository} into the workspace.
#' \code{loadFromGithubRepo} loads an object from a Github \link{Repository} into the workspace.
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
#' One may notice that loadFromGithubRepo and loadFromLocalRepo load objects to the Global
#' Environment with it's original name. If one is not satisfied with that solution,
#' a parameter returns = TRUE might be specified so that functions return object as a result that
#' can be attributed to a new name.
#' 
#' @note
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
#' @param returns A logical value denoting whether to load an object into the Global Environment 
#' (that is set by default \code{FALSE}) or whether to return an object as a function's result (\code{TRUE}).
#'
#' @author 
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#' 
#' @examples
#' # not work
#' library(digest)
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
loadFromLocalRepo <- function( md5hash, dir, returns = TRUE ){
  stopifnot( is.character( c( md5hash, dir ) ) )
  stopifnot( is.logical( returns ))
  
  # check if dir has "/" at the end and add it if not
  if ( regexpr( pattern = ".$", text = dir ) != "/" ){
    dir <- paste0(  dir, "/"  )
  }
  if ( returns ){
    load( file = paste0( dir, "gallery/", md5hash, ".rda" ), envir = .GlobalEnv )
  }else{
    load( file = paste0( dir, "gallery/", md5hash, ".rda" ), envir = .GlobalEnv )
    name <- load( file = paste0( dir, "gallery/", md5hash, ".rda" ), envir = .GlobalEnv )
    return( get( name, envir = .GlobalEnv) )
  }
}



#' @rdname loadFromLocalRepo
#' @export
loadFromGithubRepo <- function( md5hash, repo, user, returns = TRUE ){
  stopifnot( is.character( c( md5hash, repo, user ) ) )
  stopifnot( is.logical( returns ))
  
  # maybe some "raw" here ?
  # urlLoad <- paste0("https://github.com", user, repo)
  # load( file = paste0( urlLoad, md5hash, ".rd" ) )
  # if ( returns ){
  #  load( file = paste0( dir, md5hash, ".rd" ) )
  #}else{
  #  ##TO BE DONE 
  #}
  
}