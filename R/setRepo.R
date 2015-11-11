##    archivist package for R
##
#' @title Set Repository's Global Path  
#'
#' @description
#' \code{setLocalRepo} sets local \link{Repository}'s global path.
#' \code{setGithubRepo} similarly sets Github Repository's path.
#' See examples. 
#' 
#' @details
#' If you are working on a local Repository and you are tired of specifying \code{repoDir}
#' parameter in every function call that uses this parameter, you can set Repository's path
#' globally using \code{setLocalRepo} function and omit \code{repoDir} parameter
#' in future function calls.
#' 
#' If you are working on the Github Repository and you are tired of specifying \code{user}, 
#' \code{repo}, \code{branch} and \code{repoDirGit} parameters in every function call
#' that uses these parameters, you can set Github Repository's path globally using
#' \code{setGithubRepo} function and omit \code{user}, \code{repo}, \code{branch}
#' and \code{repoDirGit} parameters in future function calls. See examples.
#' 
#' @seealso
#' 
#' \href{https://github.com/pbiecek/archivist/wiki}{https://github.com/pbiecek/archivist/wiki}
#' 
#' @param repoDir A character denoting a directory of a Repository that we want to
#' make dafault. In this way, in the following function calls: \link{saveToRepo},
#' \link{loadFromLocalRepo},\link{searchInLocalRepo}, \link{rmFromRepo}, \link{zipLocalRepo}, 
#' \link{multiSearchInLocalRepo}, \link{addTagsRepo}, \link{shinySearchInLocalRepo},
#' \link{getTagsLocal}, \link{showLocalRepo}, \link{summaryLocalRepo} 
#' \code{repoDir} parameter may be omitted. 
#' 
#' @param repo While working with the Github repository. A character containing
#' a name of the Github repository that we want to make default. In this way,
#' in the following function calls:
#' \link{zipGithubRepo}, \link{loadFromGithubRepo}, \link{searchInGithubRepo},
#' \link{getTagsGithub}, \link{showGithubRepo}, \link{summaryGithubRepo},
#' \link{multiSearchInGithubRepo}, \link{copyGithubRepo}
#' \code{repo} parameter may be omitted. 
#' 
#' @param user While working with the Github repository. A character containing
#' a name of the Github user that we want to make default. In this way,
#' in the following function calls:
#' \link{zipGithubRepo}, \link{loadFromGithubRepo}, \link{searchInGithubRepo},
#' \link{getTagsGithub}, \link{showGithubRepo}, \link{summaryGithubRepo},
#' \link{multiSearchInGithubRepo}, \link{copyGithubRepo}
#' \code{user} parameter may be omitted.
#' 
#' @param branch While working with the Github repository. A character containing a name of 
#' the Github Repository's branch that we want to make default. In this way,
#' in the following function calls:
#' \link{zipGithubRepo}, \link{loadFromGithubRepo},
#' \link{searchInGithubRepo}, \link{getTagsGithub}, \link{showGithubRepo},
#' \link{summaryGithubRepo}, \link{multiSearchInGithubRepo},
#' \link{copyGithubRepo} 
#' \code{branch} parameter may be omitted. Default \code{branch} is \code{master}.
#' 
#' @param repoDirGit While working with the Github repository. A character containing a name
#' of the Repository's directory on Github that we want to make default.
#' In this way, in the following function calls:
#' \link{zipGithubRepo}, \link{loadFromGithubRepo}, \link{searchInGithubRepo},
#' \link{getTagsGithub}, \link{showGithubRepo}, \link{summaryGithubRepo},
#' \link{multiSearchInGithubRepo}, \link{copyGithubRepo}
#' \code{repoDirGit} parameter may be omitted.
#' If the Repository is stored in the main folder on the Github repository,
#' this should be set to \code{repoDirGit = FALSE} as default.
#' 
#' @author 
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#' 
#' @examples
#' 
#' \dontrun{
#' ## Local version
#' exampleRepoDir <- tempfile()
#' createEmptyRepo(repoDir = exampleRepoDir)
#' setLocalRepo(exampleRepoDir) 
#' 
#' data(iris)
#' data(swiss)
#' 
#' # From this moment repoDir parameter may be ommitted in the following functions
#' saveToRepo(iris)
#' saveToRepo(swiss) 
#' showLocalRepo()
#' showLocalRepo(method = "tags")
#' iris2 <- loadFromLocalRepo( "ff575c2" , value = TRUE)
#' searchInLocalRepo("name:i", fixed = F)
#' getTagsLocal("ff575c261c949d073b2895b05d1097c3")
#' rmFromRepo("4c43f")
#' showLocalRepo()
#' summaryLocalRepo()
#' 
#' # REMEMBER that in deleteRepo you MUST specify repoDir parameter!
#' # deleteRepo doesn't take setLocalRepo's settings into consideration
#' deleteRepo( exampleRepoDir, deleteRoot=TRUE)
#' rm( exampleRepoDir )
#' 
#' ## Github version
#' setGithubRepo( user="MarcinKosinski", repo="Museum", branch="master",
#'                repoDirGit="ex1" )
#'                
#' # From this moment repoDir parameter may be ommitted in the following functions
#' showGithubRepo()
#' loadFromGithubRepo( "ff575c261c949d073b2895b05d1097c3")
#' this <- loadFromGithubRepo( "ff", value = T)
#' zipGithubRepo()
#' file.remove(file.path(getwd(), "repository.zip")) # We can remove this zip file
#' searchInGithubRepo( "name:", fixed= FALSE)
#' getTagsGithub("ff575c261c949d073b2895b05d1097c3")
#' summaryGithubRepo( )
#' 
#' # To use multisearchInGithubRepo we should use repository with more than one artifact. 
#' setGithubRepo( user="pbiecek", repo="archivist"  )
#'
#' # From this moment repoDir parameter may be ommitted in the following functions
#' showGithubRepo()
#' multiSearchInGithubRepo( patterns=c("varname:Sepal.Width", "class:lm", "name:myplot123"), 
#'                          intersect = FALSE )
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
                           repoDirGit = FALSE){
  stopifnot( is.character( c( repo, user, branch ) ) )
  stopifnot( is.logical( repoDirGit ) | is.character( repoDirGit ) )
  
  aoptions("user", user)
  aoptions("repo", repo)
  aoptions("branch", branch)
  aoptions("repoDirGit", repoDirGit)
#   assign( ".user", user, envir = .ArchivistEnv )
#   assign( ".repo", repo, envir = .ArchivistEnv )
#   assign( ".branch", branch, envir = .ArchivistEnv )
#   assign( ".repoDirGit", repoDirGit , envir = .ArchivistEnv )
  invisible(NULL)
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


