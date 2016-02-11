extractData <- function( object, parrentMd5hash, parentDir, isForce, ASCII )
  UseMethod( "extractData" )

extractData.default <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  
}

extractData.ggplot <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  extractedDF <- object$data
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", digest(extractedDF), "'") )[,1]
    if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- digest(extractedDF)
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir, 
                           artifactName = DFname, archiveTags = FALSE, force = isForce, ascii = ASCII,
                           archiveSessionInfo = FALSE, silent = TRUE)
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}

extractData.lm <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  extractedDF <- object$model
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", digest(extractedDF), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- digest(extractedDF)
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           artifactName = DFname, archiveTags = FALSE, force = isForce, ascii = ASCII,
                           archiveSessionInfo = FALSE, silent = TRUE)
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}

extractData.htest <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  if (exists(strsplit(object$data.name, " and ")[[1]][1], envir = parent.frame(1)) &
        exists(strsplit(object$data.name, " and ")[[1]][2], envir = parent.frame(1)) ){
  extractedDF1 <- get( strsplit(object$data.name, " and ")[[1]][1], envir = parent.frame(1) )
  extractedDF2 <- get( strsplit(object$data.name, " and ")[[1]][2], envir = parent.frame(1) )
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", digest(list( extractedDF1, extractedDF2 )), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- digest(list( extractedDF1, extractedDF2 ))
  md5hashDF <- saveToRepo( list( extractedDF1, extractedDF2 ), 
                           archiveData = FALSE, repoDir = parentDir,
                           artifactName = DFname, archiveTags = FALSE,
                           force = isForce, ascii = ASCII,
                           archiveSessionInfo = FALSE, silent = TRUE)
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
  }else{
    warning(paste0("Could not find data ", strsplit(object$data.name, " and ")[[1]][1],
            " or ", strsplit(object$data.name, " and ")[[1]][2], 
            ". Dataset was not archived."))
  }
}

extractData.lda <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  if (exists(as.character( ( object$call ) )[3], envir = parent.frame(1) )){
    extractedDF <-  get( as.character( ( object$call ) )[3], envir = parent.frame(1) )
    # check if that artifact might have been already archived
    check <- executeSingleQuery( dir = parentDir , 
                                 paste0( "SELECT * from artifact WHERE md5hash ='", digest(extractedDF), "'") )[,1]
    if ( length( check ) > 0 & isForce ) {
      warning( "This artifact's data was already archived. Another archivisation executed with success.")
    }
    # archive data
    DFname <- digest(extractedDF)
    md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                             artifactName = DFname, archiveTags = FALSE, force = isForce,
                             ascii = ASCII, archiveSessionInfo = FALSE, silent = TRUE)
    addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
    return( md5hashDF )
  }else{
    warning(paste0("Could not find data ", as.character( ( object$call ) )[3], 
                   ". Dataset was not archived.")) 
  }
}

extractData.trellis <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  if (exists(as.character( ( object$call ) )[3], envir = parent.frame(1) )){
  extractedDF <- get( as.character( object$call )[3], envir = parent.frame(1) )
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", digest(extractedDF), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- digest(extractedDF)
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           artifactName = DFname, archiveTags = FALSE, force = isForce,
                           ascii = ASCII, archiveSessionInfo = FALSE, silent = TRUE)
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
  }else{
    warning(paste0("Could not find data ", as.character( ( object$call ) )[3], 
    ". Dataset was not archived."))
  }
}

extractData.twins <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  # agnes / diana / mona inherits after twins
  extractedDF <- object$data
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", digest(extractedDF), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- digest(extractedDF)
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           artifactName = DFname, archiveTags = FALSE, force = isForce, ascii = ASCII,
                           archiveSessionInfo = FALSE, silent = TRUE)
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}

extractData.partition <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  # pam / clara / fanny inherits after partition
  extractedDF <- object$data
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", digest(extractedDF), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- digest(extractedDF)
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           artifactName = DFname, archiveTags = FALSE, force = isForce, ascii = ASCII,
                           archiveSessionInfo = FALSE, silent = TRUE)
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}

extractData.qda <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  if (exists(as.character( ( object$call ) )[2], envir = parent.frame(1) )){
  extractedDF <-  get( as.character( ( object$call ) )[2], envir = parent.frame(1) )
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", digest(extractedDF), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- digest(extractedDF)
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           artifactName = DFname, archiveTags = FALSE, force = isForce, ascii = ASCII,
                           archiveSessionInfo = FALSE, silent = TRUE)
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
  }else{
    warning(paste0("Could not find data ", as.character( ( object$call ) )[2], 
                   ". Dataset was not archived."))  
  }
}


extractData.glmnet <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  # elmet / lognet / multnet /foshnet /coxnet /mrelnet 
                   # inherits after glmnet
  if (exists(as.character( ( object$call ) )[3], envir = parent.frame(1) ) & 
        exists(as.character( ( object$call ) )[2], envir = parent.frame(1) )){
  extractedDF1 <- get( as.character( object$call )[2], envir = parent.frame(1) )
  extractedDF2 <- get( as.character( object$call )[3], envir = parent.frame(1) )
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", digest(c( extractedDF1, extractedDF1 )), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- digest(c( extractedDF1, extractedDF1 ))
  md5hashDF <- saveToRepo( c( extractedDF1, extractedDF1 ), archiveData = FALSE, 
                           repoDir = parentDir, artifactName = DFname,
                           archiveTags = FALSE, 
                           force = isForce, ascii = ASCII, archiveSessionInfo = FALSE, silent = TRUE )
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
  }else{
    warning(paste0("Could not find data ", as.character( ( object$call ) )[3], 
                   " or ", as.character( ( object$call ) )[2], 
                   ". Dataset was not archived.")) 
  }
}

extractData.survfit <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  if (exists(as.character( ( object$call ) )[3], envir = parent.frame(1) )){
  extractedDF <-  get( as.character( object$call )[3], envir = parent.frame(1) )
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", digest(extractedDF), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- digest(extractedDF)
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir, 
                           artifactName = DFname, archiveTags = FALSE, force = isForce, ascii = ASCII,
                           archiveSessionInfo = FALSE, silent = TRUE)
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
  }else{
    warning(paste0("Could not find data ", as.character( ( object$call ) )[3], 
                   ". Dataset was not archived."))  
  }
}


