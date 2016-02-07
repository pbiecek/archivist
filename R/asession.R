##    archivist package for R
##
#' @title Show Artifact's Session Info
#'
#' @description
#' \code{asession} extracts artifact's session info. This allow to check in what conditions 
#' the artifact was created.
#' 
#' @param md5hash  \code{md5hash} of the artifact that should be returned.
#' @param repoDir  A character denoting an existing directory in which an artifact will be saved.
#' If set to \code{NULL} (by default), uses the \code{repoDir} specified in \link{setLocalRepo}.
#' 
#' @return An object of the class \code{session_info}.
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' @examples
#' \dontrun{
#' setLocalRepo(system.file("graphGallery", package = "archivist"))
#' asession("2a6e492cb6982f230e48cf46023e2e4f")
#' }
#' @family archivist
#' @rdname asession
#' @export

asession <- function( md5hash = NULL, repoDir = aoptions("repoDir")) {
  tags <- getTagsLocal(md5hash, tag = "", repoDir=repoDir)
  tagss <- grep(tags, pattern="^session_info:", value = TRUE)
  if (length(tagss) == 0) {
    simpleWarning(paste0("No session info archived for ", md5hash))
    return(NA)
  }
  loadFromLocalRepo(gsub(tagss[1], pattern = "^session_info:", replacement = ""), repoDir, value = TRUE)
}
