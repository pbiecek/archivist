##    archivist package for R
##
#' @title Return a Tag Corresponding to md5hash
#'
#' @description
#' \code{getTagsLocal} and \code{getTagsGithub} return a \code{Tag} (see \link{Tags}) related to \link{md5hash} 
#' of an artifact. To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' \code{getTagsLocal} and \code{getTagsGithub} return (see \link{Tags}) related to \link{md5hash} 
#' of an artifact. To learn more about artifacts visit \link[archivist]{archivist-package}.
#'  
#' @return The character is returned, which is a \code{Tag} (see \link{Tags}) related to \link{md5hash} 
#' of an artifact.
#'
#' @param repoDir A character denoting an existing directory in 
#' which an artifact is stored. If set to \code{NULL} (by default), uses the \code{repoDir} specified in \link{setLocalRepo}.
#' 
#' @param md5hash A character containing \code{md5hash} 
#' of artifacts which \code{Tag} is desired to be returned.
#' 
#' @param tag A type of a \link{Tags}. Default \code{tag = "name"}.
#' 
#' @param repo Only if working with a Github repository. A character containing a name of a Github repository on which the Repository is archived.
#' By default set to \code{NULL} - see \code{Note}.
#' @param user Only if working with a Github repository. A character containing a name of a Github user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}.
#' @param branch Only if working with a Github repository. A character containing a name of 
#' Github repository's branch in which Repository is archived. Default \code{branch} is \code{master}.
#'
#' @param repoDirGit Only if working with a Github repository. A character containing a name of a directory on Github repository 
#' on which the Repository is stored. If the Repository is stored in main folder on Github repository, this should be set 
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
#' library(dplyr)
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( exampleRepoDir )
#' 
#' data(mtcars)
#' hash <- mtcars %.% 
#'  group_by(cyl, am) %.%
#'  select(mpg, cyl, wt, am) %.%
#'  summarise(avgmpg = mean(mpg), avgwt = mean(wt)) %.%
#'  filter(avgmpg > 20) %>%
#'  saveToRepo( exampleRepoDir )
#'  
#' getTagsLocal( md5hash = hash, exampleRepoDir )
#' 
#' deleteRepo( exampleRepoDir ) 
#' rm( exampleRepoDir ) 
#' 
#' getTagsGithub( "3db63bc63b8defaf42c0bde19160f242", 
#'    user="pbiecek", repo="archivist")
#' 
#' # many archivist-like Repositories on one Github repository
#' 
#' getTagsGithub("ff575c261c949d073b2895b05d1097c3", user="MarcinKosinski", 
#' repo="Museum", branch="master", repoDirGit="ex1")
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


