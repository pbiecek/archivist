##    archivist package for R
##
#' @title Copy an Existing Repository into Another Repository
#' 
#' @description
#' \code{copy*Repo} copies artifacts from one \code{Repository} into another \code{Repository}.
#' It adds new files to existing \code{gallery} folder in \code{repoTo} \code{Repository}.
#' \code{copyLocalRepo} copies local \code{Repository} while \code{copyGithubRepo} copies
#' Github \code{Repository}. 
#' 
#' @details
#' Functions \code{copyLocalRepo} and \code{copyGithubRepo} copy artifacts from the
#' archivist's Repositories stored in a local folder or on the Github. 
#' Both of them use \code{md5hashes} of artifacts which are to be copied 
#' in \code{md5hashes} parameter. For more information about \code{md5hash} see \link{md5hash}.
#'
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
#' @param repo While coping the Github repository. A character containing a name of the
#' Github repository on which the "\code{repoFrom}" - Repository is archived.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param user While coping the Github repository. A character containing a name
#' of the Github user on whose account the "\code{repoFrom}" - Repository is created.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param branch While coping with the Github repository. A character containing a name of 
#' Github Repository's branch on which the "\code{repoFrom}" - Repository is archived.
#' Default \code{branch} is \code{master}.
#'
#' @param repoDirGit While working with the Github repository. A character containing a name of
#' a directory on the Github repository on which the "\code{repoFrom}" - Repository is stored.
#' If the Repository is stored in the main folder on the Github repository, this should be set 
#' to \code{FALSE} as default.
#' 
#' @note
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in Github mode then global parameters
#' set in \link{setGithubRepo} function are used. If one would like to copy whole Repository we suggest to 
#' extract all \code{md5hashes} in this way \code{unique(showLocalRepo(repoDir)[,1])}.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#'
#' 
#' ## Using archiviist Github Repository to copy artifacts
#' # creating example Repository
#'  
#' exampleRepoDir <- tempfile()
#' createEmptyRepo( exampleRepoDir )
#' 
#' # Searching for md5hashes of artifacts (without data related to them)
#' # in the archivist Github  Repository
#' hashes <- searchInGithubRepo( pattern="name", user="pbiecek", repo="archivist", fixed=FALSE )
#' 
#' # Copying selected artifacts from archivist Github  Repository into exampleRepoDir Repository
#'
#' copyGithubRepo( repoTo = exampleRepoDir , md5hashes= hashes, user="pbiecek", repo="archivist" )
#' 
#' # See how the gallery folder in our exampleRepoDir Repository
#' # with copies of artifacts from archivist Github  Repository looks like
#' list.files( path = file.path( exampleRepoDir, "gallery" ) )
#'
#' # See how the backpack database in our exampleRepoDir Repository looks like
#' showLocalRepo( repoDir = exampleRepoDir )
#'
#' # removing an example Repository
#' 
#' deleteRepo( exampleRepoDir, deleteRoot=TRUE )
#' 
#' rm( exampleRepoDir )
#' 
#' # many archivist-like Repositories on one Github repository
#' 
#' dir <- paste0(getwd(), "/ex1")
#' createEmptyRepo( dir )
#' copyGithubRepo( repoTo = dir , md5hashes = "ff575c261c949d073b2895b05d1097c3",
#'                 user="MarcinKosinski", repo="Museum",
#'                 branch="master", repoDirGit="ex2")
#'                 
#' # Check if the copied artifact is on our dir Repository
#'
#' showLocalRepo( repoDir = dir) # It is in backpack database indeed
#' list.files( path = file.path( dir, "gallery" ) ) # it is also in gallery folder
#'
#' # removing an example Repository
#' deleteRepo( dir, TRUE)
#'
#' rm(dir)
#' 
#' ## Using graphGallery Repository attached to the archivist package to copy artifacts
#'
#' # creating example Repository
#'
#' exampleRepoDir <- tempfile()
#' createEmptyRepo( exampleRepoDir )
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
#' # Copying selected artifacts from archivist Github  Repository into exampleRepoDir Repository
#'
#' copyLocalRepo( repoFrom = archivistRepo, repoTo = exampleRepoDir , md5hashes= hashes )
#'
#' # See how the backpack database in our exampleRepoDir Repository looks like
#' showLocalRepo( repoDir = exampleRepoDir )
#' 
#' # removing an example Repository
#' 
#' deleteRepo( exampleRepoDir, deleteRoot=TRUE )
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
copyGithubRepo <- function( repoTo, md5hashes, user = NULL, repo = NULL, branch="master", 
                            repoDirGit = FALSE){
  stopifnot( is.character( c( repoTo, branch, md5hashes ) ),
             length(repoTo) == 1, length(branch) == 1, length(md5hashes) > 0)

  GithubCheck( repo, user, repoDirGit ) # implemented in setRepo.R
  
  repoTo <- checkDirectory( repoTo )
  
  Temp <- downloadDB( repo, user, branch, repoDirGit )
  
  on.exit(file.remove(Temp))
  
  copyRepo( repoTo = repoTo, repoFrom = Temp, md5hashes = md5hashes , 
            local = FALSE, user = user, repo = repo, branch = branch, repoDirGit = repoDirGit )  
  
  invisible(NULL)  
}

copyRepo <- function( repoFrom, repoTo, md5hashes, local = TRUE, user, repo, branch, repoDirGit ){
  
  # clone artifact table
  toInsertArtifactTable <- executeSingleQuery( dir = repoFrom, realDBname = local,
                      paste0( "SELECT DISTINCT * FROM artifact WHERE md5hash IN ",
                             "('", paste0( md5hashes, collapse="','"), "')" ) ) 
  
  apply( toInsertArtifactTable, 1, function(x){
         executeSingleQuery( dir = repoTo, 
                              paste0( "INSERT INTO artifact (md5hash, name, createdDate) VALUES ('",
                              x[1], "','",
                              x[2], "','",
                              x[3], "')" ) ) } )
  # clone tag table
  toInsertTagTable <- executeSingleQuery( dir = repoFrom, realDBname = local,
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
    # if github mode
    # get files list
    options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

    req <- GET( paste0( "https://api.github.com/repos/", user, "/",
                        repo, "/git/trees/", branch, "?recursive=1" ) )

    stop_for_status(req)
    
    filelist <- unlist(lapply(content(req)$tree, "[", "path"), use.names = F)
    
    if( is.logical( repoDirGit ) ){
      whichFilesToClone <- grep("gallery/", filelist, value = TRUE, fixed = TRUE)
      needTidy <- strsplit(whichFilesToClone, "gallery/")
      whichFilesToClone <- unlist(lapply(needTidy, function(x){
        file.path("gallery", x[2])
      }))
    }else{
      whichFilesToClone <- grep(paste0(repoDirGit,"/gallery/"), filelist, 
                                value = TRUE, fixed = TRUE)
    }
    
    filesToDownload <- unlist(as.vector(sapply( md5hashes, function(x){
      grep(pattern = x, whichFilesToClone, value = TRUE, fixed = TRUE)
    } ) ) ) #choose proper files from whole file list -whichFilesToClone
    
    # download files to gallery folder
    lapply( filesToDownload, cloneGithubFile, repo = repo, user = user, branch = branch, 
            to = repoTo, repoDirGit )
  }
  invisible(NULL)
}

cloneGithubFile <- function( file, repo, user, branch, to, repoDirGit ){

    URLfile <- file.path( get( ".GithubURL", envir = .ArchivistEnv) , 
                       user, repo, branch, file) 
    # tidy
    if ( is.character( repoDirGit ) ){
      file <- paste0( "gallery/", strsplit(file, "gallery/")[[1]][2] )
    }
    
    fileFromGithub <- getBinaryURL( URLfile )
    
    file.create( file.path( to, file ) )
    writeBin( fileFromGithub, file.path( to, file ) )
    #files contain "gallery/" in it's name
    
  }


