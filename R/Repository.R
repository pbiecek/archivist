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
#' \code{Repository} is folder with a SQLite database stored in a file named \code{backpack}
#' and a subdirectory named \code{gallery} with collection of object saved as \code{.rda} files.
#' TODO: needs more info?
#' 
#' @seealso 
#' Functions using \code{Repository} are:
#' \link{saveToRepo}, 
#' \link{rmFromRepo}, 
#' \link{loadFromLocalRepo}, 
#' \link{loadFromGithubRepo},
#' \link{searchInLocalRepo},
#' \link{searchInGithubRepo}.
#' 
#' Function creating \code{Repository} is:
#' \link{createEmptyRepo}.
#' 
#' @family archivist
#' @name Repository
#' @docType class
invisible(NULL)