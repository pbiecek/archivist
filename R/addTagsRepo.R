##    archivist package for R
##
#' @title Add new Tags to the Existing Repository
#' 
#' @description
#' \code{addTagsRepo} adds new \link{Tags} to the existing \link{Repository}.
#' 
#' @details
#' The \code{addTagsRepo} function adds new tags to artifacts that are already stored in repository. 
#'  One can add new \code{tags} explicitly with \code{tags} argument, or by passing a 
#'  function that extracts \code{tags} from selected artifacts specified by passing their \link{md5hash}.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' \code{Tags} are attributes of an artifact. \code{Tags} can be an artifact's \code{name}, \code{class} or \code{archiving date}. 
#' Furthermore, for various artifact's classes more different \code{Tags} are available and can 
#' be searched in \link{searchInLocalRepo} or \link{searchInGithubRepo} functions. 
#'
#' @param md5hashes To which corresponding artifacts should \code{Tags} be added. 
#' 
#' @param tags A character vector that specifies what tag should be added to which artifact that
#' corresponds to given \code{md5hash}. Can be specified only one of: \code{FUN} 
#' or \code{tags}. Should have length 1 or the same as length of \code{md5hashes} param.
#' 
#' @param repoDir A character that specifies the directory of the Repository into which
#' new \code{Tags} will be added. If set to \code{NULL} (by default), uses the \code{repoDir} specified in \link{setLocalRepo}.
#' 
#' @param FUN A function that evaluates on the artifacts for which \code{md5hashes} are given and generates
#' \code{Tags} as a result that will be added to the local Repository. Can be specified only one of: \code{FUN} 
#' or \code{tags}.
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
#' # Takes all objects of lm class from repository, 
#' # extracts R2 for them and stores as R2: tags
#' 
#' exampleRepoDir <- tempdir()
#' createEmptyRepo(exampleRepoDir, force=TRUE)
#' m1 <- lm(Sepal.Length~Species, iris)
#' saveToRepo(m1, exampleRepoDir)
#' m1 <- lm(Sepal.Width~Species, iris)
#' saveToRepo(m1, exampleRepoDir)
#' getTagsLocal("da1bcaf68752c146903f700c1a458438", exampleRepoDir, "")
#' md5hashes <- searchInLocalRepo(repoDir=exampleRepoDir, "class:lm")
#' addTagsRepo(md5hashes, exampleRepoDir, tags = "test")
#' addTagsRepo(md5hashes, exampleRepoDir, function(x) paste0("R2:",summary(x)$r.square))
#' getTagsLocal("da1bcaf68752c146903f700c1a458438", exampleRepoDir, "")
#' showLocalRepo(exampleRepoDir)
#' deleteRepo(exampleRepoDir)
#' }
#' 
#' @family archivist
#' @rdname addTagsRepo
#' @export
addTagsRepo <- function( md5hashes, repoDir = NULL, FUN = NULL, tags = NULL, ...){
  stopifnot( xor( is.null(FUN), is.null(tags)))
  stopifnot( is.character( md5hashes ) )
  stopifnot( length(md5hashes) > 0 )
  stopifnot( is.character( repoDir ) | is.null( repoDir ) )
  
  if ( is.null(FUN) ){ stopifnot( is.character( tags ) ) }
  if ( is.null(tags) ){ stopifnot( is.function( FUN ) ) }
  if ( !is.null(tags) ){ stopifnot( 
    length( md5hashes )%%length( tags ) == 0 | length( tags )%%length( md5hashes ) == 0) }
  # that a helpful data frame can be computed
  
  
  repoDir <- checkDirectory( repoDir )
  
  if( !is.null(tags) ){ #applying only simple tags to given md5hashes
    helpfulDF <- data.frame( md5hashes, tags)
    apply( helpfulDF, 1, function(row){
      addTag( tag = row[2], md5hash = row[1], dir = repoDir )
    })
  }else{ #applying tags after evaluations on artifacts correspoding to given md5hashes
    
    # load artifacts into new env and
    # create tags for those artifacts
    helpfulDF <- lapply( md5hashes, function(x) {
      tmpObj <- loadFromLocalRepo(x, repoDir = repoDir, value = TRUE)
      tags <- FUN( tmpObj, ... )
      # FUN may returns different number of tags (=more than one) for different objects
      sapply(tags, addTag, md5hash = x, dir = repoDir )
      c(x, tags)
    } )
  }
  
  invisible(helpfulDF)
}
