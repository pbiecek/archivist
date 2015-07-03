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
#' @param md5hash A character with at least trhee components, GitHub user name, GitHub repository and name of the artifact assigned to the artifact as a result of a cryptographical hash function with MD5 algorithm, or it's abbreviation.
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' @examples
#' \dontrun{
#' # read the object
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
    stopifnot( length(elements) >= 3 )
    
    res[[md5h]] <- loadFromGithubRepo(md5hash = elements[length(elements)], 
                         repo=paste(elements[2:(length(elements)-1)], sep="/"), 
                         user = elements[1], value = TRUE)
  }
  if (length(res) == 1) return(res[[1]]) else res
}
