##    archivist package for R
##
#' @title Load Artifact Given as a md5hash from a Repository
#'
#' @description
#' \code{loadFromLocalRepo} loads an artifact from a local \link{Repository} into the workspace.
#' \code{loadFromRemoteRepo} loads an artifact from a github / git / mercurial \link{Repository} into the workspace.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' Functions \code{loadFromLocalRepo} and \code{loadFromRemoteRepo} load artifacts from the archivist Repositories 
#' stored in a local folder or on git. Both of them take \code{md5hash} as a
#' parameter, which is a result of \link{saveToRepo} function.
#' For each artifact, \code{md5hash} is a unique string of length 32 that is produced by
#' \link[digest]{digest} function, which uses a cryptographical MD5 hash algorithm. For more information see \link{md5hash}.
#' 
#' Important: instead of giving the whole \code{md5hash} character, the user can simply give first few characters of the \code{md5hash}.
#' For example, \code{a09dd} instead of \code{a09ddjdkf9kj33dcjdnfjgos9jd9jkcv}. All artifacts with the same \code{md5hash} 
#' abbreviation will be loaded from \link{Repository}.
#' 
#' Note that \code{user} and \code{repo} should be used only when working with a git repository and should be omitted in the local mode. 
#' \code{repoDir} should only be used when working on a local Repository and should be omitted in the git mode.
#' 
#' One may notice that \code{loadFromRemoteRepo} and \code{loadFromLocalRepo} load artifacts to the Global
#' Environment with their original names. Alternatively,
#' a parameter \code{value = TRUE} can be specified so that these functions may return artifacts as a value. As a result loaded artifacts
#' can be attributed to new names. Note that, when an abbreviation of \code{md5hash} was given then a list of artifacts corresponding to this
#' abbreviation will be loaded.
#' 
#' @note
#' You can specify one \code{md5hash} (or its abbreviation) per function call. 
#' 
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in Remote mode then global parameters
#' set in \link{setRemoteRepo} function are used.
#' 
#' You should remember while using \code{loadFromRepo} wrapper that \code{repoDir} is
#' a parameter used only in \code{loadFromLocalRepo} while \code{repo}, \code{user},
#' \code{branch} and \code{subdir} are used only in \code{loadFromRemoteRepo}. When you mix those
#' parameters you will receive an error message.
#' 
#' @param repoType A character containing a type of the remote repository. Currently it can be 'Remote' or 'bitbucket'.
#' 
#' @param repoDir A character denoting an existing directory from which an artifact will be loaded.
#' 
#' @param md5hash A character assigned to the artifact through the use of a cryptographical hash function with MD5 algorithm, or it's abbreviation.
#' 
#' @param repo While working with a Remote repository. A character containing a name of a Remote repository on which the Repository is archived.
#' By default set to \code{NULL} - see \code{Note}.
#' @param user While working with a Remote repository. A character containing a name of a Remote user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}. 
#' @param branch While working with a Remote repository. A character containing a name of 
#' Remote Repository's branch on which the Repository is archived. Default \code{branch} is \code{master}.
#' 
#' @param subdir While working with a Remote repository. A character containing a name of a directory on Remote repository 
#' on which the Repository is stored. If the Repository is stored in main folder on Remote repository, this should be set 
#' to \code{subdir = "/"} as default.
#' 
#' @param value If \code{FALSE} (default) then artifacts are loaded into the Global Environment with their original names, 
#' if \code{TRUE} then artifacts are returned as a list of values (if there is more than one artifact)
#' or as a single value (if there is only one arfifact that matches md5hash).
#' 
#' @author 
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#'  
#' @examples
#' 
#' \dontrun{
#' # objects preparation
#' 
#' #' exampleRepoDir <- tempfile()
#' createLocalRepo(repoDir = exampleRepoDir)
#' data(iris)
#' saveToLocalRepo(iris, repoDir=exampleRepoDir, archiveSessionInfo = TRUE)
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' loadFromLocalRepo(md5hash = 'f05f0ed0662fe01850ec1b928830ef32',
#'   repoDir = system.file("graphGallery", package = "archivist"), value = TRUE) -> pl
#' deleteLocalRepo(exampleRepoDir, TRUE)
#' rm(exampleRepoDir)
#' 
#' 
#' #
#' #Remote Version
#' #
#' 
#' # check the state of the Repository
#' summaryRemoteRepo( user="pbiecek", repo="archivist" )
#' showRemoteRepo( user="pbiecek", repo="archivist" )
#' showRemoteRepo( user="pbiecek", repo="archivist", method = "tags" )
#' 
#' rm( model )
#' rm( myplot123 )
#' rm( qda1 )
#' (VARmd5hash <- searchInRemoteRepo( "varname:Sepal.Width", 
#'                    user="pbiecek", repo="archivist" ))
#' (NAMEmd5hash <- searchInRemoteRepo( "name:qda1", 
#'                    user="pbiecek", repo="archivist", branch="master" ))
#' (CLASSmd5hash <- searchInRemoteRepo( "class:ggplot", 
#'                    user="pbiecek", repo="archivist", branch="master" ))
#' 
#' 
#' loadFromRemoteRepo( "ff575c261c", user="pbiecek", repo="archivist")
#' NewObjects <- loadFromRemoteRepo( NAMEmd5hash, user="pbiecek", repo="archivist", value = TRUE )
#' loadFromRemoteRepo( CLASSmd5hash, user="pbiecek", repo="archivist")
#' 
#' 
#' ## Loading artifacts from the repository which is built in the archivist package 
#' ## and saving them on the example repository
#' 
#' # Creating an example Repository - on which artifacts loaded from the
#' # archivist package repository will be saved
#' exampleRepoDir <- tempfile()
#' createLocalRepo(repoDir = exampleRepoDir)
#' 
#' # Directory of the archivist package repository
#' repo_archivist <- system.file("graphGallery", package = "archivist") 
#' 
#' # We are checking what kind of objects
#' # are stored in the archivist package repository
#' summaryLocalRepo(repoDir = repo_archivist)
#' 
#' # Let's say that we are interested in 
#' # an artifact of class ggplot.
#' GGPLOTmd5hash <- searchInLocalRepo(pattern = "class:ggplot",
#'                                    repoDir = repo_archivist) 
#' # There are eight of them.
#' # We load the first one by its value (parameter value = TRUE)
#' # and assign it to the p variable.
#' p <- loadFromLocalRepo(GGPLOTmd5hash[1], repoDir = repo_archivist,
#'                        value = TRUE)
#' 
#' # Finally, we may save the artifact on the example Repository.
#' # Note that md5hash is different from the one which is stored in
#' # the archivist package repository.
#' saveToRepo(p, repoDir = exampleRepoDir) 
#' 
#' # Making sure that the artifact is stored on the example repository
#' showLocalRepo(repoDir = exampleRepoDir, method = "tags")
#' 
#' # removing an example Repository
#' 
#' deleteLocalRepo( exampleRepoDir, TRUE)
#' 
#' rm( exampleRepoDir )
#' 
#' # many archivist-like Repositories on one Remote repository
#' 
#' loadFromRemoteRepo( "ff575c261c949d073b2895b05d1097c3", 
#' user="MarcinKosinski", repo="Museum", branch="master", subdir="ex2")
#' 
#' 
#' loadFromRemoteRepo( "ff575c261c949d073b2895b05d1097c3", 
#'                     user="MarcinKosinski", repo="Museum", branch="master",
#'                     subdir="ex1")
#'                     
#' #github
#' loadFromRemoteRepo(md5hash = "08dc0b66975cded92b5cd8291ebdc955", 
#'                repo = "graphGallery", user = "pbiecek", 
#'                repoType = "github", value = TRUE)
#'            
#' #git
#' loadFromRemoteRepo(md5hash = "08dc0b66975cded92b5cd8291ebdc955", 
#'                repo = "graphGalleryGit", user = "pbiecek", 
#'                repoType = "bitbucket", value = TRUE)
#' 
#' # mercurial               
#' loadFromRemoteRepo(md5hash = "08dc0b66975cded92b5cd8291ebdc955", 
#'                repo = "graphGalleryM", user = "pbiecek", 
#'                repoType = "bitbucket", value = TRUE)
#' }
#' @family archivist
#' @rdname loadFromRepo
#' @export
loadFromLocalRepo <- function( md5hash, repoDir = aoptions('repoDir'), value = FALSE ){
  stopifnot( is.character( md5hash ), length( md5hash ) == 1 )
  stopifnot( is.character( repoDir ) & length( repoDir ) == 1) 
  stopifnot( is.logical( value ) )
  
  repoDir <- checkDirectory( repoDir )
  
  # what if abbreviation was given
  if ( nchar( md5hash ) < 32 ){
        
    md5hashList <- executeSingleQuery( dir = repoDir , 
                               paste0( "SELECT DISTINCT artifact FROM tag WHERE artifact LIKE '",md5hash,"%'" ) )
    md5hash <- as.character( md5hashList[, 1] )
  }
  
  # using sapply in case abbreviation mode found more than 1 md5hash
  if ( !value ) {
    sapply( md5hash, function(x) {
      load( file = file.path( repoDir, "gallery", paste0(x, ".rda" )), envir = .GlobalEnv )
    } )
  }else{
    .nameEnv <- new.env()
    name <- character( length = length( md5hash ) )
    for( i in seq_along( md5hash ) ) {
      name[i] <- load( file = file.path( repoDir, "gallery", paste0(md5hash[i], ".rda") ), 
                       envir = .nameEnv ) 
      }
    if ( length( name ) == 1) {
      return( as.list(.nameEnv)[[1]] )
    } else {
      return( as.list(.nameEnv) )
    }
  }
}

#' @rdname loadFromRepo
#' @export
loadFromRemoteRepo <- function( md5hash, repo = aoptions("repo"), user = aoptions("user"), branch = aoptions("branch"), subdir = aoptions("subdir"),
                                repoType = aoptions("repoType"), value = FALSE ){
  stopifnot( is.character( c( md5hash, branch ) ), length( md5hash ) == 1, length( branch ) == 1 )
  stopifnot( is.logical( value ) )
  
  RemoteRepoCheck( repo, user, branch, subdir, repoType) # implemented in setRepo.R
  
  remoteHook <- getRemoteHook(repo=repo, user=user, branch=branch, subdir=subdir, repoType=repoType)
  
  # what if abbreviation was given
  if ( nchar( md5hash ) < 32 ){
    # database is needed to be downloaded
    Temp <- downloadDB( remoteHook )
      
    md5hashList <- executeSingleQuery( dir = Temp, 
                                       paste0( "SELECT DISTINCT artifact FROM tag WHERE artifact LIKE '",md5hash,"%'" ) )
    md5hash <- as.character( md5hashList[, 1] )
    
    unlink( Temp, recursive = TRUE, force = TRUE)
  }
      
  # load artifacts from Repository
  if ( !value ){
    
    # sapply and replicate because of abbreviation mode can find more than 1 md5hash
    tmpobjectS <- lapply( md5hash, function(x){
      getBinaryURL( file.path( remoteHook, "gallery", paste0(x, ".rda") ) )  } )  

    tfS <- replicate( length( md5hash ), tempfile() )
        
    for (i in seq_along( tfS )){
      writeBin( tmpobjectS[[i]], tfS[i] )
      load( file = tfS[i] , envir =.GlobalEnv)
    } 
    

  }else{
    # returns objects as value

    # sapply and replicate because of abbreviation mode can find more than 1 md5hash
    tmpobjectS <- lapply( md5hash, function(x){
        getBinaryURL( file.path( remoteHook, "gallery", paste0(x, ".rda") ) )  } )  

    tfS <- replicate( length( md5hash ), tempfile() )
    
    for (i in seq_along(tmpobjectS)){
      writeBin( tmpobjectS[[i]], tfS[i] )
    }
    # in case there existed an object in GlobalEnv this function will not delete him
    .nameEnv <- new.env()
    name <- character( length = length( md5hash ) )
    for( i in seq_along( md5hash ) ) {
      name[i] <- load( file =  tfS[i] , 
                       envir = .nameEnv ) 
    }
    if (length(name) == 1) {
      return(as.list(.nameEnv)[[1]])
    } else {
      return(as.list(.nameEnv))
  }
}
}

