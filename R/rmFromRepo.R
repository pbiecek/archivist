##    archivist package for R
##
#' @title Remove an Object from a Repository
#'
#' @description
#' \code{rmFromRepo} removes an object from a Repository given as \code{md5hash} - a string of 
#' length 32 that comes out as a result from \link{saveToRepo} function, which uses a cryptographical hash function with MD5 algorithm
#' 
#' 
#' @details
#' \code{rmFromRepo} removes an object from a Repository given as \code{md5hash} - a string of 
#' length 32 that comes out as a result from \link{saveToRepo} function, which uses a cryptographical hash function with MD5 algorithm
#' 
#' @param md5hash A hash of an object. A character string being a result of a cryptographical hash function with MD5 algorithm.
#' 
#' @param dir A character denoting an existing directory from which an object will be removed.
#' 
#' @author autor
#'
#' @examples
#' #example
#' @family archivist
#' @rdname rmFromRepo
#' @export
rmFromRepo <- function( md5hash, dir ){
  stopifnot( is.character( c( dir, md5hash ) ) )
  
}
