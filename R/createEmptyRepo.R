##    archivist package for R
##
#' @title Create an Empty Repository
#'
#' @description
#' \code{createLocalRepo} creates an empty \link{Repository} in the given directory in which archived artifacts will be stored.
#' 
#' @details
#' At least one Repository must be initialized before using other functions from the \pkg{archivist} package. 
#' While working in groups, it is highly recommended to create a Repository on a shared Dropbox/GitHub folder.
#' 
#' All artifacts which are desired to be archived are going to be saved in the local Repository, which is an SQLite 
#' database stored in a file named \code{backpack}. 
#' After calling \code{saveToRepo} function, each artifact will be archived in a \code{md5hash.rda} file. 
#' This file will be saved in a folder (under \code{repoDir} directory) named 
#' \code{gallery}. For every artifact, \code{md5hash} is a unique string of length 32 that is produced by
#' \link[digest]{digest} function, which uses a cryptographical MD5 hash algorithm.
#' 
#' To learn more about artifacts visit \link[archivist]{archivistPackage}.
#' 
#' Created \code{backpack} database is a useful and fundamental tool for remembering artifact's 
#' \code{name}, \code{class}, \code{archiving date} etc. (the so called \link{Tags})
#' or for keeping artifact's \code{md5hash}.
#' 
#' Besides the \code{backpack} database, \code{gallery} folder is created in which all 
#' artifacts will be archived.
#' 
#' After every \code{saveToRepo} call the database is refreshed. As a result, the artifact is available 
#' immediately in \code{backpack.db} database for other collaborators.
#' 
#' 
#' @param repoDir A character that specifies the directory for the Repository which is to be made. 
#'  
#' @param force If \code{force = TRUE} and \code{repoDir} parameter specifies the directory that contains backpack.db file,
#' then function call will force to recreate new \code{backpack.db}
#' Default set to \code{force = FALSE}.
#' 
#' @param default If \code{default = TRUE} then \code{repoDir} is set as default Local Repository. 
#' 
#' @param connector If user want to use some external database instead of SQLite, then the \code{connector} shall be the function that create a \code{DBI} connection with the database.
#' Within every transaction the connection is opened and closed, thus the \code{connector} function will be executed often and shall not be computationally heavy.
#' See the Examples section for some examples.
#' Note that it's an experimental feature.
#' 
#' @param ... All arguments are being passed to \code{createLocalRepo}.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#'
#' @template roxlate-references
#' @template roxlate-contact
#'
#' @examples
#' \dontrun{
#' exampleRepoDir <- tempfile()
#' createLocalRepo( repoDir = exampleRepoDir, default =  TRUE )
#' data(iris)
#' saveToLocalRepo(iris)
#' showLocalRepo()
#' showLocalRepo(method = "tags")
#' deleteLocalRepo( repoDir = exampleRepoDir, unset = TRUE, deleteRoot = TRUE)
#' 
#' # example with external database
#' # create a connector
#' require("RPostgreSQL")
#' drv <- dbDriver("PostgreSQL")
#' connector <- function() {
#'   dbConnect(drv, dbname = "postgres",
#'             host = "localhost", port = 5432,
#'             user = "user", password = pw)
#' }
#' # Now you can create an empty repository with postgress database
#' exampleRepoDir <- tempfile()
#' createPostgresRepo( repoDir = exampleRepoDir, connector)
#' data(iris)
#' saveToLocalRepo(iris)
#' showLocalRepo()
#' showLocalRepo(method = "tags")
#' deleteLocalRepo( repoDir = exampleRepoDir, unset = TRUE, deleteRoot = TRUE)
#' 
#' }
#' @family archivist
#' @rdname createEmptyRepo
#' @export
createLocalRepo <- function( repoDir, force = FALSE, default = FALSE ){
  stopifnot( is.character( repoDir ), length( repoDir ) == 1 )
  stopifnot( is.logical( default ), length( default ) == 1 )
  
  if ( file.exists( repoDir ) & file.exists( paste0(repoDir,"/backpack.db") ) & !force ){
    message( paste0("Directory ", repoDir, " does exist and contain the backpack.db file. Use force=TRUE to reinitialize.") )
    return(invisible( repoDir ))  
  } 
  if ( file.exists( repoDir ) & file.exists( paste0(repoDir,"/backpack.db") ) & force ){
    message( paste0("Directory ", repoDir, " does exist and contain the backpack.db file. Reinitialized due to force=TRUE.") )
  }
  if ( !file.exists( repoDir ) ){
    dir.create( repoDir )
  }
  
  # create connection
  backpack <- getConnectionToDB( repoDir )
  
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
  
  
  dbExecute(backpack, "delete from artifact")
  dbExecute(backpack, "delete from tag")
  
  dbDisconnect( backpack )
  
  # if gallery folder does not exist - make it
  if ( !file.exists( file.path( repoDir, "gallery" ) ) ){
    dir.create( file.path( repoDir, "gallery" ), showWarnings = FALSE)
  }
  
  if (default) {
    setLocalRepo(repoDir)
  }
  return(invisible( repoDir ))
}

#' @family archivist
#' @rdname createEmptyRepo
#' @export
createPostgresRepo <- function( repoDir, connector, force = FALSE, default = FALSE ){
  stopifnot( is.character( repoDir ), length( repoDir ) == 1 )
  stopifnot( is.logical( default ), length( default ) == 1 )
  stopifnot( is.function( connector ))

  if ( file.exists( repoDir ) & file.exists( paste0(repoDir,"/backpack.db") ) & !force ){
    message( paste0("Directory ", repoDir, " does exist and contain the backpack.db file. Use force=TRUE to reinitialize.") )
    return(invisible( repoDir ))  
  } 
  if ( file.exists( repoDir ) & file.exists( paste0(repoDir,"/backpack.db") ) & force ){
    message( paste0("Directory ", repoDir, " does exist and contain the backpack.db file. Reinitialized due to force=TRUE.") )
  }
  if ( !file.exists( repoDir ) ){
    dir.create( repoDir )
  }

  .ArchivistEnv$useExternalDatabase <- TRUE
  .ArchivistEnv$externalConnector <- connector
  
  createLocalRepo( repoDir, force = force, default = default )
}

#' @family archivist
#' @rdname createEmptyRepo
#' @export
createEmptyRepo <- function(...) {
  .Deprecated("createEmptyRepo is deprecated. Use createLocalRepo() instead.")
  createLocalRepo(...)
}

addArtifact <- function( md5hash, name, dir ){
  # creates connection and driver
  # send insert
  executeSingleSilentQuery( dir,
              paste0( "insert into artifact (md5hash, name, createdDate) values",
                      "('", md5hash, "', '", name, "', '", as.character( now() ), "')" ) )
}

addTag <- function( tag, md5hash, createdDate = now(), dir ){
  executeSingleSilentQuery( dir,
                            paste0("insert into tag (artifact, tag, createdDate) values ",
                                   "('", md5hash, "', '", gsub(tag, pattern="'", replacement=""), "', '", as.character( now() ), "')" ) )
}

# realDBname was needed because Github version function uses temporary file as database
# and they do not name this file as backpack.db in repoDir directory
getConnectionToDB <- function( repoDir ){
  useExternal <- get( "useExternalDatabase", envir = .ArchivistEnv )
  if (!is.null(useExternal) & useExternal) {
    externalConnector <- get( "externalConnector", envir = .ArchivistEnv )
    externalConnector()
  } else {
    dbConnect( get( "sqlite", envir = .ArchivistEnv ), file.path( repoDir, "backpack.db" ) )
  }
}
  
executeSingleQuery <- function( dir, query ) {
  conn <- getConnectionToDB( dir )
  on.exit( dbDisconnect( conn ) )
  res <- dbGetQuery( conn, query )
  return( res )
}

executeSingleSilentQuery <- function( dir, query ) {
  conn <- getConnectionToDB( dir )
  on.exit( dbDisconnect( conn ) )
  res <- dbExecute( conn, query )
  return( res )
}

readSingleTable <- function( dir, table ){
  conn <- getConnectionToDB( dir )
  tabs <- dbReadTable( conn, table )
  dbDisconnect( conn )
  return( tabs )
}

# for Github version function that requires to load database
downloadDB <- function( remoteHook ){
  URLdb <- file.path( remoteHook, "backpack.db") 
  if (!url.dont.exists(URLdb)){
    db <- getBinaryURL( URLdb )
    Temp2 <- tempfile()
    dir.create( Temp2 )
    Temp3 <- paste0(Temp2, "/backpack.db")
    file.create( Temp3 )
    writeBin( db, Temp3 )
    dir.create( paste0(Temp2, "/gallery") )
    return( Temp2 )
  } else {
    stop(paste0("Such a repo: ", remoteHook, " does not exist",
                " or there is no archivist-like Repository on this repo."))
  }
  
}

# in some cases the RCurl::url.exists was not working
url.dont.exists <- function(url) {
  suppressWarnings(class(try(readLines(url, n=1, warn = FALSE), silent = TRUE)) == "try-error")
}

# if starts with http:// or https://
is.url <- function(url) {
  grepl(pattern = "http.?://", url)
}

checkDirectory <- function( directory ){
  # check if global repository was specified by setLocalRepo
  if ( is.null(directory) ) {
    directory <- aoptions("repoDir")
  }
  # check property of directory
  # check if it's URL or local directory
  if (is.url(directory)) { # it's URL, usefull for shiny applications
      # check whether repository exists
      if ( url.dont.exists( directory ) ){
        stop( paste0( "There is no such repository as ", directory ) )
      }
      # check if repository is proper (has backpack.db and gallery)
      if ( url.dont.exists(paste0(directory, "/", "backpack.db")) ){
        stop( paste0( directory, " is not a proper repository. There is no backpack.db file" ) )
      }
    } else { # it should be a folder
      # check whether repository exists
      if ( !dir.exists( directory ) ){
        stop( paste0( "There is no such repository as ", directory ) )
      }
      # check if repository is proper (has backpack.db and gallery)
      if ( !all( c("backpack.db", "gallery") %in% list.files(directory) ) ){
        stop( paste0( directory, " is not a proper repository. There is neither backpack.db nor gallery." ) )
      }
    }
  return( directory )
}
