##    archivist package for R
##
#' @title Remove an Object Given as md5hash from a Repository
#'
#' @description
#' \code{rmFromRepo} removes an object given as \code{md5hash} from a \link{Repository}.
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
#' # TODO: if one wants to remove files from date to date, it is suggested to
#' # first perform obj2rm <- searchIn...Repo( tag = list(FromDate, ToDate), dir = )
#' # sapply(obj2rm, rmFromRepo, dir = )
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
#' # removing objects from specified date
#' hashes <- searchInLocalRepo( tag = list( dataFrom = "2005-05-27", dataTo = "2005-07-07"), 
#' dir = demoDir)
#' sapply(hashes, rmFromRepo)
#' 
#' 
#' @family archivist
#' @rdname rmFromRepo
#' @export
rmFromRepo <- function( md5hash, dir ){
  stopifnot( is.character( c( dir, md5hash ) ) )
  
  # check if dir has "/" at the end and add it if not
  if ( regexpr( pattern = ".$", text = dir ) != "/" ){
    dir <- paste0(  dir, "/"  )
  }
  
  
  # creates connection and driver
  sqlite <- dbDriver( "SQLite" )
  conn <- dbConnect( sqlite, paste0( dir, "backpack.db" ) )
  
  # send deletes
  dbGetQuery( conn,
              paste0( "DELETE FROM artifact WHERE ",
                      "md5hash = '", md5hash, "'" ) )
  dbGetQuery( conn,
              paste0( "DELETE FROM tag WHERE ",
                      "artifact = '", md5hash, "'" ) )
  # VECTORIZED VERSION
  # send deletes
#   sapply(md5hash, function(x){
#     dbGetQuery( conn,
#               paste0( "DELETE FROM artifact WHERE ",
#                       "md5hash = '", x, "'" ) )} )
#   sapply(md5hash, function(x){
#     dbGetQuery( conn,
#               paste0( "DELETE FROM tag WHERE ",
#                       "artifact = '", x, "'" ) )} )
#   
  # deletes connection and driver
  dbDisconnect( conn )
  dbUnloadDriver( sqlite ) 

# remove files from gallery folder
if ( file.exists( paste0( dir, "gallery/", md5hash, ".rda" ) ) )
  file.remove( paste0( dir, "gallery/", md5hash, ".rda" ) )

if ( file.exists( paste0( dir, "gallery/", md5hash, ".png" ) ) )
  file.remove( paste0( dir, "gallery/", md5hash, ".png" ) )

if ( file.exists( paste0( dir, "gallery/", md5hash, ".txt" ) ) )
  file.remove( paste0( dir, "gallery/", md5hash, ".txt" ) )
  
}
