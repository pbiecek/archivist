##    archivist package for R
##
#' @title Restore Versions of Libraries
#'
#' @description
#' Function \code{restoreLibrary} gets either session_info or artifact's id 
#' and restore libraries to the version set in the object.
#' 
#' @param md5hash One of the following (see \link{aread}):
#' 
#' A character vector which elements  are consisting of at least three components separated with '/': Remote user name, Remote repository and name of the artifact (MD5 hash) or it's abbreviation.
#' 
#' MD5 hashes of artifacts in current local default directory or its abbreviations.
#' 
#' @return This function returns a list of artifacts (by their values).
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' @examples
#' \dontrun{
#' ## objects preparation
#' restoreLibs(md5hash = "pbiecek/graphGallery/600bda83cb840947976bd1ce3a11879d")
#' }
#' @family archivist
#' @rdname restoreLibs
#' @export
restoreLibs <- function( md5hash, session_info = NULL){
  stopifnot( !is.null( md5hash ) | !is.null( session_info ) )

  if (is.null(session_info)) {
    session_info <- asession(md5hash)
  }

  pkgs <- session_info$packages

  for (i in seq_along(pkgs$package)) {
    # check version, maybe we have it is already installed
    devtools::session_info(pkgs[i,"package"])
    deps <- apply(devtools::session_info(pkgs[i,"package"])$packages[,c("package", "version")], 1, paste, collapse="")

    if (!(paste0(pkgs[i,"package"], pkgs[i,"version"]) %in% deps)) {
      if (pkgs[i,"*"] == "*") {
# local inst
         cat("Package", pkgs[i,"package"], "will not be reinstalled.\n\n")
        } else {
          if (grepl(pkgs[i,"source"], pattern = "^CRAN")) {
          # CRAN inst
            try(devtools::install_version(pkgs[i,"package"],
                             version = pkgs[i,"version"], 
                             repos = 'https://cran.rstudio.com/',
                             type="source"), silent=TRUE)
            } else {
          # Github inst
            pkg <- gsub(gsub(pkgs[i,"source"], pattern=".*\\(", replacement=""), pattern="\\)", replacement="")
            try(devtools::install_github(pkg), silent=TRUE)
            }
        }
    }
  }
}
