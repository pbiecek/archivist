##    archivist package for R
##
#' @title Get http Hook for Remote Repo
#'
#' @description
#' \code{getRemoteHook} returns http adress of the remote \link{Repository}.
#' Then it can be used to download artifacts from the remote \link{Repository}.
#' 
#' @param type A character containing a type of the remote repository. Currently it can be 'github' or 'bitbucket'.
#' @param repo A character containing a name of a Git repository on which the Repository is archived.
#' @param user A character containing a name of a Git user on whose account the \code{repo} is created.
#' @param branch A character containing a name of Git Repository's branch on which the Repository is archived. 
#' Default \code{branch} is \code{master}.
#' @param repoDirGit A character containing a name of a directory on Git repository 
#' on which the Repository is stored. If the Repository is stored in main folder on Git repository, this should be set 
#' to \code{repoDirGit = FALSE} as default.
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#'  
#' @examples
#' 
#' \dontrun{
#' # objects preparation
#' getRemoteHook("graphGallery", "pbiecek")
#' }
#' @family archivist
#' @rdname getRemoteHook
#' @export

getRemoteHook <- function(repo = NULL, user = NULL, branch = "master", repoDirGit = FALSE ,
                          type = "github") {
  stopifnot( is.character( type ), length( type ) == 1 )

  switch(type,
         github = getRemoteHookGithub(repo, user, branch, repoDirGit),
         bitbucket = getRemoteHookBitbucket(repo, user, branch, repoDirGit))
}

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
