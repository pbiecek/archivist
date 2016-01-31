##    archivist package for R
##
#' @title Get http Hook for Remote Repo
#'
#' @description
#' \code{loadFromLocalRepo} loads an artifact from a local \link{Repository} into the workspace.
#' \code{loadFromGithubRepo} loads an artifact from a Github \link{Repository} into the workspace.
#' \code{loadFromRemoteRepo} loads an artifact from a git / mercurial \link{Repository} into the workspace.
#' \code{loadFromRepo} is a wrapper around \code{loadFromLocalRepo} and \code{loadFromGithubRepo}.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @param repo A character containing a name of a Git repository on which the Repository is archived.
#' @param user A character containing a name of a Git user on whose account the \code{repo} is created.
#' @param branch A character containing a name of Git Repository's branch on which the Repository is archived. 
#' Default \code{branch} is \code{master}.
#' @param repoDirGit A character containing a name of a directory on Git repository 
#' on which the Repository is stored. If the Repository is stored in main folder on Git repository, this should be set 
#' to \code{repoDirGit = FALSE} as default.
#' 
#' @author 
#' Przemysla Biecek, \email{przemyslaw.biecek@@gmail.com}
#'  
#' @examples
#' 
#' \dontrun{
#' # objects preparation
#' }
#' @family archivist
#' @rdname getRemoteHook
#' @export

getRemoteHookGithub <- function(repo = NULL, user = NULL, branch = "master", repoDirGit = FALSE ){
  stopifnot( is.character( c(branch ) ), length( branch ) == 1 )

  file.path( "https://raw.githubusercontent.com", user, repo, branch, repoDirGit)
}

getRemoteHookBitbucket <- function(repo = NULL, user = NULL, branch = "master", repoDirGit = FALSE ){
  stopifnot( is.character( c(branch ) ), length( branch ) == 1 )
  
  json <- readLines(paste0("https://api.bitbucket.org/2.0/repositories/",user,"/",repo,"/commits/"), warn = FALSE)
  tmp <- strsplit(json, split='"')[[1]]
  last_commit <- tmp[which(tmp == "hash")+2]
  
  if (repoDirGit == FALSE) {
    return(file.path("https://bitbucket.org",user,repo,"src",last_commit))
  } else {
#    paste0(file.path("https://bitbucket.org",user,repo,"src",last_commit,repoDirGit,"?at="),branch)
    return(file.path("https://bitbucket.org",user,repo,"src",last_commit,repoDirGit))
  }
}
