##    archivist package for R
##
#' @title Enable Caching of a Function Results with the use of Archivist
#'
#' @description
#' \code{cache} function stores all results of function calls in local \link{Repository}.
#' All results are stored together with md5 hashes of the function calls.
#' If function has been called with same arguments earlier, then results can be loaded from repository.
#' 
#' @details
#' \code{cache} function stores all results of function calls in local \link{Repository} 
#' specified by the \code{cacheRepo} argument.
#' The md5 hash of \code{FUN} and it's arguments is added as an tag to the repository.
#' 
#' @return
#' Result of funcion call with added additional argument - md5 hash of function call.
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
#' @author 
#' Przemyslaw Biecek, \email{Przemyslaw.Biecek@@gmail.com}
#'
#' @examples
#' # objects preparation
#' \dontrun{
#' cacheRepo <- tempdir()
#' createEmptyRepo( cacheRepo )
#' fun <- function(n) {replicate(n, summary(lm(Sepal.Length~Species, iris))$r.squared)}
#' system.time( res <- cache(cacheRepo, fun, 10000) )
#' system.time( res <- cache(cacheRepo, fun, 10000) )
#' 
#' deleteRepo( cacheRepo )
#' rm( cacheRepo )
#' }
#' @family archivist
#' @rdname cache.Rd
#' @export
cache <- function(cacheRepo, FUN, ...) {
  tmpl <- list(...)
  tmpl$.FUN <- FUN
  outputHash <- digest(tmpl)
  isInRepo <- searchInLocalRepo(paste0("cacheId:", outputHash), cacheRepo)
  if (length(isInRepo) > 0)
    return(loadFromLocalRepo(isInRepo[1], repoDir = cacheRepo, value = TRUE))
  
  output <- do.call(FUN, list(...))
  attr( output, "tags") <- paste0("cacheId:", outputHash)
  attr( output, "call") <- ""
  saveToRepo(output, repoDir = cacheRepo, archiveData = TRUE, archiveMiniature = FALSE, rememberName = FALSE)
  output
}
