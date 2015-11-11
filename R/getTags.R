##    archivist package for R
##
#' @title Return Tags Corresponding to md5hash
#'
#' @description
#' \code{getTagsLocal} and \code{getTagsGithub} return \code{Tags} (see \link{Tags})
#' related to \link{md5hash} of an artifact. To learn more about artifacts visit
#' \link[archivist]{archivist-package}.
#' 
#' @details
#' \code{getTagsLocal} and \code{getTagsGithub} return \code{Tags}, of a specific type described
#' by \code{tag} parameter, related to \link{md5hash} of an artifact. To learn more about 
#' artifacts visit \link[archivist]{archivist-package}.
#'  
#' @return The character vector of \code{Tags} (see \link{Tags}) related to \link{md5hash} 
#' of an artifact.
#'
#' @param repoDir A character denoting an existing directory in 
#' which artifacts are stored. If set to \code{NULL} (by default),
#' uses the \code{repoDir} specified in \link{setLocalRepo}.
#' 
#' @param md5hash A character containing \code{md5hash} 
#' of artifacts which \code{Tags} are desired to be returned.
#' 
#' @param tag A regular expression denoting type of a \code{Tag} that we search for
#' (see \code{Examples}). Default \code{tag = "name"}.
#' 
#' @param repo While working with the Github repository. A character containing
#' a name of the Github repository on which the Repository is stored.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param user While working with the Github repository. A character containing
#' a name of the Github user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param branch While working with the Github repository. A character containing
#' a name of the Github repository's branch on which the Repository is stored.
#' Default \code{branch} is \code{master}.
#'
#' @param repoDirGit While working with the Github repository. A character containing
#' a name of a directory on the Github repository on which the Repository is stored.
#' If the Repository is stored in main folder on the Github repository, this should be set 
#' to \code{repoDirGit = FALSE} as default.
#' 
#' @note
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in Github mode then global parameters
#' set in \link{setGithubRepo} function are used.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#' 
#' ### Local version
#' 
#' ## EXAMPLE with pipe operator %a%
#' 
#' # Creating empty repository
#' exampleRepoDir <- tempfile()
#' createEmptyRepo( exampleRepoDir )
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
#' # We search for a tag with default "name" regular expression corresponding to 
#' # hash md5hash.
#' getTagsLocal( md5hash = hash, exampleRepoDir )
#' 
#' # Deleting example respository
#' deleteRepo( exampleRepoDir, TRUE) 
#' rm( exampleRepoDir ) 
#' 
#' ## EXAMPLE with data iris
#' exampleRepoDir <- tempfile()
#' createEmptyRepo( exampleRepoDir )
#' 
#' data(iris)
#' saveToRepo(iris, repoDir = exampleRepoDir )
#' showLocalRepo(exampleRepoDir)
#' showLocalRepo(exampleRepoDir, method = "tags")
#' 
#' # We can notice that there is only one md5hash in repo so we will use it
#' hash <- showLocalRepo(exampleRepoDir)[,1]
#' 
#' # We search for a tag with "varname" regular expression corresponding to 
#' # hash md5hash.
#' getTagsLocal( md5hash = hash, exampleRepoDir, tag = "varname" ) 
#' # There are 5 different tags with "varname" regular expression
#'
#' # We needn't use the whole expression "varname". We may use its abbreviation
#' # and get the same result.
#' getTagsLocal( md5hash = hash, exampleRepoDir, tag = "varna" ) 
#' 
#' deleteRepo( exampleRepoDir, TRUE) 
#' rm( exampleRepoDir ) 
#' 
#' ### Github version
#' ## EXAMPLE: pbiecek archivist repository on Github
#' 
#' showGithubRepo(user="pbiecek", repo="archivist")
#' # We search for a tag with default "name" regular expression corresponding to 
#' # "cd6557c6163a6f9800f308f343e75e72" md5hash.
#' getTagsGithub( "cd6557c6163a6f9800f308f343e75e72",
#'                 user="pbiecek", repo="archivist")
#'                 
#' ## EXAMPLE: many archivist-like Repositories on one Github repository
#' # We search for a tag with default "name" regular expression corresponding to 
#' # "ff575c261c949d073b2895b05d1097c3" md5hash.
#' getTagsGithub("ff575c261c949d073b2895b05d1097c3", user="MarcinKosinski",
#'                repo="Museum", branch="master", repoDirGit="ex1")
#'                
#' }
#' 
#' @family archivist
#' @rdname getTags
#' @export
getTagsLocal <- function( md5hash, repoDir = NULL, tag ="name"){
  stopifnot( is.character( c( md5hash, tag ) ) )
  stopifnot( is.character( repoDir ) | is.null( repoDir ) )
  repoDir <- checkDirectory( repoDir ) 
  

  # sub( pattern = paste0(tag, ":"), replacement = "", x = tagToReturn)
  # there are so many kind of tags (proposed by archivist or by an user)
  # that it will be very difficult to remove those "name:" at the beginning
  returnTag( md5hash, repoDir = repoDir , tag = tag )
}

#' @family archivist
#' @rdname getTags
#' @export
getTagsGithub <- function( md5hash, user = NULL, repo = NULL, branch = "master", repoDirGit = FALSE,
                           tag ="name"){
  stopifnot( is.character( c( md5hash, branch, tag ) ) )

  GithubCheck( repo, user, repoDirGit ) # implemented in setRepo.R
  
  # first download database
  Temp <- downloadDB( repo, user, branch, repoDirGit )
  returnTag( md5hash, repoDir = Temp, local = FALSE, tag = tag )
}

returnTag <- function( md5hash, repoDir, local = TRUE, tag ){
  Tags <- unique( executeSingleQuery( repoDir, realDBname = local,
                      paste0("SELECT DISTINCT tag FROM tag WHERE tag LIKE",
                             "'", tag, "%'", "AND artifact='", md5hash,"'") ) )
  return( as.character( Tags[, 1] ) )
}


