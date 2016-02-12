##    archivist package for R
##
#' @title Search for an Artifact in the Repository Using Tags
#'
#' @description
#' \code{searchInRepo} searches for an artifact in the \link{Repository} using it's \link{Tags}.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' 
#' @details
#' \code{searchInRepo} searches for an artifact in the Repository using it's \code{Tag} 
#' (e.g., \code{name}, \code{class} or \code{archiving date}). \code{Tags} are used in a \code{pattern}
#' parameter. For various artifact classes different \code{Tags} can be searched for. 
#' See \link{Tags}. If a \code{pattern} is a list of length 2 then \code{md5hashes} of all 
#' artifacts created from date \code{dateFrom} to date \code{dateTo} are returned. The date 
#' should be formatted according to the YYYY-MM-DD format, e.g., \code{"2014-07-31"}.
#' 
#' \code{Tags}, used in a \code{pattern} parameter, should be determined according to the 
#' format: \code{"TagKey:TagValue"} - see examples.
#'   
#' @return
#' \code{searchInRepo} returns character vector of \code{md5hashes} of artifacts that were searched for.
#' Those are hashes assigned to artifacts while they were saved in the Repository
#' by the \link{saveToLocalRepo} function. If the artifact
#' is not in the Repository then a logical value \code{FALSE} is returned.
#' 
#' @param repoType A character containing a type of the remote repository. Currently it can be 'github' or 'bitbucket'.
#' 
#' @param pattern If \code{fixed = TRUE}: a character denoting a \code{Tag} which is to be searched for in the Repository.
#' It is also possible to specify \code{pattern} as a list of 
#' length 2 with \code{dateFrom} and \code{dateTo}; see details. If \code{fixed = FALSE}: a regular expression 
#' specifying the beginning of a \code{Tag}, which will be used to search for artifacts. If of length more than one and if 
#' \code{intersect = TRUE} then artifacts that match all conditions are returned. If \code{intersect = FALSE} then artifacts that match any condition
#' are returned. See examples.
#' 
#' @param intersect A logical value. Used only when \code{length(pattern) > 1 & is.character(pattern)}.
#'  See \code{pattern} for more details.
#' 
#' @param repoDir A character denoting an existing directory in which artifacts will be searched for.
#' 
#' @param repo While working with the Remote repository. A character containing a name of the Remote repository on which the Repository is stored.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param user While working with the Remote repository. A character containing a name of the Remote user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}.
#'
#' @param branch While working with the Remote repository. A character containing a name of 
#' the Remote Repository's branch on which the Repository is stored. Default \code{branch} is \code{master}.
#' 
#' @param fixed A logical value specifying how \code{artifacts} should be searched for.
#' If \code{fixed = TRUE} (default) then artifacts are searched for by using \code{pattern = "Tag"} argument.
#' If \code{fixed = FALSE} then artifacts are searched for by using \code{pattern = "regular expression"} argument.
#' The latter is wider and more flexible method, e.g.,
#' using \code{pattern = "name", fixed = FALSE} arguments enables to search for all artifacts in the \code{Repository}.
#' 
#' @param subdir While working with the Remote repository. A character containing a name of a directory on the Remote repository 
#' on which the Repository is stored. If the Repository is stored in the main folder of the Remote repository, this should be set 
#' to \code{subdir = "/"} as default.
#' 
#' @param ... Used for old deprecated functions.
#' 
#' @note
#' If \code{repo}, \code{user}, \code{subdir} and \code{repoType} are not specified in the Remote mode then global parameters
#' set in \link{setRemoteRepo} function are used.
#' 
#' @author
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#' # objects preparation
#' 
#'   showLocalRepo(method = "md5hashes", 
#'      repoDir = system.file("graphGallery", package = "archivist"))
#'   showLocalRepo(method = "tags", 
#'      repoDir = system.file("graphGallery", package = "archivist"))
#'   
#'   # Tag search, fixed version
#'   searchInLocalRepo( "class:ggplot", repoDir = exampleRepoDir )
#'   searchInLocalRepo( "name:", repoDir = exampleRepoDir )
#'   # Tag search, regex version
#'   searchInLocalRepo( "class", repoDir = exampleRepoDir, fixed = FALSE )
#'   
#'   # Github version
#'   # check the state of the Repository
#'   summaryRemoteRepo( user="pbiecek", repo="archivist" )
#'   showRemoteRepo( user="pbiecek", repo="archivist" )
#'   showRemoteRepo( user="pbiecek", repo="archivist", method = "tags" )
#'   # Tag search, fixed version
#'   searchInRemoteRepo( "varname:Sepal.Width", user="pbiecek", repo="archivist" )
#'   searchInRemoteRepo( "class:lm", user="pbiecek", repo="archivist", branch="master" )
#'   searchInRemoteRepo( "name:myplot123", user="pbiecek", repo="archivist" )
#'   
#'   # Tag search, regex version
#'   searchInRemoteRepo( "class", user="pbiecek", repo="archivist",  fixed = FALSE )
#'   searchInRemoteRepo( "name", user="pbiecek", repo="archivist", fixed = FALSE )
#'   
#'   # also on Github
#'   
#'   # Remeber to set dateTo parameter to actual date because sometimes we update datasets.
#'   searchInRemoteRepo( pattern = list( dateFrom = "2015-10-01", dateTo = "2015-11-30" ), 
#'                       user="pbiecek", repo="archivist", branch="master" )
#'   
#'   
#'   # many archivist-like Repositories on one Remote repository
#'   
#'   searchInRemoteRepo( pattern = "name", user="MarcinKosinski", repo="Museum", 
#'   branch="master", subdir="ex1", fixed = FALSE )
#'
#'   searchInRemoteRepo( pattern = "name", user="MarcinKosinski", repo="Museum", 
#'                    branch="master", subdir="ex2", fixed = FALSE )
#'  
#'  # multi versions
#'  searchInRemoteRepo( pattern=c("varname:Sepal.Width", "class:lm", "name:myplot123"), 
#'                          user="pbiecek", repo="archivist", intersect = FALSE )
#'   
#' }
#' @family archivist
#' @rdname searchInRepo
#' @export
searchInLocalRepo <- function( pattern, repoDir = aoptions("repoDir"), fixed = TRUE, intersect = TRUE ){
  stopifnot( ( is.character( repoDir ) & length( repoDir ) == 1 ) | is.null( repoDir ) )
  stopifnot( is.logical( c( fixed, intersect ) ), length( fixed ) == 1, length( intersect ) == 1 )
  stopifnot( is.character( pattern ) | (is.list( pattern ) & length( pattern ) == 2) ) 
  
  
  if ( is.character( pattern ) & length( pattern ) > 1 ) {
    return(multiSearchInLocalRepoInternal(patterns = pattern, repoDir = repoDir, fixed = fixed, intersect = intersect))
  }
  
  repoDir <- checkDirectory( repoDir )
  
  # extracts md5hash
  if ( fixed ){
    if ( length( pattern ) == 1 ){
      md5hashES <- unique( executeSingleQuery( dir = repoDir, 
                                               paste0( "SELECT DISTINCT artifact FROM tag WHERE tag = ",
                                                       "'", pattern, "'" ) ) )
    }else{
      ## length pattern == 2
      md5hashES <- unique( executeSingleQuery( dir = repoDir, 
                                               paste0( "SELECT DISTINCT artifact FROM tag WHERE createdDate >",
                                                       "'", as.Date(pattern[[1]])-1, "'", " AND createdDate <",
                                                       "'", as.Date(pattern[[2]])+1, "'") ) ) }
  }else{
    # fixed = FALSE
    md5hashES <- unique( executeSingleQuery( dir = repoDir, 
                                             paste0( "SELECT DISTINCT artifact FROM tag WHERE tag LIKE ",
                                                     "'", pattern, "%'" ) ) )
  }
  return( as.character( md5hashES[, 1] ) ) 
}

#' @rdname searchInRepo
#' @export
searchInRemoteRepo <- function( pattern, repo = aoptions("repo"), user = aoptions("user"), branch = "master", subdir = aoptions("subdir"),
                                repoType = aoptions("repoType"), fixed = TRUE, intersect = TRUE ){
  stopifnot( (is.list( pattern ) & length( pattern ) == 2 ) | is.character( pattern ) )
  stopifnot( is.logical( c( fixed, intersect ) ), length( fixed ) == 1, length( intersect ) == 1 )
  
  if ( is.character( pattern ) & length( pattern ) > 1 ) {
    return(multiSearchInRemoteRepoInternal(patterns = pattern, repo = repo, user = user, branch = branch,
                                   subdir = subdir, repoType = repoType, fixed = fixed, intersect = intersect))
  }
  
  RemoteRepoCheck( repo, user, branch, subdir, repoType) # implemented in setRepo.R
  
  # first download database
  remoteHook <- getRemoteHook(repo=repo, user=user, branch=branch, subdir=subdir)
  Temp <- downloadDB( remoteHook )
  
  # extracts md5hash
  if ( fixed ){
    if ( length( pattern ) == 1 ){
      md5hashES <- unique( executeSingleQuery( dir = Temp, 
                                               paste0( "SELECT artifact FROM tag WHERE tag = ",
                                                       "'", pattern, "'" ) ) )
    }else{
      # length pattern == 2
      md5hashES <- unique( executeSingleQuery( dir = Temp, 
                                               paste0( "SELECT artifact FROM tag WHERE createdDate >",
                                                       "'", as.Date(pattern[[1]])-1, "'", " AND createdDate <",
                                                       "'", as.Date(pattern[[2]])+1, "'") ) ) }
  }else{
    # fixed FALSE
    md5hashES <- unique( executeSingleQuery( dir = Temp, 
                                             paste0( "SELECT DISTINCT artifact FROM tag WHERE tag LIKE ",
                                                     "'", pattern, "%'" ) ) )
  }
  unlink( Temp, recursive = TRUE, force = TRUE)
  return( as.character( md5hashES[, 1] ) ) 
}


multiSearchInLocalRepoInternal <- function( patterns, repoDir = aoptions("repoDir"), fixed = TRUE, intersect = TRUE ){
  
  md5hs <- lapply(patterns, function(pattern) unique(searchInLocalRepo(pattern, repoDir=repoDir, fixed=fixed) ))
  if (intersect) {
    return(names(which(table(unlist(md5hs)) == length(md5hs))))
  } 
  # union
  unique(unlist(md5hs))
}

multiSearchInRemoteRepoInternal <- function( patterns, repo = aoptions("repo"), user = aoptions("user"), branch = "master", subdir = aoptions("subdir"),
                                     repoType = aoptions("repoType"), 
                                     fixed = TRUE, intersect = TRUE ){
  
  RemoteRepoCheck( repo, user, branch, subdir, repoType) # implemented in setRepo.R
  
  remoteHook <- getRemoteHook(repo=repo, user=user, branch=branch, subdir=subdir)
  Temp <- downloadDB( remoteHook )
  on.exit( unlink( Temp, recursive = TRUE, force = TRUE))
  m <- multiSearchInLocalRepoInternal( patterns, repoDir = Temp, fixed=fixed,
                               intersect=intersect)
  return( m )
}

#' @family archivist
#' @rdname searchInRepo
#' @export
multiSearchInLocalRepo <- function(...) {
  .Deprecated("multiSearchInLocalRepo is deprecated. Use searchInLocalRepo() instead.")
  multiSearchInLocalRepoInternal(...)
}

#' @family archivist
#' @rdname searchInRepo
#' @export
multiSearchInRemoteRepo <- function(...) {
  .Deprecated("multiSearchInRemoteRepo is deprecated. Use searchInRemoteRepo() instead.")
  multiSearchInRemoteRepoInternal(...)
}
