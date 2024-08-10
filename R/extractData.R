#' Internal function for extraction of data from objects
#'
#' @param object for this object data is to be extracted
#' @param parrentMd5hash hash of the parent object
#' @param parentDir parent dir
#' @param isForce should the data extraction be forced
#' @param ASCII shall it be written in ASCII friendly format
#' 
#' @rdname extractData
#' @export extractData

extractData <- function( object, parrentMd5hash, parentDir, isForce, ASCII )
  UseMethod( "extractData" )

#' @return \code{NULL}
#'
#' @rdname extractData
#' @method extractData default

extractData.default <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  
}

#' @return \code{NULL}
#'
#' @rdname extractData
#' @method extractData ggplot

extractData.ggplot <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  extractedDF <- object$data
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", adigest(extractedDF), "'") )[,1]
    if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- adigest(extractedDF)
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir, 
                           artifactName = DFname, archiveTags = FALSE, force = isForce, ascii = ASCII,
                           archiveSessionInfo = FALSE, silent = TRUE)
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}

#' @return \code{NULL}
#'
#' @rdname extractData
#' @method extractData lm

extractData.lm <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  extractedDF <- object$model
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", adigest(extractedDF), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- adigest(extractedDF)
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           artifactName = DFname, archiveTags = FALSE, force = isForce, ascii = ASCII,
                           archiveSessionInfo = FALSE, silent = TRUE)
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}

#' @return \code{NULL}
#'
#' @rdname extractData
#' @method extractData htest

extractData.htest <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  if (exists(strsplit(object$data.name, " and ")[[1]][1], envir = parent.frame(1)) &
        exists(strsplit(object$data.name, " and ")[[1]][2], envir = parent.frame(1)) ){
  extractedDF1 <- get( strsplit(object$data.name, " and ")[[1]][1], envir = parent.frame(1) )
  extractedDF2 <- get( strsplit(object$data.name, " and ")[[1]][2], envir = parent.frame(1) )
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", adigest(list( extractedDF1, extractedDF2 )), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- adigest(list( extractedDF1, extractedDF2 ))
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

#' @return \code{NULL}
#'
#' @rdname extractData
#' @method extractData lda

extractData.lda <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  if (exists(as.character( ( object$call ) )[3], envir = parent.frame(1) )){
    extractedDF <-  get( as.character( ( object$call ) )[3], envir = parent.frame(1) )
    # check if that artifact might have been already archived
    check <- executeSingleQuery( dir = parentDir , 
                                 paste0( "SELECT * from artifact WHERE md5hash ='", adigest(extractedDF), "'") )[,1]
    if ( length( check ) > 0 & isForce ) {
      warning( "This artifact's data was already archived. Another archivisation executed with success.")
    }
    # archive data
    DFname <- adigest(extractedDF)
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

#' @return \code{NULL}
#'
#' @rdname extractData
#' @method extractData trellis

extractData.trellis <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  if (exists(as.character( ( object$call ) )[3], envir = parent.frame(1) )){
  extractedDF <- get( as.character( object$call )[3], envir = parent.frame(1) )
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", adigest(extractedDF), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- adigest(extractedDF)
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

#' @return \code{NULL}
#'
#' @rdname extractData
#' @method extractData twins

extractData.twins <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  # agnes / diana / mona inherits after twins
  extractedDF <- object$data
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", adigest(extractedDF), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- adigest(extractedDF)
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           artifactName = DFname, archiveTags = FALSE, force = isForce, ascii = ASCII,
                           archiveSessionInfo = FALSE, silent = TRUE)
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}

#' @return \code{NULL}
#'
#' @rdname extractData
#' @method extractData partition

extractData.partition <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  # pam / clara / fanny inherits after partition
  extractedDF <- object$data
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", adigest(extractedDF), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- adigest(extractedDF)
  md5hashDF <- saveToRepo( extractedDF, archiveData = FALSE, repoDir = parentDir,
                           artifactName = DFname, archiveTags = FALSE, force = isForce, ascii = ASCII,
                           archiveSessionInfo = FALSE, silent = TRUE)
  addTag( tag = paste0("relationWith:", parrentMd5hash), md5hash = md5hashDF, dir = parentDir )
  return( md5hashDF )
}

#' @return \code{NULL}
#'
#' @rdname extractData
#' @method extractData qda

extractData.qda <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  if (exists(as.character( ( object$call ) )[2], envir = parent.frame(1) )){
  extractedDF <-  get( as.character( ( object$call ) )[2], envir = parent.frame(1) )
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", adigest(extractedDF), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- adigest(extractedDF)
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

#' @return \code{NULL}
#'
#' @rdname extractData
#' @method extractData glmnet

extractData.glmnet <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  # elmet / lognet / multnet /foshnet /coxnet /mrelnet 
                   # inherits after glmnet
  if (exists(as.character( ( object$call ) )[3], envir = parent.frame(1) ) & 
        exists(as.character( ( object$call ) )[2], envir = parent.frame(1) )){
  extractedDF1 <- get( as.character( object$call )[2], envir = parent.frame(1) )
  extractedDF2 <- get( as.character( object$call )[3], envir = parent.frame(1) )
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", adigest(c( extractedDF1, extractedDF1 )), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- adigest(c( extractedDF1, extractedDF1 ))
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

#' @return \code{NULL}
#'
#' @rdname extractData
#' @method extractData survfit

extractData.survfit <- function( object, parrentMd5hash, parentDir, isForce, ASCII ){
  if (exists(as.character( ( object$call ) )[3], envir = parent.frame(1) )){
  extractedDF <-  get( as.character( object$call )[3], envir = parent.frame(1) )
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = parentDir , 
                               paste0( "SELECT * from artifact WHERE md5hash ='", adigest(extractedDF), "'") )[,1]
  if ( length( check ) > 0 & isForce ) {
    warning( "This artifact's data was already archived. Another archivisation executed with success.")
  }
  # archive data
  DFname <- adigest(extractedDF)
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


