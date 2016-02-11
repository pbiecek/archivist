##    archivist package for R
##
#' @title Get http Hook for Remote Repo
#'
#' @description
#' \code{getRemoteHook} returns http adress of the remote \link{Repository}.
#' Then it can be used to download artifacts from the remote \link{Repository}.
#' 
#' @param repoType A character containing a type of the remote repository. Currently it can be 'github' or 'bitbucket'.
#' @param repo A character containing a name of a Git repository on which the Repository is archived.
#' @param user A character containing a name of a Git user on whose account the \code{repo} is created.
#' @param branch A character containing a name of Git Repository's branch on which the Repository is archived. 
#' Default \code{branch} is \code{master}.
#' @param subdir A character containing a name of a directory on Git repository 
#' on which the Repository is stored. If the Repository is stored in main folder on Git repository, this should be set 
#' to \code{subdir = "/"} as default.
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

getRemoteHook <- function(repo = aoptions("repo"), user = aoptions("user"), branch = aoptions("branch"), subdir = aoptions("subdir") ,
                          repoType = aoptions("repoType")) {
  stopifnot( is.character( repoType ), length( repoType ) == 1 )

  switch(repoType,
         github = getRemoteHookGithub(repo, user, branch, subdir),
         bitbucket = getRemoteHookBitbucket(repo, user, branch, subdir),
         stop("No such repoType"))
}

getRemoteHookGithub <- function(repo = aoptions("repo"), user = aoptions("user"), branch = aoptions("branch"), subdir = aoptions("subdir") ){
  stopifnot( is.character( c(branch ) ), length( branch ) == 1 )

  if (subdir == "/") {
    return(file.path( "https://raw.githubusercontent.com", user, repo, branch))
  } else {
    return(file.path( "https://raw.githubusercontent.com", user, repo, branch, subdir))
  }
}

getRemoteHookBitbucket <- function(repo = aoptions("repo"), user = aoptions("user"), branch = aoptions("branch"), subdir = aoptions("subdir") ){
  stopifnot( is.character( c(branch ) ), length( branch ) == 1 )
  repo <- tolower(repo)
  json <- readLines(paste0("https://api.bitbucket.org/2.0/repositories/",user,"/",repo,"/commits/"), warn = FALSE)
  tmp <- strsplit(json, split='"')[[1]]
  last_commit <- tmp[which(tmp == "hash")+2]
  
  if (subdir == "/") {
    return(file.path("https://bitbucket.org",user,repo,"raw",last_commit))
  } else {
#    paste0(file.path("https://bitbucket.org",user,repo,"raw",last_commit,subdir,"?at="),branch)
    return(file.path("https://bitbucket.org",user,repo,"raw",last_commit,subdir))
  }
}


getRemoteHookToFile <- function(repo = aoptions("repo"), 
                                user = aoptions("user"), 
                                branch = aoptions("branch"), 
                                subdir = aoptions("subdir") ,
                                repoType = aoptions("repoType"),
                                file = "backpack.db") {
  stopifnot( is.character( repoType ), length( repoType ) == 1 )
  
  switch(repoType,
         github = getRemoteHookToFileGithub(repo, user, branch, subdir, file),
         bitbucket = getRemoteHookToFileBitbucket(repo, user, branch, subdir, file),
         stop("No such repoType"))
}

getRemoteHookToFileGithub <- function(repo = aoptions("repo"), user = aoptions("user"), branch = aoptions("branch"), subdir = aoptions("subdir"), file="backpack.db"){
  file.path(getRemoteHookGithub(repo=repo, user=user, branch=branch, subdir=subdir), file)
}

getRemoteHookToFileBitbucket <- function(repo = aoptions("repo"), user = aoptions("user"), branch = aoptions("branch"), subdir = aoptions("subdir"), file="backpack.db"){
  file.path(getRemoteHookBitbucket(repo=repo, user=user, branch=branch, subdir=subdir), file)
}
