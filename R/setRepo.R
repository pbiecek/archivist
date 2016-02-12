##    archivist package for R
##
#' @title Set Repository's Global Path  
#'
#' @description
#' \code{setLocalRepo} sets local \link{Repository}'s global path.
#' \code{setRemoteRepo} similarly sets Remote Repository's path.
#' See examples. 
#' 
#' @details
#' If you are working on a local Repository and you are tired of specifying \code{repoDir}
#' parameter in every function call that uses this parameter, you can set Repository's path
#' globally using \code{setLocalRepo} function and omit \code{repoDir} parameter
#' in future function calls.
#' 
#' If you are working on the Remote Repository and you are tired of specifying \code{user}, 
#' \code{repo}, \code{branch} and \code{subdir} parameters in every function call
#' that uses these parameters, you can set Remote Repository's path globally using
#' \code{setRemoteRepo} function and omit \code{user}, \code{repo}, \code{branch}
#' and \code{subdir} parameters in future function calls. See examples.
#' 
#' For local repositories, in this way, in the following function calls: 
#' \link{loadFromLocalRepo},\link{searchInLocalRepo}, \link{rmFromLocalRepo}, \link{zipLocalRepo}, 
#' \link{addTagsRepo}, \link{shinySearchInLocalRepo},
#' \link{getTagsLocal}, \link{showLocalRepo}, \link{summaryLocalRepo} 
#' \code{repoDir} parameter may be omitted. 
#' For remote repositories, in this way,
#' in the following function calls:
#' \link{zipRemoteRepo}, \link{loadFromRemoteRepo}, \link{searchInRemoteRepo},
#' \link{getTagsRemote}, \link{showRemoteRepo}, \link{summaryRemoteRepo},
#' \link{copyRemoteRepo}
#' parameters \code{user}, \code{repo}, \code{branch}, \code{subdir}  may be omitted.
#' 
#' @seealso
#' 
#' \href{https://github.com/pbiecek/archivist/wiki}{https://github.com/pbiecek/archivist/wiki}
#' 
#' @param repoDir A character denoting a directory of a Repository that we want to
#' make dafault. 
#' 
#' @param repo While working with the Remote repository. A character containing
#' a name of the Remote repository that we want to make default. 
#' 
#' @param repoType A character containing a type of the remote repository. 
#' Currently it can be 'github' or 'bitbucket'.
#' 
#' @param user While working with the Remote repository. A character containing
#' a name of the Remote user that we want to make default. 
#' 
#' @param branch While working with the Remote repository. A character containing a name of 
#' the Remote Repository's branch that we want to make default. Default \code{branch} is \code{master}.
#' 
#' @param subdir While working with the Remote repository. A character containing a name
#' of the Repository's directory on Remote that we want to make default.
#' If the Repository is stored in the main folder on the Remote repository,
#' this should be set to \code{subdir = "/"} as default.
#' 
#' @author 
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#' 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' @examples
#' 
#' ## Local version
#' exampleRepoDir <- tempfile()
#' createLocalRepo(repoDir = exampleRepoDir)
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
#' searchInLocalRepo("name:i", fixed = FALSE)
#' getTagsLocal("ff575c261c949d073b2895b05d1097c3")
#' rmFromLocalRepo("4c43f")
#' showLocalRepo()
#' summaryLocalRepo()
#' 
#' # REMEMBER that in deleteLocalRepo you MUST specify repoDir parameter!
#' # deleteRepo doesn't take setLocalRepo's settings into consideration
#' deleteLocalRepo( exampleRepoDir, deleteRoot=TRUE)
#' rm( exampleRepoDir )
#' 
#' ## Github version
#' setRemoteRepo( user="MarcinKosinski", repo="Museum", branch="master",
#'                subdir="ex1" )
#'                
#' # From this moment user, repo, branch, subdir parameters may be ommitted
#' # in the following functions:
#' showRemoteRepo()
#' loadFromRemoteRepo( "ff575c261c949d073b2895b05d1097c3")
#' this <- loadFromRemoteRepo( "ff", value = TRUE)
#' zipRemoteRepo()
#' file.remove(file.path(getwd(), "repository.zip")) # We can remove this zip file
#' searchInRemoteRepo( "name:", fixed= FALSE)
#' getTagsRemote("ff575c261c949d073b2895b05d1097c3")
#' summaryRemoteRepo( )
#' 
#' # To use multisearchInRemoteRepo we should use repository with more than one artifact. 
#' setRemoteRepo( user="pbiecek", repo="archivist"  )
#'
#' # From this moment user and repo parameters may be ommitted in the following functions
#' showRemoteRepo()
#' searchInRemoteRepo( pattern=c("varname:Sepal.Width", "class:lm", "name:myplot123"), 
#'                          intersect = FALSE )
#' @family archivist
#' @rdname setRepo
#' @export
setLocalRepo <- function( repoDir ){
  stopifnot( is.character( repoDir ), length( repoDir ) == 1 )

  repoDir <- checkDirectory( repoDir )
  
  invisible(aoptions("repoDir", repoDir))
}


#' @family archivist
#' @rdname setRepo
#' @export
setRemoteRepo <- function( user, repo, branch = "master", 
                           subdir = "/", repoType='github'){
  RemoteRepoCheck( repo, user, branch, subdir, repoType) 
  
  aoptions("user", user)
  aoptions("repo", repo)
  aoptions("branch", branch)
  aoptions("subdir", subdir)
  aoptions("repoType", repoType)
  
  invisible(NULL)
}


RemoteRepoCheck <- function( repo, user, branch, subdir, repoType){
  stopifnot( ( is.character( subdir ) & length( subdir ) == 1) )
  stopifnot( is.null( repo ) | ( is.character( repo ) & length( repo ) == 1 ) )
  stopifnot( is.null( user ) | ( is.character( user ) & length( user ) == 1 ) )
  stopifnot( ( is.character( branch ) & length( branch ) == 1 ) )
  
  if ( xor( is.null( user ), is.null( repo ) ) ){
    stop( "Both or none of user and repo should be NULL. See documentation." )
  }
}
