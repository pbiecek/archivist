##    archivist package for R
##
#' @title Clone Github Repository
#'
#' @description
#' \code{cloneGithubRepo} is a wrapper around \code{git clone} and clones GitHub Repository
#' into the \code{repoDir} directory.
#' 
#' More archivist functionalities that integrate archivist and GitHub API can be found here \link{archivist-github-integration} (\link{agithub}).
#' @param repoURL The remote repository to clone.
#' @param repoDir Local directory to clone to. If \code{NULL}, by default, creates a local directory,
#' which corresponds to the name after last \code{/} in \code{repoURL}.
#' @param default Sets cloned Repository as default Local and GitHub Repository. 
#' If \code{default = TRUE} then \code{repoDir} (last piece of \code{repoURL}) is set as default Local Repository 
#'  and for GitHub repository also the \code{user} from  \code{repoURL} is set as default GitHub user).
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
#' aoptions("name", user_name)
#' aoptions("password", user_password)
#' 
#' createEmptyGithubRepo("archive-test4")
#' setGithubRepo(aoptions("name"), "archive-test4")
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
#' setGithubRepo(aoptions("name"), "archive-test")
#' # equivalent is cloneGithubRepo('https://github.com/MarcinKosinski/archive-test', default = TRUE)
#' # check if default is set with
#' # aoptions('repoDir'); aoptions('repo'); aoptions('user')
#' data(iris)
#' archive(iris)
#' showGithubRepo()
#' 
#' 
#' }
#' @family archivist
#' @rdname cloneGithubRepo
#' @export
cloneGithubRepo <- function(repoURL, repoDir = NULL, default = FALSE, ...){

  stopifnot(url.exists(repoURL))
  stopifnot((is.character(repoDir) & length(repoDir) == 1) | is.null(repoDir))
  stopifnot( is.logical( default ), length( default ) == 1 )
  
  if (is.null(repoDir)) {
    repoDir <-tail(strsplit(repoURL,
                               "/")[[1]],1)
  }
  
  if (!file.exists(repoDir)) {
    dir.create(repoDir)
  }
  git2r::clone(repoURL, repoDir, ...) -> repo2return
  

  if (default) {
    setLocalRepo(repoDir)
    setGithubRepo(user = tail(strsplit(repoURL,
                                       "/")[[1]],2)[1],
                  repo = tail(strsplit(repoURL,
                                                        "/")[[1]],1))
  }
  return(repo2return)
}
