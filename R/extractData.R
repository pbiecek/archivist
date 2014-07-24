# TODO:

extractData <- function( object, md5hash )
  UseMethod( "extractData" )

extractData.default <- function( object, md5hash ){
  
}

extractData.ggplot <- function( object, md5hash ){
  require( ggplot2 )
  extractedDF <- object$data
  md5hashDF <- saveToRepo( extractedDF )
  addRelation( md5hash, md5hashDF, "data.source" )
}

extractData.lm <- function( object, md5hash ){
  extractedDF <- object$model
  md5hashDF <- saveToRepo( extractedDF )
  addRelation( md5hash, md5hashDF, "data.source" )
}

extractData.htest <- function( object, md5hash ){
  require( stats )
  object$data.name # variable name
}

extractData.trellis <- function( object, md5hash ){
  require( lattice )
  as.character( object$call )[3] # name of data.frame
}

extractData.twins <- function( object, md5hash ){
  require( cluster ) # agnes / diana / mona inherits after twins
  object$data
}

extractData.partition <- function( object, md5hash ){
  require( cluster ) # pam / clara / fanny inherits after partition
  object$data
}

extractData.lda <- function( object, md5hash ){
  require( MASS ) 
  object$call  # model call
}

extractData.qda <- function( object, md5hash ){
  require( MASS )  
  object$call  # model call
}


extractData.glmnet <- function( object, md5hash ){
  require( glmnet ) # elmet / lognet / multnet /foshnet /coxnet /mrelnet 
                   # inherits after glmnet
  object$call # model call
}

extractData.survfit <- function( object, md5hash ){
  require( survival ) 
  object$call # model call
}
