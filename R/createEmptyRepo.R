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
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
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
#' @param force If \code{force = TRUE} and \code{repoDir} parameter specifies the directory that doesn't exist,
#' then function call will force to create new \code{repoDir} directory.
#' Default set to \code{force = TRUE}.
#' 
#' @param default If \code{default = TRUE} then \code{repoDir} is set as default Local Repository. 
#' 
#' @param ... All arguments are being passed to \code{createLocalRepo}.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
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
#' }
#' @family archivist
#' @rdname createEmptyRepo
#' @export
createLocalRepo <- function( repoDir, force = TRUE, default = FALSE ){
  stopifnot( is.character( repoDir ), length( repoDir ) == 1 )
  stopifnot( is.logical( default ), length( default ) == 1 )
  
  if ( !file.exists( repoDir ) & !force ) 
    stop( paste0("Directory ", repoDir, " does not exist. Try with force=TRUE.") )
  if ( !file.exists( repoDir ) & force ){
    cat( paste0("Directory ", repoDir, " did not exist. Forced to create a new directory.") )
    repoDir <- checkDirectory( repoDir, create = TRUE )
    dir.create( repoDir )
  }
  
  repoDir <- checkDirectory( repoDir, create = TRUE )
  
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
  
  
  dbGetQuery(backpack, "delete from artifact")
  dbGetQuery(backpack, "delete from tag")
  
  dbDisconnect( backpack )
  
  # if gallery folder does not exist - make it
  if ( !file.exists( file.path( repoDir, "gallery" ) ) ){
    dir.create( file.path( repoDir, "gallery" ), showWarnings = FALSE)
  }
  
  if (default) {
    setLocalRepo(repoDir)
  }
   
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
  executeSingleQuery( dir,
              paste0( "insert into artifact (md5hash, name, createdDate) values",
                      "('", md5hash, "', '", name, "', '", as.character( now() ), "')" ) )
}

addTag <- function( tag, md5hash, createdDate = now(), dir ){
 executeSingleQuery( dir,
              paste0("insert into tag (artifact, tag, createdDate) values ",
                     "('", md5hash, "', '", gsub(tag, pattern="'", replacement=""), "', '", as.character( now() ), "')" ) )
}

# realDBname was needed because Github version function uses temporary file as database
# and they do not name this file as backpack.db in repoDir directory
getConnectionToDB <- function( repoDir ){
  dbConnect( get( "sqlite", envir = .ArchivistEnv ), file.path( repoDir, "backpack.db" ) )
}
  
executeSingleQuery <- function( dir, query ) {
  conn <- getConnectionToDB( dir )
  on.exit( dbDisconnect( conn ) )
  res <- dbGetQuery( conn, query )
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
  if (url.exists(URLdb)){
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

checkDirectory <- function( directory, create = FALSE ){
  # check if global repository was specified by setLocalRepo
  if ( is.null(directory) ){

    directory <- aoptions("repoDir")
  }
  # check property of directory
  if ( !create ){
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
