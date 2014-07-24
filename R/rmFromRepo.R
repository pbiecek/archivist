##    archivist package for R
##
#' @title Remove an Object from a Repository
#'
#' @description
#' \code{rmFromRepo} removes an object given as \code{md5hash} from a Repository.  
#' 
#' @details
#' \code{rmFromRepo} removes an object given as \code{md5hash} from a Repository, 
#' which is a SQLite database named \code{backpack} - created by a \link{createEmptyRepo} call.
#' \code{md5hash} is a string of length 32 that comes out as a result from \link{saveToRepo} function, 
#' which uses a cryptographical hash function with MD5 algorithm.
#' 
#' Also this function removes a \code{md5hash.rda} file, where \code{md5hash} is object's hash as above.
#' 
#' Important: instead of giving whole \code{md5hash} name, user can simply give first few signs of desired \code{md5hash} - an abbreviation.
#' For example \code{a09dd} instead of \code{a09ddjdkf9kj33dcjdnfjgos9jd9jkcv}. But if several tags start with the same pattern 
#' an error will be displayed and you will be asked to give more precise \code{md5hash} abbreviation (try abbreviation with more digits all with whole name).
#' TODO: what is the value of rmFromRepo() function? TRUE/FALSE if anything is removed?
#' 
#' @note
#' \code{md5hash} can be a result from \link{searchInRepo} function proceeded with \code{tag = NAME} argument,
#' where \code{NAME} is tag that describes property of objects to be deleted. 
#' 
#' For more information about \code{Tags} check \link{Tags}.
#' 
#' @param md5hash A hash of an object. A character string being a result of a cryptographical hash function with MD5 algorithm.
#' 
#' @param dir A character denoting an existing directory from which an object will be removed.
#' 
#' @author
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' # not work
#' rmFromRepo( md5hash = "sksjdncjdkslwifgdtsjhdt37wyshzdh",
#'                        dir = "REPODIR" )
#'                        
#' # with md5hash abbreviation
#' rmFromRepo( md5hash = "sksjd",
#'                        dir = "REPODIR" )
#'                        
#'  hash <-  searchInLocalRepo( "name:prettyPlot", 
#'                        dir = "/home/folder/here" )                      
#'  rmFromRepo( hash, dir = "/home/folder/here" )     
#' 
#' @family archivist
#' @rdname rmFromRepo
#' @export
rmFromRepo <- function( md5hash, dir ){
  stopifnot( is.character( c( dir, md5hash ) ) )
  
}
