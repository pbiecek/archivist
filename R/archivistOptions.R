##    archivist package for R
##
#' @title Default Options for Archivist
#'
#' @description
#' The function \code{aoptions} sets and gets default options
#' for other \code{archivist} functions.
#' 
#' @details
#' The function \code{aoptions} with two parameters sets default \code{value} 
#' of \code{key} parameter for other \code{archivist} functions. The function
#' \code{aoptions} with one parameter returns value (stored in an internal environment))
#' of the given \code{key} parameter.
#' 
#' @return
#' The function returns value that corresponds to a selected key.
#' 
#' @param key A character denoting name of the parameter.
#' 
#' @param value New value for the 'key' parameter.
#' 
#' @param unset Set to \code{TRUE} if want to set parameter to \code{NULL}, 
#' i.e. when unsetting Repository \code{aoptions('repoDir', NULL, T)}.
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#'
#' @examples
#' \dontrun{
#' # data.frame object
#' # data(iris)
#'
#' 
#' ## EXAMPLE 1 : SET default local repository using aoptions() function.
#' 
#' # creating example repository
#' exampleRepoDir <- tempfile()
#' createLocalRepo(exampleRepoDir)
#' 
#' # "repodDir" parameter in each archivist function will be default and set to exampleRepoDir.
#' aoptions(key = "repoDir", value = exampleRepoDir)
#' 
#' data(iris)
#' data(swiss)
#' # From this moment repoDir parameter may be ommitted in the following functions
#' saveToLocalRepo(iris)
#' saveToLocalRepo(swiss) 
#' showLocalRepo()
#' showLocalRepo(method = "tags")
#' zipLocalRepo()
#' file.remove(file.path(getwd(), "repository.zip"))
#' iris2 <- loadFromLocalRepo( "ff575c2" , value = TRUE)
#' searchInLocalRepo("name:i", fixed = F)
#' getTagsLocal("ff575c261c949d073b2895b05d1097c3")
#' rmFromLocalRepo("4c43f")
#' showLocalRepo()
#' summaryLocalRepo()
#' 
#' # REMEMBER that in deleteRepo you MUST specify repoDir parameter!
#' # deleteLocalRepo doesn't take setLocalRepo's settings into consideration
#' deleteLocalRepo( exampleRepoDir, deleteRoot = TRUE)
#' rm( exampleRepoDir )
#' 
#' ## EXAMPLE 2 : SET default Github repository using aoptions() function.
#' aoptions(key = "user", value = "pbiecek")
#' aoptions(key = "repo", value = "archivist")
#' 
#' # From this moment user and repo parameters may be ommitted in the following functions:
#' showRemoteRepo() 
#' loadFromRemoteRepo( "ff575c261c949d073b2895b05d1097c3")
#' this <- loadFromRemoteRepo( "ff", value = T)
#' file.remove(file.path(getwd(), "repository.zip")) # We can remove this zip file
#' searchInRemoteRepo( "name:", fixed= FALSE)
#' getTagsGithub("ff575c261c949d073b2895b05d1097c3")
#' summaryRemoteRepo( )
#' searchInRemoteRepo( pattern=c("varname:Sepal.Width", "class:lm", "name:myplot123"), 
#'                          intersect = FALSE ) 
#' ## EXAMPLE 3 : SET default Github repository using aoptions() function.
#' showRemoteRepo('Museum', 'MarcinKosinski', subdir = 'ex1')
#' aoptions('repo', 'Museum')
#' aoptions('user', 'MarcinKosinski')
#' aoptions('subdir', 'ex1')
#' aoptions('branch', 'master')
#' showRemoteRepo()
#' showRemoteRepo(subdir = 'ex2')
#' 
#' aoptions('subdir')
#' }
#' 
#' @family archivist
#' @rdname archivistOptions
#' @export
aoptions <- function(key, value=NULL, unset = FALSE) {
  
  stopifnot( is.character( key ) )
  stopifnot( is.logical( unset ) )
  if (unset | !is.null(value)) {
    .ArchivistEnv[[key]] <- value
  }
  .ArchivistEnv[[key]]
}
