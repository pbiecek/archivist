##    archivist package for R
##
#' @title Read Artifacts Given as md5hashes from the Repository
#'
#' @description
#' \code{aread} reads the artifact from the \link{Repository}. It's a wrapper around 
#' \link{loadFromLocalRepo} and \link{loadFromGithubRepo}.
#' 
#' @details
#' Function \code{aread} reads artifacts (by \code{md5hashes}) from GitHub Repository.
#' It uses \link{loadFromLocalRepo} and \link{loadFromGithubRepo} functions
#' with different parameter's specification.
#' 
#' @note
#' Before you start using this function, remember to set local or github repository
#' to default by using \code{setLocalRepo()} or \code{setGithubRepo} functions.
#' 
#' @param md5hash One of the following:
#' 
#' A character vector which elements  are consisting of at least three components separated with '/': GitHub user name, GitHub repository and name of the artifact (MD5 hash) or it's abbreviation.
#' 
#' MD5 hashes of artifacts in current local default directory or its abbreviations.
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' @examples
#' \dontrun{
#' # read the object from local directory
#' setLocalRepo(system.file("graphGallery", package = "archivist"))
#' pl <- aread("2166dfbd3a7a68a91a2f8e6df1a44111")
#' # plot it
#' pl
#' # read the object from GitHub
#' pl <- aread("pbiecek/graphGallery/2166dfbd3a7a68a91a2f8e6df1a44111")
#' # plot it
#' pl
#' }
#' @family archivist
#' @rdname aread
#' @export
aread <- function( md5hash){
  stopifnot( is.character( md5hash ) )

  # work for vectors  
  res <- list()
  for (md5h in md5hash) {
    # at least 3 elements
    elements <- strsplit(md5h, "/")[[1]]
    stopifnot( length(elements) >= 3 | length(elements) == 1)
    if (length(elements) == 1) {
      # local directory
      res[[md5h]] <- loadFromRepo(type = "local", md5hash = elements, value = TRUE)
    } else {
      # GitHub directory
      res[[md5h]] <- loadFromRepo(type = "github", md5hash = elements[length(elements)], 
                                        repo = elements[2],
                                        repoDirGit = ifelse(length(elements) > 3, paste(elements[3:(length(elements)-1)], collapse="/"), FALSE),
                                        user = elements[1], value = TRUE)
    }
  }
  if (length(res) == 1) return(res[[1]]) else res
}
