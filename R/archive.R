##    archivist package for R
##
#' @title Archive Artifact to Local and Github Repository
#'
#' @description
#' \code{archive}
#' 
#' More archivist functionalities that integrate archivist and GitHub API can be found here \link{archivist-github-integration}.
#' @param artifact An artifact to be archived on Local and Github \link{Repository}.
#' @param commitMessage A character denoting a message added to the commit while archiving \code{artifact} on GitHub Repository.
#' By default, an artifact's \link{md5hash} is added to the commit message.
#' @param repo A character denoting GitHub repository name.
#' @param github_token An OAuth GitHub Token created with the \link{oauth2.0_token} function. See \link{archivist-github-integration}.
#' Can be set globally with \code{aoptions("github_token", github_token)}.
#' @param user.name A character denoting GitHub user name. Can be set globally with \code{aoptions("user.name", user.name)}.
#'  See \link{archivist-github-integration}.
#' @param user.password A character denoting GitHub user password. Can be set globally with \code{aoptions("user.password", user.password)}.
#' See \link{archivist-github-integration}.
#' @param response A logical value. Should the GitHub API response should be returned.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @examples 
#' \dontrun{
#' 
#' ## Empty Github Repository Creation
#' library(httr)
#' myapp <- oauth_app("github",
#'                    key = app_key,
#'                    secret = app_secret)
#' github_token <- oauth2.0_token(oauth_endpoints("github"),
#'                                 myapp,
#'                                 scope = "public_repo")
#' aoptions("github_token", github_token)
#' aoptions("user.name", user.name)
#' aoptions("user.password", user.password)
#' 
#' createEmptyGithubRepo("Museum")
#' setGithubRepo(aoptions("user.name"), "Museum")
#' ## artifact's archiving
#' 
#' data(iris)
#' archive(iris) -> md5hash_path
#' 
#' ## proof that artifact is really archived
#' showGithubRepo() # uses options from setGithubRepo
#' # let's remove iris
#' rm(iris)
#' # and load it back from md5hash_path
#' aread(md5hash_path)
#' 
#' }
#' @family archivist
#' @rdname archive
#' @export
archive <- function(artifact, commitMessage = aoptions("commitMessage"),
                    repo = aoptions("repo"), 
                    github_token = aoptions("github_token"), 
                    user.name = aoptions("user.name"),
                    user.password = aoptions("user.password"),
                    response = aoptions("response")){
  stopifnot(is.character(repo) & length(repo) ==1)
  stopifnot(is.character(user.name) & length(user.name)==1)
  stopifnot(is.character(user.password) & length(user.password)==1)
  stopifnot(is.logical(response) & length(response) ==1)
  
}