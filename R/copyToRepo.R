##    archivist package for R
##
#' @title Copy an Existing Repository to Another Repository
#' 
#' @description
#' \code{copyRepo} copies artifact from one \code{Repository} to another \code{Repository}. It adds new files
#' to exising \code{gallery} folder in \code{repoTo} \code{Repository}. \code{copyLocalRepo} copies local \code{Repository}, where
#' \code{copyGithubRepo} copies Github \code{Repository}. 
#' 
#' @details
#' \code{copyRepo} copies artifact from one \link{Repository} to another \code{Repository}.
#' Functions \code{copyLocalRepo} and \code{copyGithubRepo} copy artifacts from the archivist Repositories stored in a local folder or 
#' on a Github. 
#' Both of them take \code{md5hash} as a parameter, which is a result from \link{saveToRepo} function.
#' For every artifacts, \code{md5hash} is a unique string of length 32 that comes out as a result of 
#' \link[digest]{digest} function, which uses a cryptographical MD5 hash algorithm. For more information see \link{md5hash}.
#' 
#'
#' @param repoFrom A character that specifies the directory of the Repository from which
#' artifacts will be copied. Works only on \code{copyLocalRepo}.
#'
#' @param repoTo A character that specifies the directory of the Repository in which
#' artifacts will be copied.
#' 
#' @param md5hashes A character or character vector containing \code{md5hashes} of artifacts to be copied.
#' 
#' @param repo Only if coping a Github repository. A character containing a name of a Github repository on which the \code{repoFrom}-Repository is archived.
#' By default set to \code{NULL} - see \code{Note}.
#' @param user Only if coping a Github repository. A character containing a name of a Github user on whose account the \code{repoFrom} is created.
#' By default set to \code{NULL} - see \code{Note}.
#' @param branch Only if coping with a Github repository. A character containing a name of 
#' Github Repository's branch on which a \code{repoFrom}-Repository is archived. Default \code{branch} is \code{master}.
#'
#' @param repoDirGit Only if working with a Github repository. A character containing a name of a directory on Github repository 
#' on which the Repository is stored. If the Repository is stored in main folder on Github repository, this should be set 
#' to \code{repoDirGit = FALSE} as default.
#' 
#' @note
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in Github mode then global parameters
#' set in \link{setGithubRepo} function are used.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#'
#' 
#' # creating example Repository - that examples will work
#' 
#' exampleRepoDir <- tempdir()
#' hashes <- searchInGithubRepo( pattern="name", user="pbiecek", repo="archivist", fixed=FALSE )
#'
#' createEmptyRepo( exampleRepoDir )
#'
#' copyGithubRepo( repoTo = exampleRepoDir , md5hashes= hashes, user="pbiecek", repo="archivist" )
#' 
#' # removing an example Repository
#'   
#' deleteRepo( exampleRepoDir )
#' 
#' rm( exampleRepoDir )
#' 
#' # many archivist-like Repositories on one Github repository
#' 
#' dir <- paste0(getwd(), "/ex1")
#' createEmptyRepo( dir )
#' copyGithubRepo(repoTo = dir , md5hashes = "ff575c261c949d073b2895b05d1097c3",
#'               user="MarcinKosinski", repo="Museum", 
#'               branch="master", repoDirGit="ex2")
#' deleteRepo( dir )
#' 
#' }
#' 
#' 
#' @family archivist
#' @rdname copyToRepo
#' @export
copyLocalRepo <- function( repoFrom, repoTo, md5hashes ){
 stopifnot( is.character( c( repoFrom, repoTo, md5hashes ) ) )
 
 repoFrom <- checkDirectory( repoFrom )
 repoTo <- checkDirectory( repoTo )
 
 copyRepo( repoFrom = repoFrom, repoTo = repoTo, md5hashes = md5hashes )
}


#' @rdname copyToRepo
#' @export
copyGithubRepo <- function( repoTo, md5hashes, user = NULL, repo = NULL, branch="master", 
                            repoDirGit = FALSE){
  stopifnot( is.character( c( repoTo, branch, md5hashes ) ) )

  GithubCheck( repo, user, repoDirGit ) # implemented in setRepo.R
  
  repoTo <- checkDirectory( repoTo )
  
  Temp <- downloadDB( repo, user, branch, repoDirGit )
  
  copyRepo( repoTo = repoTo, repoFrom = Temp, md5hashes = md5hashes , 
            local = FALSE, user = user, repo = repo, branch = branch, repoDirGit = repoDirGit )  
  file.remove(Temp)
  
}

copyRepo <- function( repoFrom, repoTo, md5hashes, local = TRUE, user, repo, branch, repoDirGit ){
  
  # clone artifact table
  toInsertArtifactTable <- executeSingleQuery( dir = repoFrom, realDBname = local,
                      paste0( "SELECT * FROM artifact WHERE md5hash IN ",
                             "('", paste0( md5hashes, collapse="','"), "')" ) ) 
  
  apply( toInsertArtifactTable, 1, function(x){
         executeSingleQuery( dir = repoTo, 
                              paste0( "INSERT INTO artifact (md5hash, name, createdDate) VALUES ('",
                              x[1], "','",
                              x[2], "','",
                              x[3], "')" ) ) } )
  # clone tag table
  toInsertTagTable <- executeSingleQuery( dir = repoFrom, realDBname = local,
                                               paste0( "SELECT * FROM tag WHERE artifact IN ",
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
    which( x == sub( list.files( "gallery" ), pattern = "\\.[a-z]{3}", 
                     replacement="" ) ) 
  } ) )
  
  filesToClone <- list.files( "gallery" )[whichToClone]
  sapply( filesToClone, function(x){
    file.copy( from = paste0(repoFrom, "gallery/",x), to = paste0( repoTo, "gallery/" ),
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
        paste0("gallery/", x[2])
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
  
  }

cloneGithubFile <- function( file, repo, user, branch, to, repoDirGit ){

    URLfile <- paste0( get( ".GithubURL", envir = .ArchivistEnv) , 
                       user, "/", repo, "/", branch, "/", file) 
    # tidy
    if ( is.character( repoDirGit ) ){
      file <- paste0( "gallery/", strsplit(file, "gallery/")[[1]][2] )
    }
    
    fileFromGithub <- getBinaryURL( URLfile, ssl.verifypeer = FALSE )
    
    file.create( paste0( to, file ) )
    writeBin( fileFromGithub, paste0( to, file ) )
    #files contain "gallery/" in it's name
    
  }


