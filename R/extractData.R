# TODO: TO CHECK

extractData <- function( object, parrentMd5hash, parentDir )
  UseMethod( "extractData" )

extractData.default <- function( object, parrentMd5hash, parentDir ){
  
}

extractData.ggplot <- function( object, parrentMd5hash, parentDir ){
  library( ggplot2 )
  extractedDF <- object$data
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, dir = parentDir, rememberName = FALSE )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )

}

extractData.lm <- function( object, parrentMd5hash, parentDir ){
  extractedDF <- object$model
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, dir = parentDir, rememberName = FALSE )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  # assign( attr( parrentMd5hash, "data"), value = md5hashDF, envir = sys.frame( 2 ) )
}

extractData.htest <- function( object, parrentMd5hash, parentDir ){
  library( stats )
  object$data.name # variable name
}

extractData.trellis <- function( object, parrentMd5hash, parentDir ){
  library( lattice )
  as.character( object$call )[3] # name of data.frame
}

extractData.twins <- function( object, parrentMd5hash, parentDir ){
  library( cluster ) # agnes / diana / mona inherits after twins
  extractedDF <- object$data
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, dir = parentDir, rememberName = FALSE )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
}

extractData.partition <- function( object, parrentMd5hash, parentDir ){
  library( cluster ) # pam / clara / fanny inherits after partition
  extractedDF <- object$data
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, dir = parentDir, rememberName = FALSE )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
}

extractData.lda <- function( object, parrentMd5hash, parentDir ){
  library( MASS ) 
  object$call  # model call
}

extractData.qda <- function( object, parrentMd5hash, parentDir ){
  library( MASS )  
  object$call  # model call
}


extractData.glmnet <- function( object, parrentMd5hash, parentDir ){
  library( glmnet ) # elmet / lognet / multnet /foshnet /coxnet /mrelnet 
                   # inherits after glmnet
  object$call # model call
}

extractData.survfit <- function( object, parrentMd5hash, parentDir ){
  library( survival ) 
  object$call # model call
}


