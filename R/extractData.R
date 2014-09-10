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
  if (exists(strsplit(object$data.name, " and ")[[1]][1], envir = parent.frame(1)) &
        exists(strsplit(object$data.name, " and ")[[1]][2], envir = parent.frame(1)) ){
  extractedDF1 <- get( strsplit(object$data.name, " and ")[[1]][1], envir = parent.frame(1) )
  extractedDF2 <- get( strsplit(object$data.name, " and ")[[1]][2], envir = parent.frame(1) )
  md5hashDF <- saveToRepo( c( extractedDF1, extractedDF2 ), 
                           archiveData = FALSE, repoDir = parentDir,
                           rememberName = FALSE, archiveTags = FALSE, force = isForce )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
  }else{
    warning(paste0("Could not find data ", strsplit(object$data.name, " and ")[[1]][1],
            " or ", strsplit(object$data.name, " and ")[[1]][2], 
            ". Dataset was not archived."))
  }
}

extractData.trellis <- function( object, parrentMd5hash, parentDir, isForce ){
  if (exists(as.character( ( object$call ) )[3], envir = parent.frame(1) )){
  extractedDF <- get( as.character( object$call )[3], envir = parent.frame(1) )
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           rememberName = FALSE, archiveTags = FALSE, force = isForce )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
  }else{
    warning(paste0("Could not find data ", as.character( ( object$call ) )[3], 
    ". Dataset was not archived."))
  }
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
  if (exists(as.character( ( object$call ) )[3], envir = parent.frame(1) )){
  extractedDF <-  get( as.character( ( object$call ) )[3], envir = parent.frame(1) )
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           rememberName = FALSE, archiveTags = FALSE, force = isForce )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
  }else{
   warning(paste0("Could not find data ", as.character( ( object$call ) )[3], 
                  ". Dataset was not archived.")) 
  }
}

extractData.qda <- function( object, parrentMd5hash, parentDir, isForce ){
  if (exists(as.character( ( object$call ) )[2], envir = parent.frame(1) )){
  extractedDF <-  get( as.character( ( object$call ) )[2], envir = parent.frame(1) )
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           rememberName = FALSE, archiveTags = FALSE, force = isForce )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
  }else{
    warning(paste0("Could not find data ", as.character( ( object$call ) )[2], 
                   ". Dataset was not archived."))  
  }
}


extractData.glmnet <- function( object, parrentMd5hash, parentDir, isForce ){
  # elmet / lognet / multnet /foshnet /coxnet /mrelnet 
                   # inherits after glmnet
  if (exists(as.character( ( object$call ) )[3], envir = parent.frame(1) ) & 
        exists(as.character( ( object$call ) )[2], envir = parent.frame(1) )){
  extractedDF1 <- get( as.character( object$call )[2], envir = parent.frame(1) )
  extractedDF2 <- get( as.character( object$call )[3], envir = parent.frame(1) )
  md5hashDF <- saveToRepo( c( extractedDF1, extractedDF1 ), archiveData = FALSE, 
                           repoDir = parentDir, rememberName = FALSE, archiveTags = FALSE, 
                           force = isForce )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
  }else{
    warning(paste0("Could not find data ", as.character( ( object$call ) )[3], 
                   " or ", as.character( ( object$call ) )[2], 
                   ". Dataset was not archived.")) 
  }
}

extractData.survfit <- function( object, parrentMd5hash, parentDir, isForce ){
  if (exists(as.character( ( object$call ) )[3], envir = parent.frame(1) )){
  extractedDF <-  get( as.character( object$call )[3], envir = parent.frame(1) )
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir, 
                           rememberName = FALSE, archiveTags = FALSE, force = isForce )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
  }else{
    warning(paste0("Could not find data ", as.character( ( object$call ) )[3], 
                   ". Dataset was not archived."))  
  }
}


