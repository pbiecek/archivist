##    archivist package for R
##
#' @title Create an Empty Repository in Given Directory
#'
#' @description
#' \code{createEmptyRepo} creates an empty \link{Repository} for given directory in which archivised objects will be stored.
#' 
#' 
#' @details
#' At least one repository must be initialized prior to use other functions from archivist package. 
#' If working in groups, it is highly recommend to create repository on shared Dropbox/Git folder.
#' 
#' All objects desired to be archivised are going to be saved in the local Repository, which is a SQLite database stored in a file named \code{backpack}. 
#' Every object is saved (after calling \code{saveToRepo} function) in a \code{md5hash.rda} file, located in the folder (created in given directory) named 
#' \code{gallery}. \code{md5hash} is a hash generated from object, which is wanted to be saved and is different 
#' for various objects. This \code{md5hash} is a string of length 32 that comes out as a result of 
#' \code{digest{digest}} function, which uses a cryptographical MD5 hash algorithm.
#' 
#' Created \code{backpack} database is a useful and fundamental tool for remembering object's 
#' \code{name}, \code{class}, \code{archivisation date} etc (that are remembered as \link{Tags}) 
#' or for keeping object's \code{md5hash}.
#' 
#' After every \code{saveToRepo} call the database is refreshed, so object is available immediately.
#' 
#' @param dir A character that specifies the directory for repository to be made.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' createEmptyRepo(getwd())
#' createEmptyRept(path.package("stats"))
#' # not work
#' createEmptyRepo("user/folder/here")
#' @family archivist
#' @rdname createEmptyRepo
#' @export
createEmptyRepo <- function( dir ){
  stopifnot( is.character( dir ) )
  
  # check if dir has "/" at the end and add it if not
  if ( regexpr( pattern = ".$", text = dir ) != "/" ){
    dir <- paste0(  dir, "/"  )
  }
  
  # create connection
  sqlite    <- dbDriver( "SQLite" )
  backpack <- dbConnect( sqlite, paste0( dir, "backpack.db" ) )
  
  # create tables
  artifact <- data.frame(md5hash = "",
                         createdDate = as.character( now() ), 
                         stringsAsFactors = FALSE ) 
  
  tag <- data.frame(artifact = "", 
                    tag = "", 
                    createdDate = as.character( now() ), 
                    stringsAsFactors = FALSE )
  
  # insert tables into database
  dbWriteTable( backpack, "artifact",artifact, overwrite=TRUE )
  dbWriteTable( backpack, "tag",tag, overwrite=TRUE )
  
  
   dbGetQuery(backpack, "delete from artifact")
   dbGetQuery(backpack, "delete from tag")
  
  dbDisconnect( backpack )
  dbUnloadDriver( sqlite )
}

addArtifact <- function( md5hash, dir ){
  # creates connection and driver
  sqlite <- dbDriver( "SQLite" )
  conn <- dbConnect( sqlite, paste0( dir, "/backpack.db" ) )
  
  # send insert
  dbGetQuery( conn,
              paste0( "insert into artifact (md5hash, createdDate) values",
                      "('", md5hash, "', '", as.character( now() ), "')" ) )
  # deletes connection and driver
  dbDisconnect( conn )
  dbUnloadDriver( sqlite )  
}

addTag <- function( tag, md5hash, createdDate = now(), dir ){
  # creates connection and driver
  sqlite <- dbDriver( "SQLite" )
  conn <- dbConnect( sqlite, paste0( dir, "/backpack.db" ) )
  
  # send insert
  dbGetQuery( conn,
              paste0("insert into tag (artifact, tag, createdDate) values ",
                      "('", md5hash, "', '", tag, "', '", as.character( now() ), "')" ) )
  
  # deletes connection and driver
  dbDisconnect( conn )
  dbUnloadDriver( sqlite ) 
  
}
