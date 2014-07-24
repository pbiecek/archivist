# TODO:

extractMiniature <- function( object, mdhash5, ... )
  UseMethod( "extractMiniature" )

extractMiniature.default <- function( object, mdhash5, ... ){
  
}

extractMiniature.data.frame <- function( object, mdhash5, ... ){
  
}

extractMiniature.ggplot <- function( object, mdhash5, ... ){
  require( gqplot2 )
}

extractMiniature.lm <- function( object, mdhash5, ... ){
  
}

extractMiniature.htest <- function( object, mdhash5, ... ){
  require( stats )
}

extractMiniature.trellis <- function( object, mdhash5, ... ){
  require( lattice )
}

extractMiniature.twins <- function( object, mdhash5, ... ){
  require( cluster )
}

extractMiniature.partition <- function( object, mdhash5, ... ){
  require( cluster )
}

extractMiniature.lda <- function( object, mdhash5, ... ){
  require( lda )
}

extractMiniature.qda <- function( object, mdhash5, ... ){
  require( qda )
}

extractMiniature.glmnet <- function( object, mdhash5, ... ){
  require( glmnet )
}

extractMiniature.survfit <- function( object, mdhash5, ... ){
  require( survival )
}


