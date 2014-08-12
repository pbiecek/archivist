# TODO: TO CHECK

extractTags <- function ( object, objectNameX, ... )
  UseMethod("extractTags")

extractTags.default <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object )[1] )
  date <- paste0( "date:", now() )
  return( c( name, class, date ) )

}

extractTags.data.frame <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  var <- unique( paste0( "varname:", c( colnames( object ) ) ) )
  class <- paste0( "class:", class( object )[1] )
  date <- paste0( "date:", now() )
  return( c( name, var, class, date ) )
}

extractTags.ggplot <- function( object, objectNameX, ... ) {
  library( ggplot2 )
  labx <- paste0( "labelx:", object$labels$x )
  laby <- paste0( "labely:", object$labels$y )
  data <- paste0( "data:", object$data )
  class <- paste0( "class:", class( object )[2] )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( labx, laby, data, class, name, date ) )
  
}

extractTags.lm <- function( object, objectNameX, ... ) {
  var <- paste0( "coefname:", names( object$coefficients ) )
  class <- paste0( "class:", class( object )[1] )
  name <- paste0( "name:", objectNameX )
  call <- paste0( "call:", object$call )
  date <- paste0( "date:", now() )
  return( c( name, class, var, call, date ) )
  
}

extractTags.htest <- function( object, objectNameX, ... ) {
  library( stats )
  alt <- paste0( "alternative:", object$alternative )
  method <- paste0( "method:", object$method )
  class <- paste0( "class:", class( object )[1] )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( name, class, alt, method, date ) )
  
}

extractTags.trellis <- function( object, objectNameX, ... ) {
  library( lattice )
  class <- paste0( "class:", class( object )[1] )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  call <- paste0( "call:", object$call )
  return( c( name, class, date, call ) )
  
}

extractTags.twins <- function( object, objectNameX, ... ) {
  library( cluster )
  ac <- paste0( "ac:", object$ac)
  merge <- paste0( "merge:", object$merge)
  diss <- paste0( "diss:", object$diss)
  data <- paste0( "data:", object$data)
  class <- paste0( "class:", class( object )[1] )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( name, class, date, ac, merge, diss, data ) )
}

extractTags.partition <- function( object, objectNameX, ... ) {
  library( cluster )
  call <- paste0( "call:", object$call )
  data <- paste0( "data:", object$data )
  diss <- paste0( "diss:", object$diss )
  objective <- paste0( "objective:", object$objective )
  class <- paste0( "class:", class( object )[1] )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( name, class, date, call, data, diss, objective ) )
}

extractTags.lda <- function( object, objectNameX, ... ) {
  library( MASS )
  call <- paste0( "call:", object$call )
  class <- paste0( "class:", class( object )[1] )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( name, class, date, call ) )
}

extractTags.qda <- function( object, objectNameX, ... ) {
  library( MASS )
  call <- paste0( "call:", object$call )
  class <- paste0( "class:", class( object )[1] )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  terms <- paste0( "terms:", object$terms )
  return( c( name, class, date, call, terms ) )
}

extractTags.glmnet <- function( object, objectNameX, ... ) {
  library( glmnet )
  class <- paste0( "class:", class( object )[1] )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  call <- paste0( "call:", object$call )
  beta <- paste0( "beta:", object$call )
  lambda <- paste0( "lambda:", object$call )
  return( c( name, class, date, call, beta, lambda ) )
}

extractTags.survfit <- function( object, objectNameX, ... ) {
  library( survival )
  class <- paste0( "class:", class( object )[1] )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  call <- paste0( "call:", object$call )
  strata <- paste0( "strata:", object$call )
  type <- paste0( "type:", object$call )
  return( c( name, class, date, call, strata, type ) )
}
