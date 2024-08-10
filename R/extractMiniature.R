#' Internal function for extraction of miniatures
#'
#' @param object for this object miniatures are extracted
#' @param md5hash hash of the object
#' @param parentDir parent dir
#' @param ... other arguments
#' @param firstRows what to present in the miniature
#' @param width how large should be the miniature?
#' @param height how large should be the miniature?
#' 
#' @rdname extractMiniature
#' @export extractMiniature

extractMiniature <- function( object, md5hash, parentDir, ... )
  UseMethod( "extractMiniature" )

#' @return \code{NULL}
#'
#' @rdname extractMiniature
#' @method extractMiniature default
#' @exportS3Method archivist::extractMiniature

extractMiniature.default <- function( object, md5hash, parentDir, ... ){

}

#' @return \code{NULL}
#'
#' @rdname extractMiniature
#' @method extractMiniature data.frame
#' @exportS3Method archivist::extractMiniature

extractMiniature.data.frame <- function( object, md5hash, parentDir, ..., firstRows = 6 ){
  sink( file = file.path( parentDir, "gallery", paste0(md5hash, ".txt" )) )
  print( head( object, firstRows ) )
  sink()
  addTag("format:txt", md5hash, dir=parentDir)
}

#' @return \code{NULL}
#'
#' @rdname extractMiniature
#' @method extractMiniature ggplot
#' @exportS3Method archivist::extractMiniature

extractMiniature.ggplot <- function( object, md5hash, parentDir, ..., width = 800, height = 600 ){
  png( file.path( parentDir, "gallery", paste0(md5hash, ".png" )), width, height )
  plot( object )
  dev.off()
  addTag("format:png", md5hash, dir=parentDir)
}

#' @return \code{NULL}
#'
#' @rdname extractMiniature
#' @method extractMiniature recordedplot
#' @exportS3Method archivist::extractMiniature

extractMiniature.recordedplot <- function( object, md5hash, parentDir, ..., width = 800, height = 600 ){
  png( file.path( parentDir, "gallery", paste0(md5hash, ".png" )), width, height )
  grDevices::replayPlot( object )
  dev.off()
  addTag("format:png", md5hash, dir=parentDir)
}

#' @return \code{NULL}
#'
#' @rdname extractMiniature
#' @method extractMiniature lm
#' @exportS3Method archivist::extractMiniature

extractMiniature.lm <- function( object, md5hash, parentDir, ... ){
  sink( file = file.path(parentDir, "gallery", paste0(md5hash, ".txt")) )
  print( summary( object ) )
  sink()
  addTag("format:txt", md5hash, dir=parentDir)
}

#' @return \code{NULL}
#'
#' @rdname extractMiniature
#' @method extractMiniature htest
#' @exportS3Method archivist::extractMiniature

extractMiniature.htest <- function( object, md5hash, parentDir, ... ){
  sink( file = file.path(parentDir, "gallery", paste0(md5hash, ".txt" )) )
  print( object )
  sink()
  addTag("format:txt", md5hash, dir=parentDir)
}

#' @return \code{NULL}
#'
#' @rdname extractMiniature
#' @method extractMiniature trellis
#' @exportS3Method archivist::extractMiniature

extractMiniature.trellis <- function( object, md5hash, parentDir, ..., width = 800, height = 600 ){
  png( file.path( parentDir, "gallery", paste0(md5hash, ".png" )), width, height )
  print( object )
  dev.off()
  addTag("format:png", md5hash, dir=parentDir)
}

#' @return \code{NULL}
#'
#' @rdname extractMiniature
#' @method extractMiniature twins
#' @exportS3Method archivist::extractMiniature

extractMiniature.twins <- function( object, md5hash, parentDir, ..., width = 800, height = 600 ){
  png( file.path( parentDir, "gallery", paste0(md5hash, ".png" )), width, height )
  par( mfrow = c( 1, 2 ) )
  plot( object )
  dev.off()
  par( mfrow = c( 1, 1 ) )
  addTag("format:png", md5hash, dir=parentDir)
}

#' @return \code{NULL}
#'
#' @rdname extractMiniature
#' @method extractMiniature partition
#' @exportS3Method archivist::extractMiniature

extractMiniature.partition <- function( object, md5hash, parentDir, ...,width = 800, height = 600 ){
  png( file.path( parentDir, "gallery", paste0(md5hash, ".png" )), width, height )
  par( mfrow = c( 1, 2 ) )
  plot( object )
  dev.off()
  par( mfrow = c( 1, 1 ) )
  addTag("format:png", md5hash, dir=parentDir)
}

#' @return \code{NULL}
#'
#' @rdname extractMiniature
#' @method extractMiniature lda
#' @exportS3Method archivist::extractMiniature

extractMiniature.lda <- function( object, md5hash, parentDir, ... ){
  sink( file = file.path(parentDir, "gallery", paste0(md5hash, ".txt" )) )
  print( object )
  sink()
  addTag("format:txt", md5hash, dir=parentDir)
}

#' @return \code{NULL}
#'
#' @rdname extractMiniature
#' @method extractMiniature qda
#' @exportS3Method archivist::extractMiniature

extractMiniature.qda <- function( object, md5hash, parentDir, ... ){
  sink( file = file.path(parentDir, "gallery", paste0(md5hash, ".txt" )) )
  print( object )
  sink()
  addTag("format:txt", md5hash, dir=parentDir)
}

#' @return \code{NULL}
#'
#' @rdname extractMiniature
#' @method extractMiniature glmnet
#' @exportS3Method archivist::extractMiniature

extractMiniature.glmnet <- function( object, md5hash, parentDir, ... ){
  sink( file = file.path(parentDir, "gallery", paste0(md5hash, ".txt" )) )
  print( object )
  sink()
  addTag("format:txt", md5hash, dir=parentDir)
}

#' @return \code{NULL}
#'
#' @rdname extractMiniature
#' @method extractMiniature survfit
#' @exportS3Method archivist::extractMiniature

extractMiniature.survfit <- function( object, md5hash, parentDir, ... ){
  sink( file = file.path(parentDir, "gallery", paste0(md5hash, ".txt" )) )
  print( summary( object ) )
  sink()
  addTag("format:txt", md5hash, dir=parentDir)
}
