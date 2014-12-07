##    archivist package for R
##
#' @title Enable Caching of a Function Results with the use of Archivist
#'
#' @description
#' \code{cache} function stores all results of function calls in local \link{Repository}.
#' All results are stored together with md5 hashes of the function calls.
#' If function has been called with same arguments as in the past, then results can be loaded from repository.
#'
#' One may specify expiration date for live objects. 
#' It may be useful for objects that can be changed externally (like queries to database).
#' 
#' @details
#' \code{cache} function stores all results of function calls in local \link{Repository} 
#' specified by the \code{cacheRepo} argument.
#' The md5 hash of \code{FUN} and it's arguments is added as an tag to the repository.
#’ Note that cache is a good solution if objects are not that big but calculations are time consuming. 
#' If objects are big and calculations are easy, then disk input-output operations may take more time 
#' than calculations itself.
#' 
#' @return
#' Result of function call with added additional argument - md5 hash of function call.
#' 
#' @seealso
#'  For more detailed information check the \pkg{archivist} package 
#' \href{https://github.com/pbiecek/archivist#-the-list-of-use-cases-}{Use Cases}.
#' 
#' @param cacheRepo An object repository used for storing cached objects.
#' 
#' @param FUN A function to be called.
#' 
#' @param ... Arguments for function \code{FUN}.
#' 
#' @param notOlderThan Restore an artifact from database only if it was created after notOlderThan. 
#' 
#' @author 
#' Przemyslaw Biecek, \email{Przemyslaw.Biecek@@gmail.com}
#'
#' @examples
#' # objects preparation
#' \dontrun{
#' cacheRepo <- tempdir()
#' createEmptyRepo( cacheRepo )
#' fun <- function(n) {replicate(n, summary(lm(Sepal.Length~Species, iris))$r.squared)}
#' system.time( res <- cache(cacheRepo, fun, 1000) )
#' system.time( res <- cache(cacheRepo, fun, 1000) )
#' 
#' testFun <- function(x) {cat(x);x}
#' # will be executed
#' tmp <- cache(cacheRepo, testFun, "Say hallo!")
#' # will loaded from repository
#' tmp <- cache(cacheRepo, testFun, "Say hallo!")
#' # will be executed, fails with expiration date
#' tmp <- cache(cacheRepo, testFun, "Say hallo!", notOlderThan = now())
#' # will be executed, passes with expiration date [within hour]
#' tmp <- cache(cacheRepo, testFun, "Say hallo!", notOlderThan = now() - hours(1))
#' 
#' deleteRepo( cacheRepo )
#' rm( cacheRepo )
#' }
#' @family archivist
#' @rdname cache
#' @export
cache <- function( cacheRepo = NULL, FUN, ..., notOlderThan = NULL ) {
  tmpl <- list(...)
  tmpl$.FUN <- FUN
  outputHash <- digest(tmpl)
  localTags <- showLocalRepo(cacheRepo, "tags")
  isInRepo <- localTags[localTags$tag == paste0("cacheId:", outputHash),,drop=FALSE]
   if (nrow(isInRepo) > 0) {
    lastEntry <- max(isInRepo$createdDate)
    if (is.null(notOlderThan) || (notOlderThan < lastEntry)){
      lastOne <- order(isInRepo$createdDate, decreasing = TRUE)[1]
      return(loadFromLocalRepo(isInRepo$artifact[lastOne], repoDir = cacheRepo, value = TRUE))
    }
  }
  
  output <- do.call(FUN, list(...))
  attr( output, "tags") <- paste0("cacheId:", outputHash)
  attr( output, "call") <- ""
  saveToRepo(output, repoDir = cacheRepo, archiveData = TRUE, 
             archiveMiniature = FALSE, rememberName = FALSE,
             silent = TRUE)
  output
}
