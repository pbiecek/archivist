##    archivist package for R
##
#' @title Add new Tags to the Existing Repository
#' 
#' @description
#' \code{addTagsRepo} 
#' 
#' @details
#' \describe{
#' \item{Problem:}{
#'  \itemize{
#'    \item after an artifact is added there is no way to add/update it's tags 
#'    sometimes one discover, that it would be nice to have additional properties exposed as tags
#' }
#' }
#' \item{Proposed solution:}{
#' \itemize{ 
#'  \item addTag(md5hashes, repoDir, FUN, tags)  function, that will take list of md5hashes if user specifies tags, then these tags will be added to all md5hashes if user specifies FUN, then FUN will be executed on each md5hash object, FUN returns a character vector (=new tags), new tags are added to database
#' }
#' }
#' }
#'
#' @param md5hashes To which corresponding artifacts should \code{Tags} be added. 
#' 
#' @param tags A character vector that specifies what tag should be added to which artifact that
#' corresponds to given \code{md5hash}. Can be specified only one of: \code{FUN} 
#' or \code{tags}. Should have length 1 or the same as length of \code{md5hashes} param.
#' 
#' @param repoDir A character that specifies the directory of the Repository into which
#' new \code{Tags} will be added.
#' 
#' @param FUN A function that evaluates on the artifacts for which \code{md5hashes} are given and generates
#' \code{Tags} as a result that will be added to the local Repository. Can be specified only one of: \code{FUN} 
#' or \code{tags}.
#'
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
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
#' getTagsLocal("da1bcaf68752c146903f700c1a458438", exampleRepoDir)
#' md5hashes <- searchInLocalRepo(repoDir=exampleRepoDir, "class:lm")
#' addTagsRepo(md5hashes, exampleRepoDir, function(x) paste0("R2:",summary(x)$r.square))
#' getTagsLocal("da1bcaf68752c146903f700c1a458438", exampleRepoDir)
#' deleteRepo(exampleRepoDir)
#' }
#' 
#' @family archivist
#' @rdname addTagsRepo
#' @export
addTagsRepo <- function( md5hashes, repoDir, FUN = NULL, tags = NULL){
  stopifnot( xor( is.null(FUN), is.null(tags)))
  stopifnot( is.character( c( md5hashes, repoDir ) ) )
  stopifnot( length(md5hashes) > 0 )
  
  if ( is.null(FUN) ){ stopifnot( is.character( tags ) ) }
  if ( is.null(tags) ){ stopifnot( is.function( FUN ) ) }
  if ( !is.null(tags) ){ stopifnot( 
    length( md5hashes )%%length( tags ) == 0 | length( tags )%%length( md5hashes ) == 0) }
  # that a helpful data frame can be computed
  
  
  repoDir <- checkDirectory( repoDir )
  
  if( !is.null(tags) ){ #applying only simple tags to given md5hashes
    helpfulDF <- data.frame( md5hashes, tags)
  }else{ #applying tags after evaluations on artifacts correspoding to given md5hashes
    
    # load artifacts into new env and
    # create tags for those artifacts
    .nameEnv <- new.env()
    tags <- lapply( md5hashes, function(x) {
      tmpObj <- loadFromLocalRepo(x, repoDir = repoDir, value = TRUE)
      c(x, FUN( tmpObj ))
    } )
    helpfulDF <- data.frame( md5hashes = sapply(tags, `[`, 1), 
                             tags = sapply(tags, `[`, 2))
  }
  apply( helpfulDF, 1, function(row){
    addTag( tag = row[2], md5hash = row[1], dir = repoDir )
  })
  invisible(NULL)
}
