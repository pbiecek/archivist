##    archivist package for R
##
#' @title Clone Github Repository
#'
#' @description
#' \code{cloneGithubRepo} is a wrapper around \code{git clone} and clones GitHub Repository
#' into the \code{local_path} directory.
#' 
#' More archivist functionalities that integrate archivist and GitHub API can be found here \link{archivist-github-integration} (\link{agithub}).
#' @param repoURL The remote repository to clone.
#' @param repoDir Local directory to clone to. If \code{NULL}, by default, creates a local directory.
#' which corresponds to the name after last \code{/} in \code{repoURL}.
#' @param ... Further parameters passed to \link[git2r]{clone}.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' 
#' @examples 
#' \dontrun{
#' 
#' cloneGithubRepo("https://github.com/MarcinKosinski/Museum")
#' cloneGithubRepo("https://github.com/MarcinKosinski/Museum-Extra")
#' 
#' 
#' # empty Github Repository creation
#' 
#' library(httr)
#' myapp <- oauth_app("github",
#'                    key = app_key,
#'                    secret = app_secret)
#' github_token <- oauth2.0_token(oauth_endpoints("github"),
#'                                myapp,
#'                                scope = "public_repo")
#' # setting options                              
#' aoptions("github_token", github_token)
#' aoptions("user.name", user_name)
#' aoptions("user.password", user_password)
#' 
#' createEmptyGithubRepo("archive-test4")
#' setGithubRepo(aoptions("user.name"), "archive-test4")
#' ## artifact's archiving
#' przyklad <- 1:100
#' 
#' # archiving
#' archive(przyklad) -> md5hash_path
#' 
#' ## proof that artifact is really archived
#' showGithubRepo() # uses options from setGithubRepo
#' # let's remove przyklad
#' rm(przyklad)
#' # and load it back from md5hash_path
#' aread(md5hash_path)
#' 
#' 
#' # clone example
#' unlink("archive-test", recursive = TRUE)
#' cloneGithubRepo('https://github.com/MarcinKosinski/archive-test')
#' setGithubRepo(aoptions("user.name"), "archive-test")
#' data(iris)
#' archive(iris)
#' showGithubRepo()
#' 
#' 
#' }
#' @family archivist
#' @rdname cloneGithubRepo
#' @export
cloneGithubRepo <- function(repoURL, repoDir = NULL, ...){
  local_path <- repoDir
  stopifnot(url.exists(repoURL))
  stopifnot((is.character(local_path) & length(local_path) == 1) | is.null(local_path))
  
  if (is.null(local_path)) {
    local_path <-tail(strsplit(repoURL,
                               "/")[[1]],1)
  }
  
  if (!file.exists(local_path)) {
    dir.create(local_path)
  }
  git2r::clone(repoURL, local_path, ...)
}