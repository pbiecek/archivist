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
#' For each artifact, \code{md5hash} is a unique string of length 32 that is produced by
#' \link[digest]{digest} function which uses a cryptographical MD5 hash algorithm.
#' The \code{md5hash} of each artifact that is archived in the \link{Repository} is also saved
#' on the Repository along with the artifact's \code{Tags} - see \link{Tags}. It enables to distinguish
#' artifacts in the Repository and facilitates searching and loading them.
#' 
#' @seealso 
#' Functions that take \code{md5hash} as a parameter are:
#' \itemize{
#'  \item \link{addTagsRepo},
#'  \item \link{copyLocalRepo}, 
#'  \item \link{copyGithubRepo},
#'  \item \link{loadFromLocalRepo}, 
#'  \item \link{loadFromGithubRepo},
#' \item \link{getTagsGithub},
#' \item \link{getTagsLocal},
#'  \item \link{rmFromRepo}.
#' }
#' Functions returning \code{md5hash} as a value are:
#'\itemize{  
#'  \item \link{saveToRepo},
#'  \item \link{searchInLocalRepo},
#'  \item \link{searchInGithubRepo},
#'  \item \link{shinySearchInLocalRepo},
#'  \item \link{multiSearchInLocalRepo},
#'  \item \link{multiSearchInGithubRepo}.
#' }
#' Functions returning \code{md5hashes} as a \code{data.frame} are:
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
