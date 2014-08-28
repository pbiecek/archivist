##    archivist package for R
##
#' @title Repository 
#'
#' @description
#' \code{Repository} stores specific values of an artifact, different for 
#' various artifact's classes, and artifacts themselves.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' 
#' \code{Repository} is folder with an SQLite database stored in a file named \code{backpack}
#' and a subdirectory named \code{gallery} with collection of artifact saved as \code{.rda} files.
#' 
#' @seealso 
#' Functions using \code{Repository} are:
#' \itemize{
#'  \item \link{saveToRepo}, 
#'  \item \link{rmFromRepo}, 
#'  \item \link{loadFromLocalRepo}, 
#'  \item \link{loadFromGithubRepo},
#'  \item \link{searchInLocalRepo},
#'  \item \link{searchInGithubRepo},
#'  \item \link{summaryLocalRepo},
#'  \item \link{summaryGithubRepo}.
#'  }
#' 
#' Function creating \code{Repository} is:
#' \itemize{
#'  \item \link{createEmptyRepo}.
#' }
#' Functions coping \code{Repository} are:
#' \itemize{
#'  \item \link{copyLocalRepo},
#'  \item \link{copyGithubRepo}.
#' }
#' 
#' Function deleting \code{Repository} is:
#' \itemize{
#'  \item \link{deleteRepo}.
#' }
#' 
#' Learn more about \code{Repository} at \pkg{archivist} \code{wiki} webpage on 
#' \href{https://github.com/pbiecek/archivist/wiki/archivist-package-Repository}{Github}.
#' @family archivist
#' @name Repository
#' @docType class
invisible(NULL)