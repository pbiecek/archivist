##    archivist package for R
##
#' @title Show Artifact's History
#'
#' @description
#' \code{ahistory} extracts artifact's history and creates a data frame with  
#' history of calls and md5hashes of partial results. The overloaded 
#' \code{print.ahistory} function prints this history in a concise way.
#' 
#' @details
#' All artifacts created with operator %a% are archivised with 
#' detailed information  about it's source (both call and md5hash of the input).
#' The function \code{ahistory} reads all artifacts that 
#' precede \code{artifact} and create a description of the input flow. 
#' The generic \code{print.ahistory} function plots the history in a human readable  way.
#' 
#' @param artifact An artifact for which history should be derived. Will be converted  into md5hash.
#' @param md5hash  If \code{artifact} is not specified then \code{md5hash} is used.
#' @param repoDir  A character denoting an existing directory in which an artifact will be saved.
#' If set to \code{NULL} (by default), uses the \code{repoDir} specified in \link{setLocalRepo}.
#' @param x  A character vector of tags. 
#' @param ...  A character vector of tags. 
#' 
#' @return This function returns data frame with two columns - names of calls and md5hashes of partial results.
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' @examples
#' \dontrun{
#' library(dplyr)
#' iris %a%
#'   filter(Sepal.Length < 6) %a%
#'   lm(Petal.Length~Species, data=.) %a%
#'   summary() -> artifact
#' # read the artifact history
#'  asearch(artifact)
#' }
#' @family archivist
#' @rdname ahistory
#' @export

ahistory <- function(artifact = NULL, md5hash = NULL, repoDir = NULL) {
  # if artifact is set then calculate md5hash for it
  if (!is.null(artifact)) 
    md5hash = digest(artifact)
  if (is.null(md5hash)) 
    stop("Either artifact or md5hash has to be set")
  
  res_names <- c()
  res_md5 <- md5hash
  ind <- 1
  while (!is.null(md5hash) && length(md5hash)>0) {
    tags <- getTagsLocal(md5hash, tag = "", repoDir=repoDir)
    tmp <- grep(tags, pattern="^RHS:", value = TRUE)
    if (length(tmp) > 0) {
      res_names[ind] <- substr(tmp[1],5,nchar(tmp[1]))
    } else {
      # if not RHS then maybe name
      tmp <- grep(tags, pattern="^name:", value = TRUE)
      if (length(tmp) > 0) {
        res_names[ind] <- substr(tmp[1],6,nchar(tmp[1]))
      } else {
       # that's should not happen
        df <- data.frame(md5hash = res_md5, call = rep("", length(res_md5)), stringsAsFactors = FALSE)
        class(df) = c("ahistory", "data.frame")
        return(df)
      }
    }
    md5hash <- grep(tags, pattern="^LHS:", value = TRUE)
    if (length(md5hash) > 0) {
      md5hash <- substr(md5hash[1],5,nchar(md5hash[1]))
      res_md5[ind+1] <- md5hash
    }
    ind <- ind + 1
  }
  if (length(res_md5) != length(res_names)) {
    res_md5[max(length(res_md5), length(res_names))+1] = ""
    res_names[max(length(res_md5), length(res_names))+1] = ""
  }
  df <- data.frame(md5hash = res_md5, call = res_names, stringsAsFactors = FALSE)
  class(df) = c("ahistory", "data.frame")
  df
}

#' @family archivist
#' @rdname ahistory
#' @export

print.ahistory <- function(x, ...) {
  x[,2] <- paste0(x[,2], sapply(max(nchar(x[,2])) + 1 - nchar(x[,2]), 
                                function(j) paste(rep(" ", j), collapse="")))
  for (i in nrow(x):1) {
    if (i < nrow(x)) cat("-> ") else cat("   ")
    cat(x[i,2], " [", x[i,1], "]\n", sep = "")
  }
}
