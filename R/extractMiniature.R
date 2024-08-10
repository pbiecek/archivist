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

extractMiniature.default <- function( object, md5hash, parentDir, ... ){

}

#' @return \code{NULL}
#'
#' @rdname extractMiniature
#' @method extractMiniature data.frame

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

extractMiniature.survfit <- function( object, md5hash, parentDir, ... ){
  sink( file = file.path(parentDir, "gallery", paste0(md5hash, ".txt" )) )
  print( summary( object ) )
  sink()
  addTag("format:txt", md5hash, dir=parentDir)
}
