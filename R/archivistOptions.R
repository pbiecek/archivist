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
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#'
#' @examples
#' \dontrun{
#' # data.frame object
#' # data(iris)
#'
#' # Creating example repository - on which examples will work
#' exampleRepoDir <- tempfile()
#' createEmptyRepo(repoDir = exampleRepoDir)
#' 
#' ## EXAMPLE 1 : TURN OFF warnings in saveToRepo() using aoptions() function
#' aoptions(key = "silent", value = TRUE)
#' iris1 <- saveToRepo(iris, exampleRepoDir)
#' iris2 <- saveToRepo(iris, exampleRepoDir)
#' # Note that there is no warning. Normally a user receives ani information
#' # about another archivisation of the same artifact.
#' 
#' # deleting example repoDir
#' deleteRepo(exampleRepoDir, deleteRoot = TRUE)
#' rm(exampleRepoDir)
#' 
#' ## EXAMPLE 2 : SET default local repository using aoptions() function.
#' 
#' # creating example repository
#' exampleRepoDir <- tempfile()
#' createEmptyRepo(exampleRepoDir)
#' 
#' # "repodDir" parameter in each archivist function will be default and set to exampleRepoDir.
#' aoptions(key = "repoDir", value = exampleRepoDir)
#' 
#' data(iris)
#' data(swiss)
#' # From this moment repoDir parameter may be ommitted in the following functions
#' saveToRepo(iris)
#' saveToRepo(swiss) 
#' showLocalRepo()
#' showLocalRepo(method = "tags")
#' zipLocalRepo()
#' file.remove(file.path(getwd(), "repository.zip"))
#' iris2 <- loadFromLocalRepo( "ff575c2" , value = TRUE)
#' searchInLocalRepo("name:i", fixed = F)
#' getTagsLocal("ff575c261c949d073b2895b05d1097c3")
#' rmFromRepo("4c43f")
#' showLocalRepo()
#' summaryLocalRepo()
#' 
#' # REMEMBER that in deleteRepo you MUST specify repoDir parameter!
#' # deleteRepo doesn't take setLocalRepo's settings into consideration
#' deleteRepo( exampleRepoDir, deleteRoot = TRUE)
#' rm( exampleRepoDir )
#' }
#' 
#' @family archivist
#' @rdname archivistOptions
#' @export
aoptions <- function(key, value=NULL) {
  stopifnot( is.character( key ) )
  if (!is.null(value)) {
    .ArchivistEnv[[key]] <- value
  }
  .ArchivistEnv[[key]]
}