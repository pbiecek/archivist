##    archivist package for R
##
#' @title Show Artifact's List of Foramts
#'
#' @description
#' \code{aformat} extracts artifact's formats. Having formats one may decide which should he read.
#' Currently only rda format is supported for artifact and txt/png for miniatures.
#' 
#' @param md5hash One of the following (see \link{aread}):
#' 
#' A character vector which elements  are consisting of at least three components separated with '/': Remote user name, Remote repository and name of the artifact (MD5 hash) or it's abbreviation.
#' 
#' MD5 hashes of artifacts in current local default directory or its abbreviations.
#' 
#' @return A vector of characters.
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' @examples
#' \dontrun{
#' setLocalRepo(system.file("graphGallery", package = "archivist"))
#' aformat("2a6e492cb6982f230e48cf46023e2e4f")
#' 
#' # old
#' aformat("pbiecek/graphGallery/2a6e492cb6982f230e48cf46023e2e4f")
#' # png
#' aformat("pbiecek/graphGallery/f05f0ed0662fe01850ec1b928830ef32")
#' }
#' @family archivist
#' @rdname aformat
#' @export

aformat <- function( md5hash = NULL) {
  elements <- strsplit(md5hash, "/")[[1]]
  stopifnot( length(elements) >= 3 | length(elements) == 1)
  if (length(elements) == 1) {
    # local directory
    tags <- getTagsLocal(md5hash, tag = "")
  } else {
    # Remote directory
    tags <- getTagsRemote(tail(elements,1), repo = elements[2],
                          subdir = ifelse(length(elements) > 3, paste(elements[3:(length(elements)-1)], collapse="/"), "/"),
                          user = elements[1], tag = "")
  }
  return(gsub(grep(tags,  pattern="^format:", value = TRUE), pattern="^format:", replacement=""))
}
