# TODO:

extractData <- function( object, md5hash )
  UseMethod( "extractData" )

extractData.default <- function( object, md5hash ){
  
}

extractData.ggplot <- function( object, md5hash ){
  extractedDF <- object$data
  md5hashDF <- saveToRepo( extractedDF )
  addRelation( md5hash, md5hashDF, "data.source" )
}

extractData.lm <- function( object, md5hash ){
  extractedDF <- object$model
  md5hashDF <- saveToRepo( extractedDF )
  addRelation( md5hash, md5hashDF, "data.source" )
}

