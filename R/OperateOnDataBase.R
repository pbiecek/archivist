saveToRepo <- function( object, ..., archiveData = TRUE, 
                                     archiveTags = TRUE, 
                                     archiveMiniature = TRUE, dir ){
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
  
  # whether to archive miniature
  if ( archiveMiniature )
    extractMiniature( object )
  
  # paste hash / return hash ?  cat( paste0( "message", md5hash ) )
}

loadFromLocalRepo <- function( md5hash, dir ){
  stopifnot( is.character( c( dir, md5hash ) ) )
  
}

loadFromGithubRepo <- function( md5hash, repo, user ){
  stopifnot( is.character( c( md5hash, repo, user ) ) )
  
}

rmFromRepo <- function( md5hash, dir ){
  stopifnot( is.character( c( dir, md5hash ) ) )
  
}

searchInLocalRepo <- function( tag, dir ){
  stopifnot( is.character( c( tag, dir ) ) )
  
}

searchInGithubRepo <- function( tag, repo, user ){
  stopifnot( is.character( c( tag, repo, user ) ) )
  
}


