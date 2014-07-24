# TODO:

extractTags <- function ( object, ... )
  UseMethod("extractTags")

extractTags.default <- function( object, ... ) {

}

extractTags.data.frame <- function( object, ... ) {
  unique( c( colnames( object ),
           "data frame" ) )
}

extractTags.ggplot <- function( object, ... ) {
  require( ggplot2 )
}

extractTags.lm <- function( object, ... ) {
  unique( c( names( object$coefficients ), 
             as.character( object$terms ),
             colnames( object$model ),
             "linear regression model" ) )
}

extractTags.htest <- function( object, ... ) {
  require( stats )
}

extractTags.trellis <- function( object, ... ) {
  require( lattice )
}

extractTags.twins <- function( object, ... ) {
  require( cluster )
}

extractTags.partition <- function( object, ... ) {
  require( cluster )
}

extractTags.lda <- function( object, ... ) {
  require( MASS )
}

extractTags.qda <- function( object, ... ) {
  require( MASS )
}

extractTags.glmnet <- function( object, ... ) {
  require( glmnet )
}

extractTags.survfit <- function( object, ... ) {
  require( survival )
}
