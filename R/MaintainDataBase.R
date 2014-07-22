createEmptyRepository <- function( dir ){
  stopifnot( is.character( dir ) )
  
  # check if dir has "/" at the end and add it if not
  if ( regexpr( pattern = ".$", text = dir ) != "/" ){
    dir <- paste0( c ( dir, "/" ) )
  }
  
  # create connection
  sqlite    <- dbDriver("SQLite")
  backpack <- dbConnect(sqlite,paste0(dir, "backpack.db"))
  
  # creat tables
  artifact <- data.frame(md5hash = "",
                         createdDate = as.character(now()), 
                         stringsAsFactors=FALSE)
  
  relation <- data.frame(artifactFrom = "", 
                         artifactTo = "", 
                         relationName = "", 
                         stringsAsFactors=FALSE)
  
  tag <- data.frame(artifact = "", 
                    tag = "", 
                    timestamp = as.character(now()), 
                    stringsAsFactors=FALSE)
  
  # insert tables into database
  dbWriteTable(backpack, "artifact",artifact, overwrite=TRUE)
  dbWriteTable(backpack, "relation",relation, overwrite=TRUE)
  dbWriteTable(backpack, "tag",tag, overwrite=TRUE)

  
  # ? is it necessary
  # dbGetQuery(backpack, "select * from setting")
  # dbGetQuery(backpack, "select * from artifact")
  # dbGetQuery(backpack, "select * from tag")
  # dbGetQuery(backpack, "select * from relation")
  
  # dbGetQuery(backpack, "delete from artifact")
  # dbGetQuery(backpack, "delete from tag")
  # dbGetQuery(backpack, "delete from relation")
  
  dbDisconnect(backpack)
}

addArtifact <- function( object, md5hash ){
  
}

addTags <- function( md5hash, tag, timestamp = now() ){
  
}

addRelation <- function( artifactFrom, artifactTo, relationName ){
  
}


