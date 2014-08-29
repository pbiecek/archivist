
extractMiniature <- function( object, md5hash, parentDir, ... )
  UseMethod( "extractMiniature" )

extractMiniature.default <- function( object, md5hash, parentDir, ... ){
  
}

extractMiniature.data.frame <- function( object, md5hash, parentDir, ..., firstRows = 6 ){
  sink( file = paste0( parentDir, "gallery/", md5hash, ".txt" ) )
  print( head( object, firstRows ) )
  sink()
}

extractMiniature.ggplot <- function( object, md5hash, parentDir, ..., width = 800, height = 600 ){
  png( paste0( parentDir, "gallery/", md5hash, ".png" ), width, height )
  plot( object )
  dev.off()
}

extractMiniature.lm <- function( object, md5hash, parentDir, ... ){
  sink( file = paste0(parentDir, "gallery/", md5hash, ".txt" ) )
  print( summary( object ) )
  sink()
}

extractMiniature.htest <- function( object, md5hash, parentDir, ... ){
  sink( file = paste0(parentDir, "gallery/", md5hash, ".txt" ) )
  print( object )
  sink()
}

extractMiniature.trellis <- function( object, md5hash, parentDir, ..., width = 800, height = 600 ){
  png( paste0( parentDir, "gallery/", md5hash, ".png" ), width, height )
  print( object )
  dev.off()
}

extractMiniature.twins <- function( object, md5hash, parentDir, ..., width = 800, height = 600 ){
  png( paste0( parentDir, "gallery/", md5hash, ".png" ), width, height )
  par( mfrow = c( 1, 2 ) )
  plot( object )
  dev.off()
  par( mfrow = c( 1, 1 ) )
}

extractMiniature.partition <- function( object, md5hash, parentDir, ...,width = 800, height = 600 ){ 
  png( paste0( parentDir, "gallery/", md5hash, ".png" ), width, height )
  par( mfrow = c( 1, 2 ) )
  plot( object )
  dev.off()
  par( mfrow = c( 1, 1 ) )
}

extractMiniature.lda <- function( object, md5hash, parentDir, ... ){
  sink( file = paste0(parentDir, "gallery/", md5hash, ".txt" ) )
  print( object ) 
  sink()
}

extractMiniature.qda <- function( object, md5hash, parentDir, ... ){
  sink( file = paste0(parentDir, "gallery/", md5hash, ".txt" ) )
  print( object ) 
  sink()
}

extractMiniature.glmnet <- function( object, md5hash, parentDir, ... ){
  sink( file = paste0(parentDir, "gallery/", md5hash, ".txt" ) )
  print( object ) 
  sink()
}

extractMiniature.survfit <- function( object, md5hash, parentDir, ... ){
  sink( file = paste0(parentDir, "gallery/", md5hash, ".txt" ) )
  print( summary( object ) )
  sink()
}


