##    archivist package for R
##
#' @title View the List of Artifacts from the Repository 
#'
#' @description
#' \code{showLocalRepo} and \code{showRemoteRepo} functions produce the \code{data.frame} of the artifacts from
#' the \link{Repository} saved in a given \code{repoDir} (directory). \code{showLocalRepo}
#' shows the artifacts from the \code{Repository} that exists on the user's computer whereas \code{showRemoteRepo}
#' shows the artifacts of the \code{Repository} existing on the remote repository.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' \code{showLocalRepo} and \code{showRemoteRepo} functions produce the \code{data.frame} of the artifacts from
#' a \link{Repository} saved in a given \code{repoDir} (directory). \code{showLocalRepo}
#' shows the artifacts from the \code{Repository} that exists on the user's computer whereas \code{showRemoteRepo}
#' shows the artifacts of the \code{Repository} existing on the remote repository.
#' 
#' Both functions show the current state of a \code{Repository}, inter alia, all archived artifacts can
#' be seen with their unique \link{md5hash} or a \code{data.frame} with archived \link{Tags} can 
#' be obtained.
#' 
#' @param method A character specifying a method to be used to show the Repository. Available methods: 
#' \code{md5hashes} (default), \code{tags} and \code{sets} - see \href{https://github.com/pbiecek/archivist2}{archivist2::saveSetToRepo}.
#' 
#' @param repoType A character containing a type of the remote repository. Currently it can be 'github' or 'bitbucket'.
#' 
#' @param repoDir A character denoting an existing directory of the Repository for which metadata will be returned.
#' 
#' @param repo While working with the Remote repository. A character containing a name of the Remote repository on which the Repository is stored.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param user While working with the Remote repository. A character containing a name of the Remote user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}.
#'
#' @param branch While working with the Remote repository. A character containing a name of 
#' the Remote Repository's branch on which the Repository is stored. Default \code{branch} is \code{master}.
#'
#' @param subdir While working with the Remote repository. A character containing a name of a directory on the Remote repository 
#' on which the Repository is stored. If the Repository is stored in the main folder of the Remote repository, this should be set 
#' to \code{subdir = "/"} as default.
#' 
#' @return
#' 
#' If parameter \code{method} is set as \code{md5hashes} then a \code{data.frame} with artifacts' names and
#' artifacts'\code{md5hashes} will be returned.
#' 
#' If parameter \code{method} is set as \code{tags} then a \code{data.frame} with \code{Tags} and
#' artifacts' \code{md5hashes} will be returned.
#' 
#' Also in both cases a \code{data.frame} contains an extra column with the date of creation
#' of the \code{Tag} or \code{md5hash}.
#' 
#' To learn more about \code{Tags} or \code{md5hashes} check: \link{Tags} or \link{md5hash}.
#' 
#' 
#' @note
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in the Remote mode then global parameters
#' set in \link{setRemoteRepo} (or via \link{aoptions}) function are used.
#' 
#' @author 
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#' # objects preparation
#'
#' showLocalRepo(method = "md5hashes", 
#'    repoDir = system.file("graphGallery", package = "archivist"))
#' showLocalRepo(method = "tags", 
#'    repoDir = system.file("graphGallery", package = "archivist"))
#' 
#' 
#' # Remote version
#' 
#' showRemoteRepo(method = "md5hashes", user = "pbiecek", repo = "archivist")
#' showRemoteRepo(method = "tags", user = "pbiecek", repo = "archivist", branch = "master")
#' 
#' # many archivist-like Repositories on one Remote repository
#' 
#' showRemoteRepo( user="MarcinKosinski", repo="Museum", branch="master",
#'                 subdir="ex1")
#' showRemoteRepo( user="MarcinKosinski", repo="Museum", branch="master",
#'                 subdir="ex2")
#'                 
#' ## Remote options
#' showRemoteRepo('archivist', 'pbiecek')
#' aoptions('user', 'pbiecek')
#' aoptions('repo', 'archivist')
#' loadFromRemoteRepo("ff575c261c", value = TRUE) -> iris123
#' 
#' showRemoteRepo('Museum', 'MarcinKosinski', subdir = 'ex1')
#' aoptions('repo', 'Museum')
#' aoptions('user', 'MarcinKosinski')
#' aoptions('subdir', 'ex1')
#' aoptions('branch', 'master')
#' showRemoteRepo()
#' showRemoteRepo(subdir = 'ex2')
#' 
#' aoptions('subdir')
#'
#' 
#' }
#' @family archivist
#' @rdname showRepo
#' @export
showLocalRepo <- function( repoDir = aoptions("repoDir"), method = "md5hashes"){
  stopifnot( is.character( method ), length( method ) == 1 )
  stopifnot( is.character( repoDir ) & length( repoDir ) == 1 )
  
  repoDir <- checkDirectory( repoDir )
  
  showRepo( method = method, dir = repoDir )
}


#' @rdname showRepo
#' @export
showRemoteRepo <- function( repo = aoptions("repo"), user = aoptions("user"), branch = aoptions("branch"), subdir = aoptions("subdir"),
                            repoType = aoptions("repoType"),
                            method = "md5hashes" ){
  stopifnot( is.character( c( method, branch ) ), length( method ) == 1, length( branch ) == 1  )
  
  RemoteRepoCheck( repo, user, branch, subdir, repoType) # implemented in setRepo.R
  
  # database is needed to be downloaded
  remoteHook <- getRemoteHook(repo=repo, user=user, branch=branch, subdir=subdir, repoType=repoType)
  Temp <- downloadDB( remoteHook )
  
  showRepo( method = method, dir = Temp, local = FALSE )
}


showRepo <- function( method, local = TRUE, dir ){
  
  if ( method == "md5hashes" )
    value <- readSingleTable( dir, "artifact" )
  
  if ( method == "tags" )
    value <- readSingleTable( dir, "tag" )
  
  if ( method == "sets" ){
    value <- readSingleTable( dir, "tag" ) 
      onlySetsNumber <- grep( "set", value$tag )
      onlySetsHashes <- value[onlySetsNumber, "artifact"]
    value <- value[ value$artifact %in% onlySetsHashes, ]
  }
  
  return( value )
}
