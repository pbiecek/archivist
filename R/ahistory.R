##    archivist package for R
##
#' @title Show Artifact's History
#'
#' @description
#' \code{ahistory} extracts artifact's history and creates a data frame with  
#' history of calls and md5hashes of partial results. The overloaded 
#' \code{print.ahistory} function prints this history in a concise way. The overloaded
#' \code{print.ahistoryKable} function prints this history in the same way as \link[knitr]{kable}.
#' 
#' @details
#' All artifacts created with \link[archivist]{\%a\%} operator are archivised with 
#' detailed information  about it's source (both call and md5hash of the input).
#' The function \code{ahistory} reads all artifacts that 
#' precede \code{artifact} and create a description of the input flow. 
#' The generic \code{print.ahistory} function plots the history in a human readable  way.
#' 
#' @param artifact An artifact which history is supposed to be reconstructed.
#' It will be converted  into md5hash.
#' @param md5hash  If \code{artifact} is not specified then \code{md5hash} is used.
#' @param repoDir  A character denoting an existing directory in which an artifact will be saved.
#' If set to \code{NULL} (by default), uses the \code{repoDir} specified in \link{setLocalRepo}.
#' @param ...  Further parameters passed to \link[knitr]{kable} function. Used when \code{aformat = "kable"}.
#' @param aformat A character denoting whether to print history in either a \code{"regular"} (default) way or like in a \code{"kable"} function.
#' See Notes.
#' 
#' @return A data frame with two columns - names of calls and md5hashes of partial results.
#' 
#' @note There are provided functions (\code{print.ahistory} and \code{print.ahistoryKable}) to print the artifact's history. 
#' History can be printed either in a \code{regular} way which is friendy for the console output or in a \code{kable} format which 
#' prints the artifact's history in a way \link[knitr]{kable} function would. This is convenient when one prints history
#' in \code{.Rmd} files using \link[rmarkdown]{rmarkdown}
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' @examples
#' \dontrun{
#' 
#' createEmptyRepo("ahistory_check", default = TRUE)
#' aoptions("silent", TRUE)
#' library(dplyr)
#' iris %a%
#' filter(Sepal.Length < 6) %a%
#'  lm(Petal.Length~Species, data=.) %a%
#'  summary() -> artifact
#'  
#' ahistory(artifact)
#' ahistory(artifact, aformat = "kable")  
#' print(ahistory(artifact, aformat = "kable"), format = "latex")
#' 
#' repoDir <- file.path(getwd(), "ahistory_check")
#' deleteRepo(repoDir, deleteRoot = TRUE)
#' 
#' }
#' @family archivist
#' @rdname ahistory
#' @export

ahistory <- function(artifact = NULL, md5hash = NULL, repoDir = NULL, aformat = "regular") {
  # if artifact is set then calculate md5hash for it
  if (!is.null(artifact)) 
    md5hash = digest(artifact)
  if (is.null(md5hash)) 
    stop("Either artifact or md5hash has to be set")
  
  stopifnot(length(aformat) == 1 & aformat %in% c("regular", "kable"))
  
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
        if (aformat == "kable") {
          class(df) = c("ahistoryKable", "data.frame")  
        } else {
          class(df) = c("ahistory", "data.frame")  
        }
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
  if (aformat == "kable") {
    class(df) = c("ahistoryKable", "data.frame")  
  } else {
    class(df) = c("ahistory", "data.frame")  
  }
  
  df
}


#' @export

print.ahistory <- function(x, ...) {
  x[,2] <- paste0(x[,2], sapply(max(nchar(x[,2])) + 1 - nchar(x[,2]), 
                                function(j) paste(rep(" ", j), collapse="")))
  for (i in nrow(x):1) {
    if (i < nrow(x)) cat("-> ") else cat("   ")
    cat(x[i,2], " [", x[i,1], "]\n", sep = "")
  }
}

#' @export

print.ahistoryKable <- function(x, ...){
  if (!requireNamespace("knitr", quietly = TRUE)) {
    stop("knitr package required for archivist:::print.ahistoryKable function")
  }
  cat(knitr::kable(x[nrow(x):1, 2:1], ...), sep="\n")
}
