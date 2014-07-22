##    archivist package for R
##
#' @title Save an Object into a Repository 
#'
#' @description
#' desc
#' 
#' 
#' @details
#' details
#' 
#' @param object An arbitrary R object to be saved.
#' 
#' @param ... Graphical parameters denoting width and hight of a miniature. See details.
#' 
#' @param archiveData A logical value denoting wheter to archive the data from object.
#' 
#' @param archiveTags A logical value denoting wheter to archive tags from object.
#' 
#' @param archiveMiniature A logical value denoting wheter to archive a miniature of an object.
#' 
#' @param dir A character denoting an existing directory in which an object will be saved.
#' 
#' @author autor
#'
#' @examples
#' #example
#' @family archivist
#' @rdname saveToRepo
#' @export
saveToRepo <- function( object, ..., archiveData = TRUE, 
                                     archiveTags = TRUE, 
                                     archiveMiniature = TRUE, dir ){
  stopifnot( is.character( dir ), is.logical( c( archiveData, archiveTags ) ) )
  md5hash <- digest(object)
  
  # check if dir has "/" at the end and add it if not
  if ( regexpr( pattern = ".$", text = dir) != "/" ){
    dir <- paste0( c ( dir, "/" ) )
  }
  
  # save object to .rd file
  dir.create(file.path(dir, md5hash), showWarnings = FALSE)
  save()
  
  # add entry to database 
  addArtifact( ) 
  
  # whether to add tags
  if ( archiveTags ) {
    extractedTags <- extractTags( object )
    sapply( extractedTags, addTags, md5hash = md5hash )
  }
  
  # whether to archive data
  if ( archiveData )
    extractData( object )
  
  # whether to archive miniature
  if ( archiveMiniature )
    extractMiniature( object, mdhash5, ... )
  
  # paste hash / return hash ?  cat( paste0( "message", md5hash ) )
}


