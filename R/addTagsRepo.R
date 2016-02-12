##    archivist package for R
##
#' @title Add new Tags to the Existing Repository
#' 
#' @description
#' \code{addTagsRepo} adds new \link{Tags} to the existing \link{Repository}.
#' 
#' @details
#' \code{addTagsRepo} function adds new Tags to artifacts that are already stored
#' in the repository. One can add new \code{Tags} either explicitly with \code{tags} parameter
#' or by passing a function which extracts \code{Tags} from selected artifacts
#' corresponding to \code{md5hashes}. To learn more about artifacts visit
#' \link[archivist]{archivist-package}.
#'
#' @note
#' One should remember that \code{length(tags)} modulo \code{length(md5hashes)} 
#' must be equal to 0 or \code{length(md5hashes)} modulo \code{length(tags)}
#' must be equal to 0.
#'
#' @param md5hashes a character vector of \code{md5hashes} specifying to which
#' corresponding artifacts new \code{Tags} should be added. See \code{Note} 
#' to get to know about the length of \code{tags} and \code{md5hashes} parameters.
#' 
#' @param tags A character vector which specifies what kind of Tags should be added to
#' artifacts corresponding to given \code{md5hashes}. See \code{Note} to get to know about
#' the length of \code{tags} and \code{md5hashes} parameters.
#' One can specify either \code{FUN} or \code{tags}.
#' 
#' @param repoDir A character that specifies the directory of the Repository to which
#' new \code{Tags} will be added. If it is set to \code{NULL} (by default),
#' it uses the \code{repoDir} specified in \link{setLocalRepo}.
#' 
#' @param FUN A function which is evaluated on the artifacts for which \code{md5hashes}
#' are given. The result of this function evaluation are \code{Tags} which will
#' be added to the local Repository.
#'
#' @param ... Other arguments that will be passed to FUN.
#'
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}, 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#'
#' @examples
#' \dontrun{
#' 
#' ## We Take all artifacts of lm class from repository, 
#' ## extract R^2 for them and store as R^2:number Tags
#' 
#' # Creating empty repository
#' exampleRepoDir <- tempfile()
#' createLocalRepo(exampleRepoDir, force=TRUE)
#' 
#' # Saving lm artifacts into repository
#' m1 <- lm(Sepal.Length~Species, iris)
#' saveToLocalRepo(m1, exampleRepoDir)
#' m2 <- lm(Sepal.Width~Species, iris)
#' saveToLocalRepo(m2, exampleRepoDir)
#' 
#' # We may see what kind of Tags are related to "m1" artifact corresponding to
#' # "9e66edd297c2f291446f3503c01d443a" md5hash
#' getTagsLocal("9e66edd297c2f291446f3503c01d443a", exampleRepoDir, "")
#' 
#' # We may see what kind of Tags are related to "m2" artifact corresponding to
#' # "da1bcaf68752c146903f700c1a458438" md5hash
#' getTagsLocal("da1bcaf68752c146903f700c1a458438", exampleRepoDir, "")
#' 
#' # We Take all objects of lm class from repository
#' md5hashes <- searchInLocalRepo(repoDir=exampleRepoDir, "class:lm")
#' 
#' # Adding new tag "test" explicitly
#' addTagsRepo(md5hashes, exampleRepoDir, tags = "test")
#' 
#' # Adding new tag "R^2: " using FUN parameter
#' addTagsRepo(md5hashes, exampleRepoDir, function(x) paste0("R^2:",summary(x)$r.square))
#' 
#' # And now: Tags related to "m1" artifact are
#' getTagsLocal("9e66edd297c2f291446f3503c01d443a", exampleRepoDir, "")
#' 
#' # And now: Tags related to "m2" artifact are
#' getTagsLocal("da1bcaf68752c146903f700c1a458438", exampleRepoDir, "")
#' 
#' # One more look at our Repo
#' showLocalRepo(exampleRepoDir, method = "tags")
#' 
#' # Deleting example repository
#' deleteLocalRepo(exampleRepoDir, deleteRoot=TRUE)
#' rm(exampleRepoDir)
#' }
#' 
#' @family archivist
#' @rdname addTagsRepo
#' @export
addTagsRepo <- function( md5hashes, repoDir = NULL, FUN = NULL, tags = NULL, ...){
  stopifnot( xor( is.null(FUN), is.null(tags)))
  stopifnot( is.character( md5hashes ), length( md5hashes ) > 0 )
  stopifnot( ( is.character( repoDir ) & length( repoDir ) == 1 ) | is.null( repoDir ) )
  
  if ( is.null(FUN) ){ stopifnot( is.character( tags ), length( tags ) > 0 ) }
  if ( is.null(tags) ){ stopifnot( is.function( FUN ) ) }
  if ( !is.null(tags) ){ stopifnot( 
    length( md5hashes )%%length( tags ) == 0 | length( tags )%%length( md5hashes ) == 0) }
  # that a helpful data frame can be computed
  
  repoDir <- checkDirectory( repoDir )
  
  if( !is.null(tags) ){ #applying only simple Tags to given md5hashes
    helpfulDF <- data.frame( md5hashes, tags)
    apply( helpfulDF, 1, function(row){
      addTag( tag = row[2], md5hash = row[1], dir = repoDir )
    })
  }else{ #applying Tags after evaluations on artifacts correspoding to given md5hashes
    
    # load artifacts into new env and
    # create Tags for those artifacts
    helpfulDF <- lapply( md5hashes, function(x) {
      tmpObj <- loadFromLocalRepo(x, repoDir = repoDir, value = TRUE)
      tags <- FUN( tmpObj, ... )
      # FUN may returns different number of Tags (=more than one) for different objects
      sapply(tags, addTag, md5hash = x, dir = repoDir )
      c(x, tags)
    } )
  }
  
  invisible(helpfulDF)
}
