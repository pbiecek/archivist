##    archivist package for R
##
#' @title Copy an Existing Repository into Another Repository
#' 
#' @description
#' \code{copy*Repo} copies artifacts from one \code{Repository} into another \code{Repository}.
#' It adds new files to existing \code{gallery} folder in \code{repoTo} \code{Repository}.
#' \code{copyLocalRepo} copies local \code{Repository} while \code{copyRemoteRepo} copies
#' remote \code{Repository}. 
#' 
#' @details
#' Functions \code{copyLocalRepo} and \code{copyRemoteRepo} copy artifacts from the
#' archivist's Repositories stored in a local folder or on the Remote. 
#' Both of them use \code{md5hashes} of artifacts which are to be copied 
#' in \code{md5hashes} parameter. For more information about \code{md5hash} see \link{md5hash}.
#'
#' @param repoType A character containing a type of the remote repository. Currently it can be 'Remote' or 'bitbucket'.
#' @param repoFrom While copying local repository. A character that specifies
#' the directory of the Repository from which
#' artifacts will be copied. If it is set to \code{NULL} (by default),
#' it will use the \code{repoDir} specified in \link{setLocalRepo}.
#'
#' @param repoTo A character that specifies the directory of the Repository into which
#' artifacts will be copied.
#' 
#' @param md5hashes A character vector containing \code{md5hashes} of artifacts to be copied. 
#' 
#' @param repo While coping the remote repository. A character containing a name of the
#' remote repository on which the "\code{repoFrom}" - Repository is archived.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param user While coping the remote repository. A character containing a name
#' of the remote user on whose account the "\code{repoFrom}" - Repository is created.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param branch While coping with the remote repository. A character containing a name of 
#' Remote Repository's branch on which the "\code{repoFrom}" - Repository is archived.
#' Default \code{branch} is \code{master}.
#'
#' @param subdir While working with the remote repository. A character containing a name of
#' a directory on the remote repository on which the "\code{repoFrom}" - Repository is stored.
#' If the Repository is stored in the main folder on the remote repository, this should be set 
#' to \code{FALSE} as default.
#' 
#' @note
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in remote mode then global parameters
#' set in \link{setRemoteRepo} function are used. If one would like to copy whole Repository we suggest to 
#' extract all \code{md5hashes} in this way \code{unique(showLocalRepo(repoDir)[,1])}.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#'
#' 
#' ## Using archivist remote Repository to copy artifacts
#' # creating example Repository
#'  
#' exampleRepoDir <- tempfile()
#' createLocalRepo( exampleRepoDir )
#' 
#' # Searching for md5hashes of artifacts (without data related to them)
#' # in the archivist remote  Repository
#' hashes <- searchInRemoteRepo( pattern="name", user="pbiecek", repo="archivist", fixed=FALSE )
#' 
#' # Copying selected artifacts from archivist Remote  Repository into exampleRepoDir Repository
#'
#' copyRemoteRepo( repoTo = exampleRepoDir , md5hashes= hashes, user="pbiecek", repo="archivist" )
#' 
#' # See how the gallery folder in our exampleRepoDir Repository
#' # with copies of artifacts from archivist Remote  Repository looks like
#' list.files( path = file.path( exampleRepoDir, "gallery" ) )
#'
#' # See how the backpack database in our exampleRepoDir Repository looks like
#' showLocalRepo( repoDir = exampleRepoDir )
#'
#' # removing an example Repository
#' 
#' deleteLocalRepo( exampleRepoDir, deleteRoot=TRUE )
#' 
#' rm( exampleRepoDir )
#' 
#' # many archivist-like Repositories on one Remote repository
#' 
#' dir <- paste0(getwd(), "/ex1")
#' createLocalRepo( dir )
#' copyRemoteRepo( repoTo = dir , md5hashes = "ff575c261c949d073b2895b05d1097c3",
#'                 user="MarcinKosinski", repo="Museum",
#'                 branch="master", subdir="ex2")
#'                 
#' # Check if the copied artifact is on our dir Repository
#'
#' showLocalRepo( repoDir = dir) # It is in backpack database indeed
#' list.files( path = file.path( dir, "gallery" ) ) # it is also in gallery folder
#'
#' # removing an example Repository
#' deleteLocalRepo( dir, TRUE)
#'
#' rm(dir)
#' 
#' ## Using graphGallery Repository attached to the archivist package to copy artifacts
#'
#' # creating example Repository
#'
#' exampleRepoDir <- tempfile()
#' createLocalRepo( exampleRepoDir )
#'
#' # Searching for md5hashes of artifacts (without data related to them)
#' # in the graphGallery  Repository
#' archivistRepo <- system.file( "graphGallery", package = "archivist")
#' # You may use: 
#' # hashes <- unique(showLocalRepo(repoDir)[,1]) 
#' # to extract all artifacts from repository
#' hashes <- searchInLocalRepo( pattern="name",
#'                              repoDir =  archivistRepo,
#'                              fixed=FALSE )
#' 
#' # Copying selected artifacts from archivist Remote  Repository into exampleRepoDir Repository
#'
#' copyLocalRepo( repoFrom = archivistRepo, repoTo = exampleRepoDir , md5hashes= hashes )
#'
#' # See how the backpack database in our exampleRepoDir Repository looks like
#' showLocalRepo( repoDir = exampleRepoDir )
#' 
#' # removing an example Repository
#' 
#' deleteLocalRepo( exampleRepoDir, deleteRoot=TRUE )
#' 
#' rm( exampleRepoDir )
#' rm( archivistRepo )
#' 
#' }
#' 
#' 
#' @family archivist
#' @rdname copyToRepo
#' @export
copyLocalRepo <- function( repoFrom = NULL, repoTo, md5hashes ){
 stopifnot( (is.character( repoFrom ) & length( repoFrom ) == 1) | is.null( repoFrom ) )
 stopifnot( is.character( c( repoTo, md5hashes ) ), length( repoTo ) == 1, length( md5hashes ) > 0 )
 
 repoFrom <- checkDirectory( repoFrom )
 repoTo <- checkDirectory( repoTo )
 
 copyRepo( repoFrom = repoFrom, repoTo = repoTo, md5hashes = md5hashes )
 invisible(NULL)
}


#' @rdname copyToRepo
#' @export
copyRemoteRepo <- function( repoTo, md5hashes, repo = aoptions("repo"), user = aoptions("user"), branch = aoptions("branch"), subdir = aoptions("subdir"),
                            repoType = aoptions("repoType")){
  stopifnot( is.character( c( repoTo, branch, md5hashes ) ),
             length(repoTo) == 1, length(branch) == 1, length(md5hashes) > 0)

  RemoteRepoCheck( repo, user, branch, subdir, repoType) # implemented in setRepo.R
  
  repoTo <- checkDirectory( repoTo )
  
  remoteHook <- getRemoteHook(repo=repo, user=user, branch=branch, subdir=subdir, repoType=repoType)
  Temp <- downloadDB( remoteHook )
  
  on.exit( unlink( Temp, recursive = TRUE, force = TRUE))
  
  copyRepo( repoTo = repoTo, repoFrom = Temp, md5hashes = md5hashes , 
            local = FALSE, user = user, repo = repo, branch = branch, subdir = subdir )  
  
  invisible(NULL)  
}

copyRepo <- function( repoFrom, repoTo, md5hashes, local = TRUE, user, repo, branch, subdir ){
  # clone artifact table
  toInsertArtifactTable <- executeSingleQuery( dir = repoFrom, 
                      paste0( "SELECT DISTINCT * FROM artifact WHERE md5hash IN ",
                             "('", paste0( md5hashes, collapse="','"), "')" ) ) 
  
  apply( toInsertArtifactTable, 1, function(x){
         executeSingleQuery( dir = repoTo, 
                              paste0( "INSERT INTO artifact (md5hash, name, createdDate) VALUES ('",
                              x[1], "','",
                              x[2], "','",
                              x[3], "')" ) ) } )
  # clone tag table
  toInsertTagTable <- executeSingleQuery( dir = repoFrom,
                                               paste0( "SELECT DISTINCT * FROM tag WHERE artifact IN ",
                                                       "('", paste0( md5hashes, collapse="','"), "')" ) ) 
  apply( toInsertTagTable, 1, function(x){
    executeSingleQuery( dir = repoTo, 
                        paste0( "INSERT INTO tag (artifact, tag, createdDate) VALUES ('",
                                x[1], "','",
                                x[2], "','",
                                x[3], "')" ) ) } )
  if ( local ){
  # clone files
  
  whichToClone <- unlist( sapply( md5hashes, function(x){
    which( x == sub( list.files( file.path( repoFrom,"gallery" ) ), pattern = "\\.[a-z]{3}", 
                     replacement="" ) ) 
  } ) )
  
  filesToClone <- list.files( file.path( repoFrom,"gallery" ) )[whichToClone]
  sapply( filesToClone, function(x){
    file.copy( from = file.path(repoFrom, "gallery", x), to = file.path( repoTo, "gallery" ),
          recursive = TRUE )})
  } else {
    # if Remote mode
    # get files list
    options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

    req <- GET( paste0( "https://api.github.com/repos/", user, "/",
                        repo, "/git/trees/", branch, "?recursive=1" ) )

    stop_for_status(req)
    
    filelist <- unlist(lapply(content(req)$tree, "[", "path"), use.names = F)
    
    if( subdir == "/" ){
      whichFilesToClone <- grep("gallery/", filelist, value = TRUE, fixed = TRUE)
      needTidy <- strsplit(whichFilesToClone, "gallery/")
      whichFilesToClone <- unlist(lapply(needTidy, function(x){
        file.path("gallery", x[2])
      }))
    }else{
      whichFilesToClone <- grep(paste0(subdir,"/gallery/"), filelist, 
                                value = TRUE, fixed = TRUE)
    }
    
    filesToDownload <- unlist(as.vector(sapply( md5hashes, function(x){
      grep(pattern = x, whichFilesToClone, value = TRUE, fixed = TRUE)
    } ) ) ) #choose proper files from whole file list -whichFilesToClone
    
    # download files to gallery folder
    lapply( filesToDownload, cloneRemoteFile, repo = repo, user = user, branch = branch, 
            to = repoTo, subdir )
  }
  invisible(NULL)
}

cloneRemoteFile <- function( file, repo, user, branch, to, subdir ){

    URLfile <- file.path( get( ".GithubURL", envir = .ArchivistEnv) , 
                       user, repo, branch, file) 
    # tidy
    if (  subdir != "/" ){
      file <- paste0( "gallery/", strsplit(file, "gallery/")[[1]][2] )
    }
    
    fileFromRemote <- getBinaryURL( URLfile )
    
    file.create( file.path( to, file ) )
    writeBin( fileFromRemote, file.path( to, file ) )
    #files contain "gallery/" in it's name
    
  }


