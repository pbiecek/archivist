extractData <- function( object, parrentMd5hash, parentDir, isForce )
  UseMethod( "extractData" )

extractData.default <- function( object, parrentMd5hash, parentDir, isForce ){
  
}

extractData.ggplot <- function( object, parrentMd5hash, parentDir, isForce ){
  extractedDF <- object$data
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir, 
                           rememberName = FALSE, archiveTags = FALSE, force = isForce )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}

extractData.lm <- function( object, parrentMd5hash, parentDir, isForce ){
  extractedDF <- object$model
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           rememberName = FALSE, archiveTags = FALSE, force = isForce )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}

extractData.htest <- function( object, parrentMd5hash, parentDir, isForce ){
#   extractedDF1 <- get( object$data.name, envir = .GlobalEnv )
#   extractedDF2 <- get( object$data.name, envir = .GlobalEnv )
#   md5hashDF <- saveToRepo( c( extractedDF1, extractedDF2 ), 
#                            archiveData = FALSE, repoDir = parentDir,
#                            rememberName = FALSE, archiveTags = FALSE, force = isForce )
#   addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
#   return( md5hashDF )
}

extractData.trellis <- function( object, parrentMd5hash, parentDir, isForce ){
  extractedDF <- get( as.character( object$call )[3], envir = .GlobalEnv )
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           rememberName = FALSE, archiveTags = FALSE, force = isForce )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}

extractData.twins <- function( object, parrentMd5hash, parentDir, isForce ){
  # agnes / diana / mona inherits after twins
  extractedDF <- object$data
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           rememberName = FALSE, archiveTags = FALSE, force = isForce )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}

extractData.partition <- function( object, parrentMd5hash, parentDir, isForce ){
  # pam / clara / fanny inherits after partition
  extractedDF <- object$data
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           rememberName = FALSE, archiveTags = FALSE, force = isForce )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}

extractData.lda <- function( object, parrentMd5hash, parentDir, isForce ){
  extractedDF <-  get( as.character( ( object$call ) )[3], envir = .GlobalEnv )
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           rememberName = FALSE, archiveTags = FALSE, force = isForce )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}

extractData.qda <- function( object, parrentMd5hash, parentDir, isForce ){
  extractedDF <-  get( as.character( ( object$call ) )[2], envir = .GlobalEnv )
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           rememberName = FALSE, archiveTags = FALSE, force = isForce )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}


extractData.glmnet <- function( object, parrentMd5hash, parentDir, isForce ){
  # elmet / lognet / multnet /foshnet /coxnet /mrelnet 
                   # inherits after glmnet
  extractedDF1 <- get( as.character( object$call )[2], envir = .GlobalEnv )
  extractedDF2 <- get( as.character( object$call )[3], envir = .GlobalEnv )
  md5hashDF <- saveToRepo( c( extractedDF1, extractedDF1 ), archiveData = FALSE, 
                           repoDir = parentDir, rememberName = FALSE, archiveTags = FALSE, 
                           force = isForce )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}

extractData.survfit <- function( object, parrentMd5hash, parentDir, isForce ){
  extractedDF <-  get( as.character( object$call )[3], envir = .GlobalEnv )
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir, 
                           rememberName = FALSE, archiveTags = FALSE, force = isForce )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}


