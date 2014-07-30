# TODO: TO CHECK

extractData <- function( object, md5hash )
  UseMethod( "extractData" )

extractData.default <- function( object, md5hash, dir ){
  
}

extractData.ggplot <- function( object, md5hash, dir ){
  library( ggplot2 )
  extractedDF <- object$data
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE )
  addTag( tag = paste0("relationWith:", md5hash), md5hash = md5hashDF, dir = dir )

}

extractData.lm <- function( object, md5hash, dir ){
  extractedDF <- object$model
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE )
  addTag( tag = paste0("relationWith:", md5hash), md5hash = md5hashDF, dir = dir )
}

extractData.htest <- function( object, md5hash, dir ){
  library( stats )
  object$data.name # variable name
}

extractData.trellis <- function( object, md5hash, dir ){
  library( lattice )
  as.character( object$call )[3] # name of data.frame
}

extractData.twins <- function( object, md5hash, dir ){
  library( cluster ) # agnes / diana / mona inherits after twins
  extractedDF <- object$data
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE )
  addTag( tag = paste0("relationWith:", md5hash), md5hash = md5hashDF, dir = dir )
}

extractData.partition <- function( object, md5hash, dir ){
  library( cluster ) # pam / clara / fanny inherits after partition
  extractedDF <- object$data
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE )
  addTag( tag = paste0("relationWith:", md5hash), md5hash = md5hashDF, dir = dir )
}

extractData.lda <- function( object, md5hash, dir ){
  library( MASS ) 
  object$call  # model call
}

extractData.qda <- function( object, md5hash, dir ){
  library( MASS )  
  object$call  # model call
}


extractData.glmnet <- function( object, md5hash, dir ){
  library( glmnet ) # elmet / lognet / multnet /foshnet /coxnet /mrelnet 
                   # inherits after glmnet
  object$call # model call
}

extractData.survfit <- function( object, md5hash, dir ){
  library( survival ) 
  object$call # model call
}
