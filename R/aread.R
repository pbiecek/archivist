##    archivist package for R
##
#' @title Read Artifact Given as a md5hash from a Repository
#'
#' @description
#' \code{aread} reads an artifact from a Github \link{Repository}. It's a wrapper around 
#' \link{loadFromGithubRepo}.
#' 
#' @details
#' Function \code{aread} read artifact (by the \code{md5hash}) from GitHub Repository.
#' It uses the function \link{loadFromGithubRepo} with different paramter's specification.
#' 
#' @param md5hash One from following:
#' 
#' A character with at least three components sepearated with '/': GitHub user name, GitHub repository and name of the artifact (MD5 hash) or it's abbreviation
#' A MD5 hash of object in current local default directory or it's abbreviation.
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' @examples
#' \dontrun{
#' # read the object from local directory
#' setLocalRepo(system.file("graphGallery", package = "archivist"))
#' pl <- aread("2166dfbd3a7a68a91a2f8e6df1a44111")
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
    stopifnot( length(elements) >= 3 | length(elements) == 3)
    if (length(elements) == 1) {
      # local directory
      res[[md5h]] <- loadFromLocalRepo(md5hash = elements, value = TRUE)
    } else {
      # GitHub directory
      res[[md5h]] <- loadFromGithubRepo(md5hash = elements[length(elements)], 
                                        repo = elements[2],
                                        repoDirGit = ifelse(length(elements) > 3, paste(elements[3:(length(elements)-1)], collapse="/"), FALSE),
                                        user = elements[1], value = TRUE)
    }
  }
  if (length(res) == 1) return(res[[1]]) else res
}
