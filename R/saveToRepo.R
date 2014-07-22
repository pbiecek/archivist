##    archivist package for R
##
#' @title Save an Object into a Repository 
#'
#' @description
#' \code{svaeToRepo} function saves desired objects to the local Repository on a given directory.
#' 
#' 
#' @details
#' \code{saveToRepo} function saves desired objects to the local Repository on a given directory.
#' Objects are saved in the local Repository, which is a SQLite database named \code{backpack}. 
#' After every \code{saveToRepo} call the database is refreshed, so object is available immediately.
#' Every object is saved in a \code{object.rd} file, located in the folder (created in given directory) 
#' that is going to be named after a \code{md5hash} generated from object.
#' This \code{md5hash} is a string of length 32 that comes out as a result of \code{digest{digest}} function, 
#' which uses a cryptographical MD5 hash algorithm.
#' 
#' By default, from every object is extracted it's miniature and (if possible) a data set needed 
#' to compute this object. They are also going to be saved in a folder named by their \code{md5hash} and a specific
#' relation is being added to the \code{backpack} dataset in case there is an urge to load and object 
#' with it's related miniature and data - see \link{loadFromLocalRepo} or \link{loadFromGithubRepo}. Default settings
#' may be changed by using arguments \code{archiveData}, \code{archiveTag} or \code{archiveMiniature} with \code{FALSE}
#' value.
#' 
#' \code{Tags} are specific values of an object, different for various object's classes.
#' 
#' Archivised object can be searched in \code{backpack} dataset using functions 
#' \link{searchInLocalRepo} or \link{searchInGithubRepo}. Objects can by searched by their \code{Tags}, \code{names} or 
#' \code{object's classes}.
#' 
#' Supported object's classes are (so far): \code{lm, data.frame, ggplot}.
#' 
#' For more detailed information check package vignette - url needed.
#' 
#' 
#' @param object An arbitrary R object to be saved. For supported objects see details.
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


