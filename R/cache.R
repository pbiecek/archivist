##    archivist package for R
##
#' @title Enable Caching of the Function Results with the use of Archivist
#'
#' @description
#' \code{cache} function stores all results of function calls in local \link{Repository}.
#' All results are stored together with md5 hashes of the function calls.
#' If a function is called with the same arguments, then its results can be loaded
#' from the repository.
#'
#' One may specify expiration date for live objects. 
#' It may be useful for objects that can be changed externally (like queries to database).
#' 
#' @details
#' \code{cache} function stores all results of function calls in local \link{Repository} 
#' specified by the \code{cacheRepo} argument.
#' The md5 hash of \code{FUN} and it's arguments is added as a Tag to the repository.
#' This Tag has the following structure "cacheId:md5hash".
#' Note that \code{cache} is a good solution if objects are not that big but calculations
#' are time consuming (see \code{Examples}). If objects are big and calculations are easy, then
#' disk input-output operations may take more time than calculations itself.
#' 
#' @return
#' Result of the function call with additional attributes: \code{tags} - md5 hash of the
#' function call and \code{call} - "".
#' 
#' @seealso
#'  For more detailed information, check the \pkg{archivist} package 
#' \href{https://github.com/pbiecek/archivist#-the-list-of-use-cases-}{Use Cases}.
#' 
#' @param cacheRepo A repository used for storing cached objects.
#' 
#' @param FUN A function to be called.
#' 
#' @param ... Arguments of \code{FUN} function .
#' 
#' @param notOlderThan load an artifact from the database only if it was created after notOlderThan. 
#' 
#' @author 
#' Przemyslaw Biecek, \email{Przemyslaw.Biecek@@gmail.com}
#'
#' @examples
#' 
#' # objects preparation
#' library(lubridate)
#' cacheRepo <- tempfile()
#' createLocalRepo( cacheRepo )
#' 
#' ## Example 1:
#' # cache is useful when objects used by FUN are not that big but calculations
#' # are time-comsuming. Take a look at this example:
#' fun <- function(n) {replicate(n, summary(lm(Sepal.Length~Species, iris))$r.squared)}
#' 
#' # let's check time of two evaluations of cache function
#' system.time( res <- cache(cacheRepo, fun, 1000) )
#' system.time( res <- cache(cacheRepo, fun, 1000) ) 
#' # The second call is much faster. Why is it so? Because the result of fun
#' # function evaluation has been stored in local cacheRepo during the first evaluation
#' # of cache. In the second call of cache we are simply loading the result of fun
#' # from local cacheRepo Repository.
#' 
#' ## Example 2:
#' testFun <- function(x) {cat(x);x}
#' 
#' # testFun will be executed and saved to cacheRepo
#' tmp <- cache(cacheRepo, testFun, "Say hallo!")
#' 
#' # testFun execution will be loaded from repository
#' tmp <- cache(cacheRepo, testFun, "Say hallo!")
#' 
#' # testFun will be executed once again as it fails with expiration date. It will
#' # be saved to cacheRepo.
#' tmp <- cache(cacheRepo, testFun, "Say hallo!", notOlderThan = now())
#' 
#' # testFun execution will be loaded from repository as it
#' # passes with expiration date [within hour]
#' tmp <- cache(cacheRepo, testFun, "Say hallo!", notOlderThan = now() - hours(1))
#' 
#' deleteLocalRepo( cacheRepo, TRUE)
#' rm( cacheRepo )
#' 
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
