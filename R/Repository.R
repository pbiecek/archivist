##    archivist package for R
##
#' @title Repository 
#'
#' @description
#' \code{Repository} stores specific values of an object, different for 
#' various object's classes, and objects themselves.
#' 
#' @details
#' 
#' \code{Repository} is folder with an SQLite database stored in a file named \code{backpack}
#' and a subdirectory named \code{gallery} with collection of object saved as \code{.rda} files.
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
#' \link{createEmptyRepo}.
#' 
#' Function deleting \code{Repository} is:
#' \link{deleteRepo}.
#' 
#' @family archivist
#' @name Repository
#' @docType class
invisible(NULL)