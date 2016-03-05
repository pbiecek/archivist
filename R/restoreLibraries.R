##    archivist package for R
##
#' @title Restore Versions of Libraries
#'
#' @description
#' Function \code{ restoreLibs } gets either \code{session info} or artifact's \code{md5hash} 
#' and restore libraries/packages to versions attached when the object was saved in the repo. 
#' Typical use case is following. We have saved an object and now we are restoring it, but
#' with current version of packages something is not working. The function \code{restoreLibs()} 
#' reverts all libraries that were attached previously to their previous versions.
#' 
#' @param session_info Object with versions of packages to be installed. If not supplied then 
#' it will be extracted from md5hash \code{ md5hash }
#' 
#' @param md5hash One of the following (see \link{aread}):
#' 
#' A character vector which elements are consisting of at least three components separated 
#' with '/': Remote user name, Remote repository and name of the artifact (MD5 hash) or 
#' it's abbreviation.
#' 
#' MD5 hashes of artifacts in current local default directory or its abbreviations.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' @examples
#' \dontrun{
#' ## objects preparation
#' restoreLibs(md5hash = "pbiecek/graphGallery/f05f0ed0662fe01850ec1b928830ef32")
#' }
#' @family archivist
#' @rdname restoreLibs
#' @export
restoreLibs <- function( md5hash, session_info = NULL) {
  stopifnot( !is.null( md5hash ) | !is.null( session_info ) )

    if (!requireNamespace("devtools", quietly = TRUE)) {
      stop("devtools package required for restoreLibs function")
    }

  if (is.null(session_info)) {
    session_info <- asession(md5hash)
  }

  pkgs <- session_info$packages
  installed_pkgs <- installed.packages()[,c("Package", "Version")]

  for (i in seq_along(pkgs$package)) {
    # check version, maybe it is already installed
    is_allready_installed <- paste0(pkgs[i,"package"], pkgs[i,"version"]) %in%
                                      apply(installed_pkgs, 1, paste0, collapse="")

    if (pkgs[i,"package"] != "archivist" & !is_allready_installed) {
      if (pkgs[i,"*"] == "*") {
# local inst
         cat("Package", pkgs[i,"package"], "was installed from local file and will not be reinstalled.\n\n")
        } else {
          if (grepl(pkgs[i,"source"], pattern = "^CRAN")) {
          # CRAN inst
            try(devtools::install_version(pkgs[i,"package"],
                             version = pkgs[i,"version"], 
                             type="source",
                             dependencies = FALSE, reload = FALSE), silent=TRUE)
            } else {
          # Github inst
            pkg <- gsub(gsub(pkgs[i,"source"], pattern=".*\\(", replacement=""), pattern="\\)", replacement="")
            try(devtools::install_github(pkg,
                                         dependencies = FALSE, reload = FALSE), silent=TRUE)
            }
        }
    }
  }
}
