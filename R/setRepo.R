##    archivist package for R
##
#' @title Set Global Path to Repository
#'
#' @description
#' \code{setLocalRepo} sets global path to the \link{Repository}. If you are working on 
#' a Local Repository and are tired of specifying \code{repoDir} argument with every call
#' of a function that works with the Repository, you can set the path globally using 
#' \code{setLocalRepo} function and than ommit \code{repoDir} parameter in future calls.
#' \code{setGithubRepo} similarly sets path to the Github Repository stored on a Github. See examples. 
#' 
#' @details
#' \code{setLocalRepo} sets a global path to the \link{Repository}. If you are working on 
#' a Local Repository and are tired of specifying a \code{repoDir} paremeter with every call
#' of a function that works with the Repository, you can set the path globally using 
#' \code{setLocalRepo} function and than ommit the \code{repoDir} parameter in future calls.
#' \code{setGithubRepo} similarly sets path to the Github Repository stored on a Github. See examples.
#' 
#' @seealso
#' 
#' \href{https://github.com/pbiecek/archivist/wiki}{https://github.com/pbiecek/archivist/wiki}
#' 
#' @param repoDir A character denoting an existing directory of a Rpoesiotry that will be used in
#' functions: \link{saveToRepo}, \link{loadFromLocalRepo}, \link{searchInLocalRepo},
#' \link{rmFromRepo}, \link{zipLocalRepo}, \link{multiSearchInLocalRepo}, \link{addTagsRepo}, 
#' \link{shinySearchInLocalRepo}, \link{getTagsLocal}, \link{showLocalRepo}, 
#' \link{summaryLocalRepo} if in their
#' calls there will not be specified a \code{repoDir} parameter. 
#' 
#' @param repo Only if working with a Github repository. A character containing a name of a Github repository that will be used in
#' functions: \link{zipGithubRepo}, \link{loadFromGithubRepo}, \link{searchInGithubRepo}, \link{getTagsGithub}, \link{showGithubRepo}, \link{summaryGithubRepo}, \link{multiSearchInGithubRepo}, \link{copyGithubRepo} if in their
#' calls there will not be specified a \code{repo} parameter. 
#' @param user Only if working with a Github repository. A character containing a name of a Github user that will be used in
#' functions: \link{zipGithubRepo}, \link{loadFromGithubRepo}, \link{searchInGithubRepo}, \link{getTagsGithub}, \link{showGithubRepo}, \link{summaryGithubRepo},\link{multiSearchInGithubRepo}, \link{copyGithubRepo} if in their
#' calls there will not be specified a \code{user} parameter.
#' @param branch Only if working with a Github repository. A character containing a name of 
#' Github Repository's branch that will be used in
#' functions: \link{zipGithubRepo}, \link{loadFromGithubRepo}, \link{searchInGithubRepo}, \link{getTagsGithub}, \link{showGithubRepo}, \link{summaryGithubRepo}, \link{multiSearchInGithubRepo}, \link{copyGithubRepo} if in their
#' calls there will not be specified a \code{branch} parameter.
#' @param repoDirGit Only if working with a Github repository. A character containing a name of a directory on Github repository 
#' on which the Repository is stored that will be used in
#' functions: \link{zipGithubRepo}, \link{loadFromGithubRepo}, \link{searchInGithubRepo}, \link{getTagsGithub}, \link{showGithubRepo}, \link{summaryGithubRepo}, \link{multiSearchInGithubRepo}, \link{copyGithubRepo} if in their
#' calls there will not be specified a \code{repoDirGit} parameter. If the Repository is stored in main folder on Github repository, this should be set 
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
#' deleteRepo( exampleRepoDir, TRUE)
#' rm( exampleRepoDir )
#' 
#' ## Github version
#' setGithubRepo( user="MarcinKosinski", repo="Museum", branch="master",
#' repoDirGit="ex1" )
#' 
#' loadFromGithubRepo( "ff575c261c949d073b2895b05d1097c3")
#' this <- loadFromGithubRepo( "ff", value = T)
#' zipGithubRepo( )
#' searchInGithubRepo( "name:", fixed= FALSE)
#' getTagsGithub("ff575c261c949d073b2895b05d1097c3")
#' 
#' summaryGithubRepo( )
#' showGithubRepo( )
#' 
#' setGithubRepo( user="pbiecek", repo="archivist" )
#' 
#' multiSearchInGithubRepo( patterns=c("varname:Sepal.Width", "class:lm", "name:myplot123"), 
#'                          intersect = FALSE )
#'
#' }
#' @family archivist
#' @rdname setRepo
#' @export
setLocalRepo <- function( repoDir ){
  stopifnot( is.character(repoDir) )
  
  repoDir <- checkDirectory( repoDir )
  
  invisible(aoptions("repoDir", repoDir))
  
#  assign( ".repoDir", repoDir, envir = .ArchivistEnv )
  
}


#' @family archivist
#' @rdname setRepo
#' @export
setGithubRepo <- function( user, repo, branch = "master", 
                           repoDirGit = NULL){
  stopifnot( is.character( c( repo, user, branch ) ) )
  stopifnot( is.null( repoDirGit ) | is.character( repoDirGit ) )
  
  aoptions("user", user)
  aoptions("repo", repo)
  aoptions("branch", branch)
  aoptions("repoDirGit", repoDirGit)
  
#   assign( ".user", user, envir = .ArchivistEnv )
#   assign( ".repo", repo, envir = .ArchivistEnv )
#   assign( ".branch", branch, envir = .ArchivistEnv )
#   assign( ".repoDirGit", repoDirGit , envir = .ArchivistEnv )
  
}


useGithubSetupArguments <- function(){
#   assign( "repo", get( ".repo", envir = .ArchivistEnv ), envir = parent.frame(2) )
#   assign( "user", get( ".user", envir = .ArchivistEnv ), envir = parent.frame(2) )
#   assign( "branch", get( ".branch", envir = .ArchivistEnv ), envir = parent.frame(2) )
#   assign( "repoDirGit", get( ".repoDirGit", envir = .ArchivistEnv ), envir = parent.frame(2) )

  assign( "repo", aoptions("repo"), envir = parent.frame(2) )
  assign( "user", aoptions("user"), envir = parent.frame(2) )
  assign( "branch", aoptions("branch"), envir = parent.frame(2) )
  assign( "repoDirGit", aoptions("repoDirGit"), envir = parent.frame(2) )
}


GithubCheck <- function( repo, user, repoDirGit ){
  stopifnot( is.logical( repoDirGit ) | is.character( repoDirGit ) )
  stopifnot( is.null( repo ) | is.character( repo ) )
  stopifnot( is.null( user ) | is.character( user ) )
  #
  if( is.logical( repoDirGit ) ){
    if ( repoDirGit ){
      stop( "repoDirGit may be only FALSE or a character. See documentation." )
    }
  }
  
  if ( xor( is.null( user ), is.null( repo ) ) ){
    stop( "Both or none of user and repo should be NULL. See documentation." )
  }
  
  if ( is.null( c( repo, user ) ) ){
    useGithubSetupArguments( ) 
  }
  
}


