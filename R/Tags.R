##    archivist package for R
##
#' @title Tags 
#'
#' @description
#' \code{Tags} are specific properties of an object, like class, name, names of object' parts or other. List of object properties vary across object's classes. 
#' 
#' @details
#' 
#' \code{Tags} are specific properties of an object. \code{Tags} can be an object's \code{name}, \code{class} or \code{archivisation date}. 
#' Furthermore, for various object's classes more different \code{Tags} are available and can 
#' be searched by \link{searchInLocalRepo} or \link{searchInGithubRepo} functions. 
#' 
#' \code{Tags} are stored in the \link{Repository}.
#' 
#' Supported objects with extra \code{Tags} are:
#' \describe{
#'   \item{\code{default}}{
#'   \itemize{
#'      \item name
#'      \item class
#'      \item date
#'   }
#'   }
#'   \item{\code{data.frame}}{
#'   \itemize{
#'      \item name
#'      \item class
#'      \item date
#'      \item varname
#'   }
#'   }
#'   \item{\code{ggplot}}{
#'   \itemize{
#'      \item name
#'      \item class
#'      \item date
#'      \item data
#'      \item labelx
#'      \item labely
#'   }
#'   }
#'   \item{\code{lm}}{
#'   \itemize{
#'      \item coefname
#'      \item class
#'      \item call
#'      \item name
#'      \item data
#'      \item date
#'   }
#'   }
#'   \item{\code{htest}}{
#'   \itemize{
#'      \item alternative
#'      \item method
#'      \item date
#'      \item name
#'      \item class
#'   }
#'   }
#'   \item{\code{twins (agnes, diana, mona)}}{
#'   \itemize{
#'      \item
#'   }
#'   }
#'   \item{\code{partition (pam, clara, fanny)}}{
#'   \itemize{
#'      \item
#'   }
#'   }
#'   \item{\code{lda}}{
#'   \itemize{
#'      \item
#'   }
#'   }
#'   \item{\code{qda}}{
#'   \itemize{
#'      \item
#'   }
#'   }
#'   \item{\code{glmnet (elmet, lognet, multnet, fishnet, coxnet, mrelnet)}}{
#'   \itemize{
#'      \item
#'   }
#'   }
#'   \item{\code{survfit}}{
#'   \itemize{
#'      \item
#'   }
#'   }
#'   }
#' TODO: list of tags
#' 
#' @seealso 
#' Functions using \code{Tags} are \link{searchInLocalRepo} and \link{searchInGithubRepo}. 
#' 
#' @family archivist
#' @name Tags
#' @docType class
invisible(NULL)