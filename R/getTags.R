##    archivist package for R
##
#' @title Return Tags Corresponding to md5hash
#'
#' @description
#' \code{getTagsLocal} and \code{getTagsRemote} return \code{Tags} (see \link{Tags})
#' related to \link{md5hash} of an artifact. To learn more about artifacts visit
#' \link[archivist]{archivist-package}.
#' 
#' @details
#' \code{getTagsLocal} and \code{getTagsRemote} return \code{Tags}, of a specific type described
#' by \code{tag} parameter, related to \link{md5hash} of an artifact. To learn more about 
#' artifacts visit \link[archivist]{archivist-package}.
#'  
#' @return The character vector of \code{Tags} (see \link{Tags}) related to \link{md5hash} 
#' of an artifact.
#'
#' @param repoType A character containing a type of the remote repository. Currently it can be 'github' or 'bitbucket'.
#' @param repoDir A character denoting an existing directory in 
#' which artifacts are stored. 
#' 
#' @param md5hash A character containing \code{md5hash} 
#' of artifacts which \code{Tags} are desired to be returned.
#' 
#' @param tag A regular expression denoting type of a \code{Tag} that we search for
#' (see \code{Examples}). Default \code{tag = "name"}.
#' 
#' @param repo While working with the Remote repository. A character containing
#' a name of the Remote repository on which the Repository is stored.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param user While working with the Remote repository. A character containing
#' a name of the Remote user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param branch While working with the Remote repository. A character containing
#' a name of the Remote repository's branch on which the Repository is stored.
#' Default \code{branch} is \code{master}.
#'
#' @param subdir While working with the Remote repository. A character containing
#' a name of a directory on the Remote repository on which the Repository is stored.
#' If the Repository is stored in main folder on the Remote repository, this should be set 
#' to \code{subdir = "/"} as default.
#' 
#' @note
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in Remote mode then global parameters
#' set in \link{setRemoteRepo} function are used.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' 
#' ### Local version
#' 
#' ## EXAMPLE with pipe operator %a%
#' 
#' # Creating empty repository
#' exampleRepoDir <- tempfile()
#' createLocalRepo( exampleRepoDir )
#' 
#' library(dplyr)
#' data(mtcars)
#' setLocalRepo(repoDir = exampleRepoDir)
#' hash <- mtcars %a% 
#'  group_by(cyl, am) %a%
#'    select(mpg, cyl, wt, am) %a%
#'      summarise(avgmpg = mean(mpg), avgwt = mean(wt)) %a%
#'        filter(avgmpg > 20) %a%
#'        saveToRepo( exampleRepoDir )
#'        
#' showLocalRepo(exampleRepoDir)
#' showLocalRepo(exampleRepoDir, method = "tags")
#' 
#' # We search for a Tag with default "name" regular expression corresponding to 
#' # hash md5hash.
#' getTagsLocal( md5hash = hash, exampleRepoDir )
#' 
#' # Deleting example respository
#' deleteLocalRepo( exampleRepoDir, TRUE) 
#' rm( exampleRepoDir ) 
#' 
#' ## EXAMPLE with data iris
#' exampleRepoDir <- tempfile()
#' createLocalRepo( exampleRepoDir )
#' 
#' data(iris)
#' saveToRepo(iris, repoDir = exampleRepoDir )
#' showLocalRepo(exampleRepoDir)
#' showLocalRepo(exampleRepoDir, method = "tags")
#' 
#' # We can notice that there is only one md5hash 
#' # (and second for archiveSessionInfo) in repo so we will use it
#' hash <- showLocalRepo(exampleRepoDir)[1,1]
#' 
#' # We search for a Tag with "varname" regular expression corresponding to 
#' # hash md5hash.
#' getTagsLocal( md5hash = hash, exampleRepoDir, tag = "varname" ) 
#' # There are 5 different Tags with "varname" regular expression
#'
#' # We needn't use the whole expression "varname". We may use its abbreviation
#' # and get the same result.
#' getTagsLocal( md5hash = hash, exampleRepoDir, tag = "varna" ) 
#' 
#' deleteLocalRepo( exampleRepoDir, TRUE) 
#' rm( exampleRepoDir ) 
#' 
#' ### Remote version
#' ## EXAMPLE: pbiecek archivist repository on GitHub
#' 
#' showRemoteRepo(user="pbiecek", repo="archivist")
#' # We search for a Tag with default "name" regular expression corresponding to 
#' # "cd6557c6163a6f9800f308f343e75e72" md5hash.
#' getTagsRemote( "cd6557c6163a6f9800f308f343e75e72",
#'                 user="pbiecek", repo="archivist")
#'                 
#' ## EXAMPLE: many archivist-like Repositories on one Github repository
#' # We search for a Tag with default "name" regular expression corresponding to 
#' # "ff575c261c949d073b2895b05d1097c3" md5hash.
#' getTagsRemote("ff575c261c949d073b2895b05d1097c3", user="MarcinKosinski",
#'                repo="Museum", branch="master", subdir="ex1")
#'                
#' 
#' @family archivist
#' @rdname getTags
#' @export
getTagsLocal <- function( md5hash, repoDir = aoptions('repoDir'), tag ="name"){
  stopifnot( is.character( c( md5hash, tag ) ), length( md5hash ) ==  1, length( tag ) == 1)
  stopifnot( is.character( repoDir ) & length( repoDir ) == 1)
  repoDir <- checkDirectory( repoDir ) 
  

  # sub( pattern = paste0(tag, ":"), replacement = "", x = tagToReturn)
  # there are so many kind of Tags (proposed by archivist or by an user)
  # that it will be very difficult to remove those "name:" at the beginning
  returnTag( md5hash, repoDir = repoDir , tag = tag )
}

#' @family archivist
#' @rdname getTags
#' @export
getTagsRemote <- function( md5hash, repo = aoptions("repo"), user = aoptions("user"), branch = aoptions("branch"), subdir = aoptions("subdir"),
                           repoType = aoptions("repoType"),
                           tag ="name"){
  stopifnot( is.character( c( md5hash, branch, tag ) ), 
             length( md5hash ) ==  1, length( branch ) == 1, length( tag ) == 1 )

  RemoteRepoCheck( repo, user, branch, subdir, repoType)
  
  # first download database
  remoteHook <- getRemoteHook(repo=repo, user=user, branch=branch, subdir=subdir, repoType=repoType)
  Temp <- downloadDB( remoteHook )
  returnTag( md5hash, repoDir = Temp, tag = tag )
}

returnTag <- function( md5hash, repoDir, tag ){
  Tags <- unique( executeSingleQuery( repoDir, 
                      paste0("SELECT DISTINCT tag FROM tag WHERE tag LIKE",
                             "'", tag, "%'", "AND artifact='", md5hash,"'") ) )
  return( as.character( Tags[, 1] ) )
}


