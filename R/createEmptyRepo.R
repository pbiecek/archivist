##    archivist package for R
##
#' @title Create an Empty Repository in a Given Directory
#'
#' @description
#' \code{createEmptyRepo} creates an empty \link{Repository} in a given directory in which archived objects will be stored.
#' 
#' 
#' @details
#' At least one Repository must be initialized before using other functions from the \pkg{archivist} package. 
#' When working in groups, it is highly recommended to create a Repository on a shared Dropbox/Git folder.
#' 
#' All objects desired to be archived are going to be saved in the local Repository, which is an SQLite database stored in a file named \code{backpack}. 
#' After calling \code{saveToRepo} function, every object will be archived in a \code{md5hash.rda} file. This file will be saved in a folder (under \code{repoDir} directory) named 
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
#' @param repoDir A character that specifies the directory for the Repository to be made.
#' 
#' @param force If \code{force = TRUE} function call forces to create \code{repoDir} directory if
#' it did not exist. Default set to \code{force = FALSE}.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( repoDir = exampleRepoDir )
#'
#' # check the state of an empty Repository
#' 
#' summaryLocalRepo( method = "md5hashes", repoDir = exampleRepoDir )
#' summaryLocalRepo( method = "tags", repoDir = exampleRepoDir )
#' 
#' # removing all files generated to this function's examples
#' file.remove( paste0( exampleRepoDir, "/backpack.db" ) )
#' 
#' rm( exampleRepoDir )
#' }
#' @family archivist
#' @rdname createEmptyRepo
#' @export
createEmptyRepo <- function( repoDir, force = FALSE ){
  stopifnot( is.character( repoDir ) )
  
  if ( !file.exists( repoDir ) & !force ) 
    stop( paste0("Directory ", repoDir, " does not exist. Try with force=TRUE.") )
  if ( !file.exists( repoDir ) & force ){
    cat( paste0("Directory ", repoDir, " did not exist. Forced to create a new directory.") )
    repoDir <- checkDirectory( repoDir )
    dir.create( repoDir )
  }
  
  repoDir <- checkDirectory( repoDir )
  
  # create connection
  backpack <- getConnectionToDB( repoDir, realDBname = TRUE )
  
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
  dbWriteTable( backpack, "artifact", artifact, overwrite = TRUE, row.names = FALSE )
  dbWriteTable( backpack, "tag", tag, overwrite = TRUE, row.names = FALSE )
  
  
  dbGetQuery(backpack, "delete from artifact")
  dbGetQuery(backpack, "delete from tag")
  
  dbDisconnect( backpack )
  
  # if gallery folder does not exist - make it
  if ( !file.exists( file.path( repoDir, "gallery" ) ) ){
    dir.create( file.path( repoDir, "gallery" ), showWarnings = FALSE)
  }
}

addArtifact <- function( md5hash, name, dir ){
  # creates connection and driver
  # send insert
  executeSingleQuery( dir,
              paste0( "insert into artifact (md5hash, name, createdDate) values",
                      "('", md5hash, "', '", name, "', '", as.character( now() ), "')" ) )
}

addTag <- function( tag, md5hash, createdDate = now(), dir ){
 executeSingleQuery( dir,
              paste0("insert into tag (artifact, tag, createdDate) values ",
                     "('", md5hash, "', '", tag, "', '", as.character( now() ), "')" ) )
}

# realDBname was needed because Github version function uses temporary file as database
# and they do not name this file as backpack.db in repoDir directory
getConnectionToDB <- function( repoDir, realDBname ){
    if ( realDBname ){
      conn <- dbConnect( get( "sqlite", envir = .ArchivistEnv ), paste0( repoDir, "backpack.db" ) )
    }else{
      conn <- dbConnect( get( "sqlite", envir = .ArchivistEnv ), repoDir )
    }
    return( conn )
}
  
executeSingleQuery <- function( dir, query, realDBname = TRUE ) {
  conn <- getConnectionToDB( dir, realDBname )
  res <- dbGetQuery( conn, query )
  dbDisconnect( conn )
  return( res )
}

readSingleTable <- function( dir, table, realDBname = TRUE ){
  conn <- getConnectionToDB( dir, realDBname )
  tabs <- dbReadTable( conn, table )
  dbDisconnect( conn )
  return( tabs )
}

# for Github version funtion tha require to load database
downloadDB <- function( repo, user, branch ){
   URLdb <- paste0( get( ".GithubURL", envir = .ArchivistEnv) , user, "/", repo, "/", branch, "/backpack.db") 
   library( RCurl )
   db <- getBinaryURL( URLdb, ssl.verifypeer = FALSE )
   Temp2 <- tempfile()
   writeBin( db, Temp2)
   return( Temp2 )
}

checkDirectory <- function( directory ){
  # check if repoDir has "/" at the end and add it if not
  if ( regexpr( pattern = ".$", text = directory ) != "/" ){
    directory <- paste0(  directory, "/"  )
  }
  return( directory )
}
