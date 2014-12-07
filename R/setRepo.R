##    archivist package for R
##
#' @title Set Global Path to Repository
#'
#' @description
#' \code{setLocalRepo} \code{setGlobalRepo} 
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' Functions 
#' 
#' @seealso
#' 
#' \href{https://github.com/pbiecek/archivist/wiki}{https://github.com/pbiecek/archivist/wiki}
#' 
#' @param repoDir 
#' 
#' @param repo Only if working with a Github repository. A character containing a name of a Github repository on which the Repository is archived.
#' 
#' @param user Only if working with a Github repository. A character containing a name of a Github user on whose account the \code{repo} is created.
#' 
#' @param branch Only if working with a Github repository. A character containing a name of 
#' Github Repository's branch on which the Repository is archived. Default \code{branch} is \code{master}.
#' 
#' @param repoDirGit Only if working with a Github repository. A character containing a name of a directory on Github repository 
#' on which the Repository is stored. If the Repository is stored in main folder on Github repository, this should be set 
#' to \code{repoDirGit = FALSE} as default.
#' 
#' 
#'
#' @author 
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#' 
#' @examples
#' 
#' \dontrun{
#' # examples
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' saveToRepo( iris, exampleRepoDir)
#' setLocalRepo( exampleRepoDir )
#' saveToRepo( swiss )
#' showLocalRepo( exampleRepoDir )
#' 
#' iris2 <- loadFromLocalRepo( "ff575c2" , value = TRUE)
#' head(iris2, 2)
#' 
#' searchInLocalRepo( "name:i", fixed = F)
#' 
#' getTagsLocal( "ff575c261c949d073b2895b05d1097c3" )
#'
#' rmFromRepo( "4c43f" )
#' showLocalRepo( )
#' summaryLocalRepo( )
#' 
#' deleteRepo( exampleRepoDir )
#' rm( exampleRepoDir )
#'
#' }
#' @family archivist
#' @rdname setRepo
#' @export
setLocalRepo <- function( repoDir ){
  stopifnot( is.character(repoDir) )
  
  repoDir <- checkDirectory( repoDir )
  
  assign( ".repoDir", repoDir, envir = .ArchivistEnv )
  
}


#' @family archivist
#' @rdname setRepo
#' @export
setGlobalRepo <- function( user, repo, branch = "master", 
                           repoDirGit = NULL){
  stopifnot( is.character( c( repo, user, branch ) ) )
  stopifnot( is.logical( repoDirGit ) | is.character( repoDirGit ) )
  
  assign( ".user", user, envir = .ArchivistEnv )
  assign( ".repo", repo, envir = .ArchivistEnv )
  assign( ".branch", branch, envir = .ArchivistEnv )
  assign( ".repoDirGit", repoDirGit , envir = .ArchivistEnv )

  
}