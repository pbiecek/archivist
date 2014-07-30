# TODO: TO CHECK

extractMiniature <- function( object, mdhash5, dir, ... )
  UseMethod( "extractMiniature" )

extractMiniature.default <- function( object, mdhash5, dir, ... ){
  
}

extractMiniature.data.frame <- function( object, mdhash5, dir, ..., firstRows = 6 ){
  sink( file = paste0( dir, md5hash, ".txt" ) )
  print( head( object, firstRows ) )
  sink()
}

extractMiniature.ggplot <- function( object, mdhash5, dir, ..., width = 800, height = 600 ){
  library( gqplot2 )
  fun <- get( format )
  fun( paste0( dir, md5hash, ".", format ), width, height )
  print( object )
  dev.off()
}

extractMiniature.lm <- function( object, mdhash5, dir, ... ){
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( summary( object ) )
  sink()
}

extractMiniature.htest <- function( object, mdhash5, dir, ... ){
  library( stats )
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( object )
  sink()
}

extractMiniature.trellis <- function( object, mdhash5, dir, ... ){
  library( lattice )
  fun <- get( format )
  fun( paste0( dir, md5hash, ".", format ), width, height )
  print( object )
  dev.off()
}

extractMiniature.twins <- function( object, mdhash5, dir, ... ){
  library( cluster )
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( object )
  sink()
}

extractMiniature.partition <- function( object, mdhash5, dir, ... ){
  library( cluster )
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( summary( object ) )
  sink()
}

extractMiniature.lda <- function( object, mdhash5, dir, ... ){
  library( lda )
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( object ) 
  sink()
}

extractMiniature.qda <- function( object, mdhash5, dir, ... ){
  library( qda )
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( object ) 
  sink()
}

extractMiniature.glmnet <- function( object, mdhash5, dir, ... ){
  library( glmnet )
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( object ) 
  sink()
}

extractMiniature.survfit <- function( object, mdhash5, dir, ... ){
  library( survival )
  sink( file = paste0(dir, md5hash, ".txt" ) )
  print( summary( object ) )
  sink()
}


