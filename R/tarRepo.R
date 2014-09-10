##
#' @title Create a Tar Archive From an Existing Repository
#' 
#' @description
#' \code{tarLocalRepo} ...
#' 
#' @details
#' \code{tarLocalRepo}
#' 
#'
#' @param repoDir A character that specifies the directory of the Repository which
#' will be tarred.
#'
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#' 
#' }
#' @family archivist
#' @rdname tarRepo
#' @export
tarLocalRepo <- function( repoDir ){
  stopifnot( is.character( repoDir ))
  
  repoDir <- checkDirectory( repoDir )

  files <- c( paste0( repoDir, "backpack.db"), 
              paste0( repoDir, "gallery/", list.files( paste0(repoDir, "gallery/") ) ) )
  tar( paste0(repoDir, "repository.tar"), files)

}