##    archivist package for R
##
#' @title Clone Github Repository
#'
#' @description
#' \code{cloneGithubRepo} is a wrapper around \code{git clone} and clones GitHub Repository
#' into the \code{local_path} directory.
#' 
#' More archivist functionalities that integrate archivist and GitHub API can be found here \link{archivist-github-integration}.
#' @param repoURL The remote repository to clone.
#' @param local_path Local directory to clone to.
#' @param ... Further parameters passed to \link[git2r]{clone}.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}

#' 
#' @examples 
#' \dontrun{
#' 
#' cloneGithubRepo("https://github.com/MarcinKosinski/Museum")
#' cloneGithubRepo("https://github.com/MarcinKosinski/Museum-Extra")
#' 
#' }
#' @family archivist
#' @rdname cloneGithubRepo
#' @export
cloneGithubRepo <- function(repoURL, local_path, ...){
  stopifnot(url.exists(repoURL))
  stopifnot(is.character(local_path))
  git2r::clone(repoURL, local_path)
}