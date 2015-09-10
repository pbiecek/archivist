##    archivist package for R
##
#' @title Read Artifacts Given as a List of Tags
#'
#' @description
#' \code{asearch} searches for artifacts that contain all specified Tags 
#' and reads all of them from a Github \link{Repository}. It's a wrapper around 
#' \link{multiSearchInGithubRepo} and \link{loadFromGithubRepo}.
#' 
#' @details
#' Function \code{asearch} reads all artifacts that contain given list of tags
#' from GitHub Repository.
#' It uses the function \link{loadFromGithubRepo} and
#' \link{multiSearchInGithubRepo} but has shorter name and
#' different paramter's specification.
#' 
#' @param repo One of following:
#' 
#' A character with GitHub user name and GitHub repository name separated by `/`.
#' 
#' NULL in this case search will be performed in the default repo.
#' 
#' @param patterns  A character vector of tags. Only artifacts that 
#' contain all tags are returned.  
#' 
#' @return This function returns list of artifacts (by value).
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' @examples
#' \dontrun{
#' # read the object
#' asearch("pbiecek/graphGallery", 
#'            patterns = list("class:lm", 
#'                 "varname:Species")))
#' }
#' @family archivist
#' @rdname asearch
#' @export
asearch <- function( repo = NULL, patterns){
  stopifnot( is.character( repo ) | is.null(repo) )
  stopifnot( is.character( patterns ) )

  if (is.null(repo)) {
    # use default repo
    oblist <- multiSearchInLocalRepo(patterns = patterns,
                                      intersect = TRUE)
    res <- list()
    if (length(oblist)>0) {
      res <- lapply(oblist, aread)
    } 
    
  } else {
    # at least 3 elements
    # it's GitHub Repo
    elements <- strsplit(repo, "/")[[1]]
    stopifnot( length(elements) >= 2 )
    
    oblist <- multiSearchInGithubRepo(user = elements[1], repo=paste(elements[-1], collapse = "/"), 
                                      patterns = patterns,
                                      intersect = TRUE)
    res <- list()
    if (length(oblist)>0) {
      res <- lapply(paste0(repo, "/", oblist), aread)
    } 
  } 
  res
}
