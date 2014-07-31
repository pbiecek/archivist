# TODO: TO CHECK

extractTags <- function ( object, ... )
  UseMethod("extractTags")

extractTags.default <- function( object, ... ) {
  name <- paste0( "name:", deparse( substitute( object ) ) )
  class <- paste0( "class:", class( object )[1] )
  date <- paste0( "date:", now() )
  return( c( name, class, date ) )

}

extractTags.data.frame <- function( object, ... ) {
  name <- paste0( "name:", deparse( substitute( object ) ) )
  var <- unique( paste0( "varname:", c( colnames( object ) ) ) )
  class <- paste0( "class:", class( object )[1] )
  date <- paste0( "date:", now() )
  return( c( name, var, class, date ) )
}

extractTags.ggplot <- function( object, ... ) {
  library( ggplot2 )
  labx <- paste0( "labelx:", object$labels$x )
  laby <- paste0( "labely:", object$labels$y )
  data <- paste0( "data:", object$data )
  class <- paste0( "class:", class( object )[1] )
  name <- paste0( "name:", deparse( substitute( object ) ) )
  date <- paste0( "date:", now() )
  return( c( labx, laby, data, class, name, date ) )
  
}

extractTags.lm <- function( object, ... ) {
  var <- paste0( "coefname:", names( object$coefficients ) )
  class <- paste0( "class:", class( object )[1] )
  name <- paste0( "name:", deparse( substitute( object ) ) )
  call <- paste0( "call:", object$call )
  date <- paste0( "date:", now() )
  return( c( name, class, var, call, date ) )
  
}

extractTags.htest <- function( object, ... ) {
  library( stats )
  alt <- paste0( "alternative:", object$alternative )
  method <- paste0( "method:", object$method )
  class <- paste0( "class:", class( object )[1] )
  name <- paste0( "name:", deparse( substitute( object ) ) )
  date <- paste0( "date:", now() )
  return( c( name, class, alt, method, date ) )
  
}

extractTags.trellis <- function( object, ... ) {
  library( lattice )
}

extractTags.twins <- function( object, ... ) {
  library( cluster )
}

extractTags.partition <- function( object, ... ) {
  library( cluster )
}

extractTags.lda <- function( object, ... ) {
  library( MASS )
}

extractTags.qda <- function( object, ... ) {
  library( MASS )
}

extractTags.glmnet <- function( object, ... ) {
  library( glmnet )
}

extractTags.survfit <- function( object, ... ) {
  library( survival )
}
