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
#' @param local_path Local directory to clone to. If \code{NULL}, by default, creates a local directory
#' which corresponds to the name after last \code{/} in \code{repoURL}.
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
cloneGithubRepo <- function(repoURL, local_path = NULL, ...){
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