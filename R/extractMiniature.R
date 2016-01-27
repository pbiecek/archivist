extractMiniature <- function( object, md5hash, parentDir, ... )
  UseMethod( "extractMiniature" )

extractMiniature.default <- function( object, md5hash, parentDir, ... ){

}

extractMiniature.data.frame <- function( object, md5hash, parentDir, ..., firstRows = 6 ){
  sink( file = file.path( parentDir, "gallery", paste0(md5hash, ".txt" )) )
  print( head( object, firstRows ) )
  sink()
  addTag("format:txt", md5hash, dir=parentDir)
}

extractMiniature.ggplot <- function( object, md5hash, parentDir, ..., width = 800, height = 600 ){
  png( file.path( parentDir, "gallery", paste0(md5hash, ".png" )), width, height )
  plot( object )
  dev.off()
  addTag("format:png", md5hash, dir=parentDir)
}

extractMiniature.lm <- function( object, md5hash, parentDir, ... ){
  sink( file = file.path(parentDir, "gallery", paste0(md5hash, ".txt")) )
  print( summary( object ) )
  sink()
  addTag("format:txt", md5hash, dir=parentDir)
}

extractMiniature.htest <- function( object, md5hash, parentDir, ... ){
  sink( file = file.path(parentDir, "gallery", paste0(md5hash, ".txt" )) )
  print( object )
  sink()
  addTag("format:txt", md5hash, dir=parentDir)
}

extractMiniature.trellis <- function( object, md5hash, parentDir, ..., width = 800, height = 600 ){
  png( file.path( parentDir, "gallery", paste0(md5hash, ".png" )), width, height )
  print( object )
  dev.off()
  addTag("format:png", md5hash, dir=parentDir)
}

extractMiniature.twins <- function( object, md5hash, parentDir, ..., width = 800, height = 600 ){
  png( file.path( parentDir, "gallery", paste0(md5hash, ".png" )), width, height )
  par( mfrow = c( 1, 2 ) )
  plot( object )
  dev.off()
  par( mfrow = c( 1, 1 ) )
  addTag("format:png", md5hash, dir=parentDir)
}

extractMiniature.partition <- function( object, md5hash, parentDir, ...,width = 800, height = 600 ){
  png( file.path( parentDir, "gallery", paste0(md5hash, ".png" )), width, height )
  par( mfrow = c( 1, 2 ) )
  plot( object )
  dev.off()
  par( mfrow = c( 1, 1 ) )
  addTag("format:png", md5hash, dir=parentDir)
}

extractMiniature.lda <- function( object, md5hash, parentDir, ... ){
  sink( file = file.path(parentDir, "gallery", paste0(md5hash, ".txt" )) )
  print( object )
  sink()
  addTag("format:txt", md5hash, dir=parentDir)
}

extractMiniature.qda <- function( object, md5hash, parentDir, ... ){
  sink( file = file.path(parentDir, "gallery", paste0(md5hash, ".txt" )) )
  print( object )
  sink()
  addTag("format:txt", md5hash, dir=parentDir)
}

extractMiniature.glmnet <- function( object, md5hash, parentDir, ... ){
  sink( file = file.path(parentDir, "gallery", paste0(md5hash, ".txt" )) )
  print( object )
  sink()
  addTag("format:txt", md5hash, dir=parentDir)
}

extractMiniature.survfit <- function( object, md5hash, parentDir, ... ){
  sink( file = file.path(parentDir, "gallery", paste0(md5hash, ".txt" )) )
  print( summary( object ) )
  sink()
  addTag("format:txt", md5hash, dir=parentDir)
}
