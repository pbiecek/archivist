##    archivist package for R
##
#' @title Save an Object into a Repository 
#'
#' @description
#' \code{saveToRepo} function saves desired objects to the local \link{Repository} on a given directory.
#' 
#' 
#' @details
#' \code{saveToRepo} function saves desired objects to the local Repository on a given directory.
#' Objects are saved in the local Repository, which is a SQLite database named \code{backpack}. 
#' After every \code{saveToRepo} call the database is refreshed, so object is available immediately.
#' Every object is saved in a \code{md5hash.rda} file, located in the folder (created in given directory) named 
#' \code{gallery}. \code{md5hash} is a hash generated from object, which is wanted to be saved and is different 
#' for various objects. This \code{md5hash} is a string of length 32 that comes out as a result of 
#' \code{digest{digest}} function, which uses a cryptographical MD5 hash algorithm.
#' 
#' By default, a miniature of an object and (if possible) a data set needed to compute this object are extracted. #' They are also going to be saved in a file named by their \code{md5hash} and a specific
#' \code{Tag}-relation is going to be added to the \code{backpack} dataset in case there is an urge to load an
#' object with it's related data set - see \link{loadFromLocalRepo} or \link{loadFromGithubRepo}. Default settings
#' may be changed by using arguments \code{archiveData}, \code{archiveTag} or \code{archiveMiniature} with 
#' \code{FALSE} value.
#' 
#' \code{Tags} are specific values of an object, different for various object's classes. For more detailed 
#' information check \link{Tags}
#' 
#' Archivised object can be searched in \code{backpack} dataset using functions 
#' \link{searchInLocalRepo} or \link{searchInGithubRepo}. Objects can be searched by their \link{Tags}, 
#' \code{names} or objects classes.
#' 
#' Supported object's classes are (so far): \code{lm, data.frame, ggplot}.
#' TODO: EXTEND
#' 
#' @return
#' As a result of this function a character string is returned as a value and determines
#' the \code{md5hash} of an object that was used in a \code{saveToRepo} function.
#' 
#' @seealso
#' For more detailed information check package vignette - url needed.
#' 
#' 
#' @param object An arbitrary R object to be saved. For supported objects see details.
#' 
#' @param ... Graphical parameters denoting width and height of a miniature. See details.
#' 
#' @param archiveData A logical value denoting whether to archive the data from object.
#' 
#' @param archiveTags A logical value denoting whether to archive tags from object.
#' 
#' @param archiveMiniature A logical value denoting whether to archive a miniature of an object.
#' 
#' @param dir A character denoting an existing directory in which an object will be saved.
#' 
#' @author 
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' # objects preparation
#' data(iris)
#' library(ggplot2)
#' df <- data.frame(gp = factor(rep(letters[1:3], each = 10)),y = rnorm(30))
#' library(plyr)
#' ds <- ddply(df, .(gp), summarise, mean = mean(y), sd = sd(y))
#' myplot123 <- ggplot(df, aes(x = gp, y = y)) +
#'   geom_point() +  geom_point(data = ds, aes(y = mean),
#'                colour = 'red', size = 3)
#' model.lm <- lm(Sepal.Length~ Sepal.Width + Petal.Length + Petal.Width, data= iris)
#' 
#' # examples
#' saveToRepo(myplot123, dir="REPODIR")
#' saveToRepo(iris, dir="REPODIR")
#' saveToRepo(model.lm, dir="REPODIR")
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

