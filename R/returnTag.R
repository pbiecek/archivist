##    archivist package for R
##
#' @title Return a \code{Tag} Corresponding to \code{md5hash}
#'
#' @description
#' \code{returnTagLocal} and \code{returnTagGithub} return a \code{Tag} (see \link{Tags}) related to \link{md5hash} 
#' of an artifact. To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' \code{returnTagLocal} and \code{returnTagGithub} return (see \link{Tags}) related to \link{md5hash} 
#' of an artifact. To learn more about artifacts visit \link[archivist]{archivist-package}.
#'  
#' @return The returned value is a \code{Tag} (see \link{Tags}) related to \link{md5hash} 
#' of an artifact, which is a character.
#'
#' @param repoDir A character denoting an existing directory in 
#' which an artifact is stored.
#' 
#' @param md5hash A character containing \code{md5hash} 
#' of artifacts which \code{Tag} is desired to be returned.
#' 
#' @param tag A type of a \link{Tags}. Default \code{tag = "name"}.
#' 
#' @param repo Only if working with a Github repository. A character containing a name of a Github repository on which the Repository is archived.
#' 
#' @param user Only if working with a Github repository. A character containing a name of a Github user on whose account the \code{repo} is created.
#' 
#' @param branch Only if working with a Github repository. A character containing a name of 
#' Github repository's branch in which Repository is archived. Default \code{branch} is \code{master}.
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
#' returnTagLocal( md5hash = hash, exampleRepoDir )
#' 
#' deleteRepo( exampleRepoDir ) 
#' rm( exampleRepoDir ) 
#' 
#' returnTagGithub( "3db63bc63b8defaf42c0bde19160f242", 
#'    user="pbiecek", repo="archivist")
#' 
#' }
#' 
#' 
#' 
#' 
#' @family archivist
#' @rdname returnTag
#' @export
returnTagLocal <- function( md5hash, repoDir, tag ="name"){
  stopifnot( is.character( c( md5hash, repoDir, tag ) ) )
  repoDir <- checkDirectory( repoDir )  

  # sub( pattern = paste0(tag, ":"), replacement = "", x = tagToReturn)
  # there are so many kind of tags (proposed by archivist or by an user)
  # that it will be very difficult to remove those "name:" at the beginning
  returnTag( md5hash, repoDir = repoDir , tag = tag )
}

#' @family archivist
#' @rdname returnTag
#' @export
returnTagGithub <- function( md5hash, user, repo, branch = "master", tag ="name"){
  stopifnot( is.character( c( md5hash, user, repo, branch, tag ) ) )
  
  # first download database
  Temp <- downloadDB( repo, user, branch )
  returnTag( md5hash, repoDir = Temp, local = FALSE, tag = tag )
}

returnTag <- function( md5hash, repoDir, local = TRUE, tag ){
  Tags <- unique( executeSingleQuery( repoDir, realDBname = local,
                      paste0("SELECT DISTINCT tag FROM tag WHERE tag LIKE",
                             "'", tag, "%'", "AND artifact='", md5hash,"'") ) )
  return( ar.character( Tags[, 1] ) )
}


