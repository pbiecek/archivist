##    archivist package for R
##
#' @title Tags 
#'
#' @description
#' \code{Tags} are attributes of an object, i.e., a class, a name, names of object's parts, etc.. The list of object tags vary across object's classes. 
#' 
#' @details
#' 
#' \code{Tags} are attributes of an object. \code{Tags} can be an object's \code{name}, \code{class} or \code{archiving date}. 
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
#'   \item{\code{trellis}}{
#'   \itemize{
#'      \item date
#'      \item name
#'      \item class
#'      \item call
#'   }
#'   }
#'   \item{\code{twins (agnes, diana, mona)}}{
#'   \itemize{
#'      \item date
#'      \item name
#'      \item class
#'      \item ac
#'      \item merge
#'      \item diss
#'      \item data
#'   }
#'   }
#'   \item{\code{partition (pam, clara, fanny)}}{
#'   \itemize{
#'      \item date
#'      \item name
#'      \item class
#'      \item call
#'      \item data
#'      \item diss
#'      \item objective
#'   }
#'   }
#'   \item{\code{lda}}{
#'   \itemize{
#'      \item date
#'      \item name
#'      \item class
#'      \item call
#'   }
#'   }
#'   \item{\code{qda}}{
#'   \itemize{
#'      \item date
#'      \item name
#'      \item class
#'      \item call
#'      \item terms
#'   }
#'   }
#'   \item{\code{glmnet (elmet, lognet, multnet, fishnet, coxnet, mrelnet)}}{
#'   \itemize{
#'      \item date
#'      \item name
#'      \item class
#'      \item call
#'      \item beta
#'      \item lambda
#'   }
#'   }
#'   \item{\code{survfit}}{
#'   \itemize{
#'      \item date
#'      \item name
#'      \item class
#'      \item call
#'      \item strata
#'      \item type
#'   }
#'   }
#'   }
#' 
#' @seealso 
#' Functions using \code{Tags} are \link{searchInLocalRepo} and \link{searchInGithubRepo}. 
#' 
#' @family archivist
#' @name Tags
#' @docType class
invisible(NULL)