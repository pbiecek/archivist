##    archivist package for R
##
#' @title Create an Empty Repository in a Given Directory
#'
#' @description
#' \code{createEmptyRepo} creates an empty \link{Repository} in a given directory in which archived objects will be stored.
#' 
#' 
#' @details
#' At least one Repository must be initialized before using other functions from the \pck{archivist} package. 
#' When working in groups, it is highly recommended to create a Repository on a shared Dropbox/Git folder.
#' 
#' All objects desired to be archived are going to be saved in the local Repository, which is an SQLite database stored in a file named \code{backpack}. 
#' After calling \code{saveToRepo} function, every object will be archived in a \code{md5hash.rda} file. This file will be saved in a folder (under \code{dir} directory) named 
#' \code{gallery}. For every object, \code{md5hash} is a unique string of length 32 that comes out as a result of 
#' \code{digest{digest}} function, which uses a cryptographical MD5 hash algorithm.
#' 
#' Created \code{backpack} database is a useful and fundamental tool for remembering object's 
#' \code{name}, \code{class}, \code{archiving date} etc. (that are remembered as \link{Tags}),
#' or for keeping object's \code{md5hash}.
#' 
#' Besides the \code{backpack} database, \code{gallery} folder is created in which all 
#' objects will be archived.
#' 
#' After every \code{saveToRepo} call the database is refreshed, so an object is available 
#' immediately in \code{backpack.db} database for other collaborators.
#' 
#' @param dir A character that specifies the directory for the Repository to be made.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' exampleDir <- tempdir()
#' createEmptyRepo( dir = exampleDir )
#'
#' # check the state of an empty Repository
#' 
#' summaryLocalRepo( method = "md5hashes", dir = exampleDir )
#' summaryLocalRepo( method = "tags", dir = exampleDir )
#' 
#' # removing all files generated to this function's examples
#' file.remove( paste0( exampleDir, "/backpack.db" ) )
#' 
#' rm( exampleDir )
#' 
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
                         name = "",
                         createdDate = as.character( now() ), 
                         stringsAsFactors = FALSE ) 
  
  tag <- data.frame(artifact = "", 
                    tag = "", 
                    createdDate = as.character( now() ), 
                    stringsAsFactors = FALSE )
  
  # insert tables into database
  dbWriteTable( backpack, "artifact",artifact, overwrite = TRUE, row.names = FALSE )
  dbWriteTable( backpack, "tag",tag, overwrite = TRUE, row.names = FALSE )
  
  
  dbGetQuery(backpack, "delete from artifact")
  dbGetQuery(backpack, "delete from tag")
  
  dbDisconnect( backpack )
  dbUnloadDriver( sqlite )
  
  
  # if gallery folder does not exist - make it
  if ( !file.exists( file.path(dir, "gallery") ) ){
    dir.create(file.path(dir, "gallery"), showWarnings = FALSE)
  }
}

addArtifact <- function( md5hash, name, dir ){
  # creates connection and driver
  sqlite <- dbDriver( "SQLite" )
  conn <- dbConnect( sqlite, paste0( dir, "/backpack.db" ) )
  
  # send insert
  dbGetQuery( conn,
              paste0( "insert into artifact (md5hash, name, createdDate) values",
                      "('", md5hash, "', '", name, "', '", as.character( now() ), "')" ) )
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
