##    archivist package for R
##
#' @title Returen a \code{Tag} Corresponding to \code{md5hash}
#'
#' @description
#' \code{returnTag} 
#' 
#' @details
#' \code{returnTag}
#' 
#' @return A tag.
#'
#' @param repoDir A character denoting an existing directory in 
#' which an artifact is stored.
#' 
#' @param md5hashes A character containing \code{md5hash} 
#' of artifacts which \code{Tag} is desired to be returned.
#' 
#' @param tag A type of a \link{Tags}. Default \code{tag = "name"}.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#' }
#' 
#' @family archivist
#' @rdname returnTag
#' @export
returnTag <- function( md5hash, repoDir, tag ="name"){
  stopifnot( is.character( c( md5hash, repoDir, tag ) ) )
  repoDir <- checkDirectory( repoDir )  
  tagToReturn <- executeSingleQuery( repoDir, 
                      paste0("SELECT DISTINCT tag FROM tag WHERE tag LIKE",
                                      "'", tag, "%'", "AND artifact='", md5hash,"'") )
  return(sub( pattern = paste0(tag, ":"), replacement = "", x = tagToReturn))
}



