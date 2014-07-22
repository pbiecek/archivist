saveToRepository <- function( object, ..., archiveData = TRUE, 
                                           archiveTags = TRUE, dir ){
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
  
  
  
  # paste hash / return hash ?  cat( paste0( "message", md5hash ) )
}

loadFromLocalRepository <- function( md5hash, dir ){
  stopifnot( is.character( c( dir, md5hash ) ) )
  
}

loadFromGithubRepository <- function( md5hash, repo, user ){
  stopifnot( is.character( c( md5hash, repo, user ) ) )
  
}

rmFromRepository <- function( md5hash, dir ){
  stopifnot( is.character( c( dir, md5hash ) ) )
  
}

searchInLocalRepository( tag, dir ){
  stopifnot( is.character( c( tag, dir ) ) )
  
}

searchInGithubRepository( tag, repo, user ){
  stopifnot( is.character( c( tag, repo, user ) ) )
  
}


