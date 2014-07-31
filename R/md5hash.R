##    archivist package for R
##
#' @title md5hash 
#'
#' @description
#' \code{Repository} stores specific values of an object, different for 
#' various object's classes, and objects themselves.
#' 
#' @details
#' 
#' \code{md5hash} is a hash generated from object, which is wanted to be saved and is different 
#' for various objects. This \code{md5hash} is a string of length 32 that comes out as a result of 
#' \code{digest{digest}} function, which uses a cryptographical MD5 hash algorithm.
#' \code{md5hash} of every object that is archivised to the \link{Repository} is also saved
#' to the Repository as this object's \code{Tags} - see \link{Tags}. It enables to distinguish
#' objects in Repository and facilitates searching and loading them.
#' 
#' @seealso 
#' Functions that take \code{md5hash} as a parameter are:
#' \itemize{
#'  \item \link{rmFromRepo}, 
#'  \item \link{loadFromLocalRepo}, 
#'  \item \link{loadFromGithubRepo},
#' }
#' Functions returning \code{md5hash} as a value are:
#'\itemize{  
#'  \item \link{searchInLocalRepo},
#'  \item \link{searchInGithubRepo},
#'  \item \link{saveToRepo}.
#' }
#' @family archivist
#' @name md5hash
#' @docType class
invisible(NULL)