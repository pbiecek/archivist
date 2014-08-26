##    archivist package for R
##
#' @title Copy an Existing Repository to Another Repository
#'
#' @description
#' \code{copyToRepo} copies artifact from one \link{Repository} to another \code{Repository}.
#' Functions \code{copyLocalRepo} and \code{copyGithubRepo} copie objects from the archivist Repositories stored in a local folder or on Github. 
#' Both of them take \code{md5hash} as a parameter, which is a result from \link{saveToRepo} function.
#' For every object, \code{md5hash} is a unique string of length 32 that comes out as a result of 
#' \link[digest]{digest} function, which uses a cryptographical MD5 hash algorithm. For more information see \link{md5hash}.
#' 
#' @details
#' \code{copyToRepo} copies artifact from one \code{Repository} to another \code{Repository}. It addes new files
#' to exising \code{gallery} folder in \code{repoTo} \code{Repository}. \code{copyLocalRepo} copies local \code{Repository}, where
#' \code{copyGithubRepo} copies Github \code{Repository}. 
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
#' 
#' @param user Only if coping a Github repository. A character containing a name of a Github user on whose account the \code{repoFrom} is created.
#' 
#' @param branch Only if coping with a Github repository. A character containing a name of 
#' Github Repository's branch on which a \code{repoFrom}-Repository is archived. Default \code{branch} is \code{master}.
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
#' 
#' }
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
copyGithubRepo <- function( repoTo, md5hashes, user, repo, branch="master"){
  stopifnot( is.character( c( repoTo, user, repo, branch, md5hashes ) ) )
  
  repoTo <- checkDirectory( repoTo )
  
  Temp <- downloadDB( repo, user, branch )
  
  copyRepo( repoTo = repoTo, repoFrom = Temp, md5hashes = md5hashes , 
            local = FALSE, user = user, repo = repo, branch = branch )  
  
}


copyRepo <- function( repoFrom, repoTo, md5hashes, local = TRUE, user, repo, branch ){
  
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
  
  whichToClone <- as.vector( sapply( md5hashes, function(x){
    which( x == sub( list.files( "gallery" ), pattern = "\\.[a-z]{3}", 
                     replacement="" ) ) 
  } ) )
  
  filesToClone <- list.files( "gallery" )[whichToClone]
  sapply( filesToClone, file.copy, from = repoFrom, to = paste0( repoTo, "gallery/" ),
          recursive = TRUE )
  } else {
    # if github mode
    # get files list
    library( httr )
    
    req <- GET( paste0( "https://api.github.com/repos/", user, "/",
                        repo, "/git/trees/", branch, "?recursive=1" ) )
    stop_for_status(req)
    
    filelist <- unlist(lapply(content(req)$tree, "[", "path"), use.names = F)
    
    whichFilesToClone <- grep("gallery/", filelist, value = TRUE, fixed = TRUE)
    
    filesToDownload <- as.vector (sapply( hashes, function(x){
      grep(pattern = x, whichFilesToClone, value = TRUE, fixed = TRUE)
    } ) ) 
    
    # download files to gallery folder
    sapply( filesToDownload, cloneGithubFile, repo = repo, user = user, branch = branch, to = repoTo )
  }
  
  }



cloneGithubFile <- function( file, repo, user, branch, to ){
    URLfile <- paste0( get( ".GithubURL", envir = .ArchivistEnv) , 
                       user, "/", repo, "/", branch, "/", file) 
    library( RCurl )
    fileFromGithub <- getBinaryURL( URLfile, ssl.verifypeer = FALSE )
    file.create( paste0( to, file ) )
    writeBin( fileFromGithub, paste0( to, file ) )
    
  }


  
  
#   for( i in 1:length( md5hashes ) ){
#     if( local ){
#       value <- loadFromLocalRepo( md5hashes[i], repoDir = repoFrom, value = TRUE )
#       
#     } else {
#       value <- loadFromGithubRepo( md5hashes[i], user = user, repo = repo, value = TRUE )
#     }
#     name <- unlist( executeSingleQuery( dir = repoFrom, paste = local,
#                                 paste0( "SELECT DISTINCT name FROM artifact WHERE md5hash = ",
#                                         "'", md5hashes[i], "'" ) ) )
#     
#     assign(x = name, value = value, .ArchivistEnv )
#     saveToRepo( get(name, envir = .ArchivistEnv ), repoDir = repoTo ) 
#     rm( list = get(name, envir = .ArchivistEnv ), envir = .ArchivistEnv)
#   }
  # error
#   
#   Error in save(file = paste0(repoDir, "gallery/", md5hash, ".rda"), ascii = TRUE,  : 
#                   nie znaleziono obiektu ‘get(name, envir = .ArchivistEnv)’ 
#                 5 stop(sprintf(ngettext(n, "object %s not found", "objects %s not found"), 
#                                paste(sQuote(list[!ok]), collapse = ", ")), domain = NA) 
#                 4 save(file = paste0(repoDir, "gallery/", md5hash, ".rda"), ascii = TRUE, 
#                        list = objectName, envir = parent.frame(2)) at saveToRepo.R#208
#                 3 saveToRepo(get(name, envir = .ArchivistEnv), repoDir = repoTo) at copyToRepo.R#135
#                 2 copyRepo(repoTo = repoTo, repoFrom = Temp, md5hashes = md5hashes, 
#                            local = FALSE, user = user, repo = repo) at copyToRepo.R#115
#                 1 copyGithubRepo(repoTo = dirr, md5hashes = hashes, user = "pbiecek", 
#                                  repo = "archivist")
  
