
extractTags <- function ( object, objectNameX, ... )
  UseMethod("extractTags")

extractTags.default <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  class <- paste0( "class:", class( object ) )
  date <- paste0( "date:", now() )
  return( c( name, class, date ) )

}

extractTags.data.frame <- function( object, objectNameX, ... ) {
  name <- paste0( "name:", objectNameX )
  var <- unique( paste0( "varname:", c( colnames( object ) ) ) )
  class <- paste0( "class:", class( object ) )
  date <- paste0( "date:", now() )
  return( c( name, var, class, date ) )
}

extractTags.ggplot <- function( object, objectNameX, ... ) {
  labx <- paste0( "labelx:", object$labels$x )
  laby <- paste0( "labely:", object$labels$y )
  class <- paste0( "class:", class( object ) )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( labx, laby, class, name, date ) )
  
}

extractTags.lm <- function( object, objectNameX, ... ) {
  var <- paste0( "coefname:", names( object$coefficients ) )
  class <- paste0( "class:", class( object ) )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( name, class, var, date ) )
  
}

extractTags.htest <- function( object, objectNameX, ... ) {
  alt <- paste0( "alternative:", object$alternative )
  method <- paste0( "method:", object$method )
  class <- paste0( "class:", class( object ) )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( name, class, alt, method, date ) )
  
}

extractTags.trellis <- function( object, objectNameX, ... ) {
  class <- paste0( "class:", class( object ) )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( name, class, date ) )
  
}

extractTags.twins <- function( object, objectNameX, ... ) {
  ac <- paste0( "ac:", object$ac)
  class <- paste0( "class:", class( object ) )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( name, class, date, ac ) )
}

extractTags.partition <- function( object, objectNameX, ... ) {
  objective <- paste0( "objective:", object$objective )
  class <- paste0( "class:", class( object ) )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( name, class, date, objective ) )
}

extractTags.lda <- function( object, objectNameX, ... ) {
  class <- paste0( "class:", class( object ) )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( name, class, date ) )
}

extractTags.qda <- function( object, objectNameX, ... ) {
  class <- paste0( "class:", class( object ) )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  terms <- paste0( "terms:", object$terms )
  return( c( name, class, date, terms ) )
}

extractTags.glmnet <- function( object, objectNameX, ... ) {
  class <- paste0( "class:", class( object ) )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  return( c( name, class, date ) )
}

extractTags.survfit <- function( object, objectNameX, ... ) {
  class <- paste0( "class:", class( object ) )
  name <- paste0( "name:", objectNameX )
  date <- paste0( "date:", now() )
  strata <- paste0( "strata:", object$strata )
  type <- paste0( "type:", object$type )
  return( c( name, class, date, strata, type ) )
}
