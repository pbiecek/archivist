##    archivist package for R
##
#' @title Delete the Existing Repository from the Given Directory
#'
#' @description
#' \code{deleteLocalRepo} deletes the existing \link{Repository} from the given directory.
#' As a result all artifacts from \code{gallery} folder are removed and database \code{backpack.db}
#' is deleted. 
#'   
#' @param repoDir A character that specifies the directory for the Repository
#' which is to be deleted.
#' @param deleteRoot A logical value that specifies if the repository root directory
#' should be deleted for Local Repository.
#' @param unset A logical. If deleted \code{repoDir} was set to be default Local Repository
#' and \code{unset} is TRUE, then \code{repoDir} is unset as a default Local  Repository (\code{aoptions('repoDir/repo', NULL, T)}).
#' 
#' @param ... All arguments are being passed to \code{deleteLocalRepo}.
#' 
#' @note
#' Remember that using \code{tempfile()} instead of \code{tempdir()}
#' in examples section is crucial. \code{tempdir()} is existing directory
#' in which R works so calling \code{deleteLocalRepo(exampleRepoDir, deleteRoot=TRUE)}
#' removes important R files. You can find out more information about this problem at 
#' \href{http://stackoverflow.com/questions/22325820/unlink-function-causing-an-error-for-consequent-and-plot-functions}{stackoverflow}
#' webpage.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' 
#' exampleRepoDir <- tempfile()
#' createLocalRepo( repoDir = exampleRepoDir, default =  TRUE )
#' data(iris)
#' saveToLocalRepo(iris)
#' deleteLocalRepo( repoDir = exampleRepoDir, unset = TRUE, deleteRoot = TRUE)
#' 
#' @family archivist
#' @rdname deleteLocalRepo
#' @export
deleteLocalRepo <- function(repoDir, deleteRoot = FALSE, unset = FALSE){
  stopifnot( is.character( repoDir ), length( repoDir ) == 1 )
  
  repoDir <- checkDirectory( repoDir )
  
  x <- list.files( file.path( repoDir , "gallery") )
  sapply( x , function(x ){
       file.remove( file.path( repoDir, "gallery", x ) )
       })
  
  
  file.remove( file.path( repoDir, "backpack.db" ) )
  unlink( file.path( repoDir, "gallery" ), recursive = TRUE )    
  
  if (deleteRoot) {
    unlink( file.path(repoDir), recursive = TRUE )    
  }
  
  if (unset) {
    aoptions('repoDir', NULL, T)
  }
  
}

#' @family archivist
#' @rdname deleteLocalRepo
#' @export
deleteRepo <- function(...) {
  .Deprecated("deleteRepo is deprecated. Use deleteLocalRepo() instead.")
  deleteLocalRepo(...)
}
