##    archivist package for R
##
#' @title md5hash 
#'
#' @description
#' \code{Repository} stores specific values of an artifact, different for 
#' various artifact's classes, and artifact themselves. Artifacts are archived with
#' a special attribute named \code{md5hash}.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' 
#' For every artifact, \code{md5hash} is a unique string of length 32 that comes out as a result of 
#' \link[digest]{digest} function, which uses a cryptographical MD5 hash algorithm.
#' The \code{md5hash} of every artifact, that is archived to the \link{Repository}, is also saved
#' to the Repository with this artifact's \code{Tags} - see \link{Tags}. It enables to distinguish
#' artifacts in Repository and facilitates searching and loading them.
#' 
#' @seealso 
#' Functions that take \code{md5hash} as a parameter are:
#' \itemize{
#'  \item \link{rmFromRepo}, 
#'  \item \link{loadFromLocalRepo}, 
#'  \item \link{loadFromGithubRepo},
#'  \item \link{copyLocalRepo}, 
#'  \item \link{copyGithubRepo},
#' \item \link{getTagsGithub},
#' \item \link{getTagsLocal}.
#' }
#' Functions returning \code{md5hash} as a value are:
#'\itemize{  
#'  \item \link{searchInLocalRepo},
#'  \item \link{searchInGithubRepo},
#'  \item \link{multiSearchInLocalRepo},
#'  \item \link{multiSearchInGithubRepo},
#' \item \link{shinySearchInLocalRepo},
#'  \item \link{saveToRepo}.
#' }
#' Functions returning \code{md5hahes} as a \code{data.frame} are:
#' \itemize{
#'  \item \link{showLocalRepo},
#'  \item \link{showGithubRepo}.
#' }
#' 
#' Learn more about \code{md5hashes} at \pkg{archivist} \code{wiki} webpage on 
#' \href{https://github.com/pbiecek/archivist/wiki/archivist-package-md5hash}{Github}.
#' 
#' @family archivist
#' @name md5hash
#' @docType class
invisible(NULL)
