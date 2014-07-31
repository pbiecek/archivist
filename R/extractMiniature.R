# TODO: TO CHECK

extractMiniature <- function( object, md5hash, dir, ... )
  UseMethod( "extractMiniature" )

extractMiniature.default <- function( object, md5hash, dir, ... ){
  
}

extractMiniature.data.frame <- function( object, md5hash, dir, ..., firstRows = 6 ){
  sink( file = paste0( dir, md5hash, ".txt" ) )
  print( head( object, firstRows ) )
  sink()
}

extractMiniature.ggplot <- function( object, md5hash, dir, ..., width = 800, height = 600 ){
  library( ggplot2 )
  png( paste0( dir, md5hash, ".png" ), width, height )
  print( object )
  dev.off()
}

extractMiniature.lm <- function( object, md5hash, dir, ... ){
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( summary( object ) )
  sink()
}

extractMiniature.htest <- function( object, md5hash, dir, ... ){
  library( stats )
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( object )
  sink()
}

extractMiniature.trellis <- function( object, md5hash, dir, ... ){
  library( lattice )
  fun <- get( format )
  fun( paste0( dir, md5hash, ".", format ), width, height )
  print( object )
  dev.off()
}

extractMiniature.twins <- function( object, md5hash, dir, ... ){
  library( cluster )
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( object )
  sink()
}

extractMiniature.partition <- function( object, md5hash, dir, ... ){
  library( cluster )
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( summary( object ) )
  sink()
}

extractMiniature.lda <- function( object, md5hash, dir, ... ){
  library( lda )
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( object ) 
  sink()
}

extractMiniature.qda <- function( object, md5hash, dir, ... ){
  library( qda )
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( object ) 
  sink()
}

extractMiniature.glmnet <- function( object, md5hash, dir, ... ){
  library( glmnet )
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( object ) 
  sink()
}

extractMiniature.survfit <- function( object, md5hash, dir, ... ){
  library( survival )
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( summary( object ) )
  sink()
}


