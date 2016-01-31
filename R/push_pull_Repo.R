##  archivist package for R
##
#' @title Push and Pull for Local Repository Synchronized with GitHub
#'
#' @description
#' 
#' \code{pushRepo} adds files, commits them and pushes from Local \link{Repository} to synchronized GitHub one. 
#' \code{pullRepo} pulls (\code{git pull}) changes from remote GitHub \code{Repository} to the correspoding Local one.
#' More archivist functionalities that integrate archivist and GitHub API can be found here \link{archivist-github-integration} (\link{agithub}).
#'  
#' @param repoDir A character specifing the directory to Local \code{Repository} to/from which artifacts will be pulled/pushed to GitHub.
#' @param commitMessage A character denoting a message added to the commit while performing push.
#' By default specified to \code{NULL} which corresponds to commit message \code{archivist: pushRepo}.
#' @param repo A character denoting GitHub repository name and synchronized local existing directory in which an artifact will be saved.
#' @param user A character denoting GitHub user name. Can be set globally with \code{aoptions("user", user)}.
#'  See \link{archivist-github-integration}.
#' @param password A character denoting GitHub user password. Can be set globally with \code{aoptions("password", password)}.
#' See \link{archivist-github-integration}.
#' @param files A character vector containing directories to files that should be commited and pushed. The working directory
#' is \code{repoDir}. By default all uncommited artifacts and \code{backpack.db} will be pushed.
#' @param ... Further arguments passed to \link[git2r]{push} or \link[git2r]{pull}.
#' 
#' 
#' @note To check the \code{status} (\code{git status}) of the Repository use \code{git2r::status(repository(repoDir))}. See examples.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @examples 
#' \dontrun{
#' 
#' library(httr)
#' myapp <- oauth_app("github",
#'                    key = app_key,
#'                    secret = app_secret)
#' github_token <- oauth2.0_token(oauth_endpoints("github"),
#'                                 myapp,
#'                                 scope = c("public_repo",
#'                                           "delete_repo"))
#' aoptions("github_token", github_token)
#' aoptions("name", user.name)
#' aoptions("password", user.password)
#' 
#' createEmptyGithubRepo("Museum", default = TRUE) # here github_token is used
#' data(iris)
#' saveToRepo(iris)
#' git2r::status(repository('Museum'))
#' pushRepo(commitMessage = "add iris")
#' git2r::status(repository('Museum'))
#' 
#' }
#' @family archivist
#' @rdname pushRepo
#' @export
pushRepo <- function(repoDir = aoptions('repoDir'), 
                     commitMessage = aoptions("commitMessage"),
                     repo = aoptions("repo"), 
                     user = aoptions("user"),
                     password = aoptions("password"),
                     files = c("gallery", "backpack.db")) {
  stopifnot(is.character(repo) & length(repo) == 1)
  stopifnot(is.character(user) & length(user) == 1)
  stopifnot(is.character(password) & length(password) == 1)
  stopifnot(is.character(repoDir) & length(repoDir) == 1)
  stopifnot(is.null(commitMessage) | (is.character(commitMessage) & length(commitMessage) == 1))
  stopifnot(is.character(files))
                         
  repo <- git2r::repository(repoDir)
  
  git2r::add(repo, files)
  
  if (is.null(commitMessage)){
    new_commit <- commit(repo, "archivist: pushRepo")
  } else {
    new_commit <- commit(repo, commitMessage)
  }
    
  # authentication with GitHub
  cred <- cred_user_pass(user,
                         password)
  
  # wyslanie do repozytorium na githubie
  git2r::push(repo,
       #name = "upstream2",
       refspec = "refs/heads/master",
       credentials = cred,
       ...)
}

#' @rdname pushRepo
#' @export
pullRepo <- function(repoDir = aoptions('repoDir'), 
                     user = aoptions("user"),
                     password = aoptions("password"),
                     ...) {
  stopifnot(is.character(user) & length(user) == 1)
  stopifnot(is.character(password) & length(password) == 1)
  stopifnot(is.character(repoDir) & length(repoDir) == 1)
  
  repo <- git2r::repository(repoDir)
  # authentication with GitHub
  cred <- cred_user_pass(user,
                         password)
  git2r::pull(repo, credentials = cred, ...)
  
}