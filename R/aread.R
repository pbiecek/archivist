##    archivist package for R
##
#' @title Read Artifacts Given as md5hashes from the Repository
#'
#' @description
#' \code{aread} reads the artifact from the \link{Repository}. It's a wrapper around 
#' \link{loadFromLocalRepo} and \link{loadFromRemoteRepo}.
#' 
#' @details
#' Function \code{aread} reads artifacts (by \code{md5hashes}) from Remote Repository.
#' It uses \link{loadFromLocalRepo} and \link{loadFromRemoteRepo} functions
#' with different parameter's specification.
#' 
#' @note
#' Before you start using this function, remember to set local or Remote repository
#' to default by using \code{setLocalRepo()} or \code{setRemoteRepo} functions.
#' 
#' @param md5hash One of the following:
#' 
#' A character vector which elements  are consisting of at least three components separated with '/': Remote user name, Remote repository and name of the artifact (MD5 hash) or it's abbreviation.
#' 
#' MD5 hashes of artifacts in current local default directory or its abbreviations.
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' @note 
#' Bug reports and feature requests can be sent to \href{https://github.com/pbiecek/archivist/issues}{https://github.com/pbiecek/archivist/issues}
#' 
#' @examples
#' # read the object from local directory
#' setLocalRepo(system.file("graphGallery", package = "archivist"))
#' pl <- aread("7f3453331910e3f321ef97d87adb5bad")
#' # To plot it remember to have ggplot2 in version 2.1.0
#' # as this is stated in asession("7f3453331910e3f321ef97d87adb5bad") .
#' # The state of R libraries can be restored to the same state in
#' # which 7f3453331910e3f321ef97d87adb5bad was created with the restoreLibs function.
#' 
#' # read the object from Remote
#' pl <- aread("pbiecek/graphGallery/7f3453331910e3f321ef97d87adb5bad")
#' # To plot it remember to have ggplot2 in version 2.1.0
#' # as this is stated in asession("pbiecek/graphGallery/7f3453331910e3f321ef97d87adb5bad") .
#' # The state of R libraries can be restored to the same state in
#' # which 7f3453331910e3f321ef97d87adb5bad was created with the restoreLibs function.
#' @family archivist
#' @rdname aread
#' @export
aread <- function(md5hash){
  stopifnot( is.character( md5hash ) )

  # work for vectors  
  res <- list()
  for (md5h in md5hash) {
    # at least 3 elements
    elements <- strsplit(md5h, "/")[[1]]
    stopifnot( length(elements) >= 3 | length(elements) == 1)
    if (is.url(md5h)) {
      # url - shiny repo
      res[[md5h]] <- loadFromLocalRepo(md5hash = tail(elements,1), 
                                       repoDir = paste(elements[-length(elements)], collapse="/"),
                                       value = TRUE)
    } else {
      if (length(elements) == 1) {
        # local directory
        res[[md5h]] <- loadFromLocalRepo(md5hash = elements, value = TRUE)
      } else {
        # Remote directory
        res[[md5h]] <- loadFromRemoteRepo(md5hash = tail(elements,1), 
                                          repo = elements[2],
                                          subdir = ifelse(length(elements) > 3, paste(elements[3:(length(elements)-1)], collapse="/"), "/"),
                                          user = elements[1], value = TRUE)
      }
    } 
  }
  if (length(res) == 1) return(res[[1]]) else res
}
