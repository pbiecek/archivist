##    archivist package for R
##
#' @title Show Artifact's History
#'
#' @description
#' \code{ahistory} extracts artifact's history and creates a data frame with  
#' history of calls and md5hashes of partial results. The overloaded 
#' \code{print.ahistory} function prints this history in a concise way. The overloaded
#' \code{print.ahistoryKable} function prints this history in the same way as \link[knitr]{kable}.
#' When \code{alink=TRUE} one can create history table/kable with hooks to partial results (artifacts) as in the \link{alink} function.
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
#' @param ...  Further parameters passed to \link{alink} function. Used when \code{format = "kable"} and \code{alink = TRUE}.
#' @param format A character denoting whether to print history in either a \code{"regular"} (default) way or like in a \code{"kable"} function.
#' See Notes.
#' @param alink Whether to provide hooks to objects like in \link{alink}. See examples.
#' 
#' @return A data frame with two columns - names of calls and md5hashes of partial results.
#' 
#' @note There are provided functions (\code{print.ahistory} and \code{print.ahistoryKable}) to print the artifact's history. 
#' History can be printed either in a \code{regular} way which is friendy for the console output or in a \code{kable} format which 
#' prints the artifact's history in a way \link[knitr]{kable} function would. This is convenient when one prints history
#' in \code{.Rmd} files using \link[rmarkdown]{rmarkdown}.
#' 
#' Moreover when user passes \code{format = 'kable'} and \code{alink = TRUE} then one can use links for remote Repository. 
#' Then mdhashes are taken from Local Repository, so user has to specify \code{repo}, \code{user} and \code{repoDir} even though 
#' they are set globally, because \code{repo} is a substring of \code{repoDir} and during evalutation of \code{...} R treats \code{repo} as \code{repoDir}.
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @examples
#' 
#' createLocalRepo("ahistory_check", default = TRUE)
#' library(dplyr)
#' iris %a%
#' filter(Sepal.Length < 6) %a%
#'  lm(Petal.Length~Species, data=.) %a%
#'  summary() -> artifact
#'  
#' ahistory(artifact)
#' ahistory(artifact, format = "kable")  
#' print(ahistory(artifact, format = "kable"), format = "latex")
#' ahistory(artifact, format = "kable", alink = TRUE, repoDir = "ahistory_check",
#' repo = "repo", user = "user")
#' 
#' 
#' repoDir <- file.path(getwd(), "ahistory_check")
#' deleteLocalRepo(repoDir, deleteRoot = TRUE)
#' aoptions('repoDir', NULL, unset = TRUE)
#' 
#' @family archivist
#' @rdname ahistory
#' @export

ahistory <- function(artifact = NULL, md5hash = NULL, repoDir = aoptions('repoDir'), format = "regular", alink = FALSE, ...) {
  # if artifact is set then calculate md5hash for it
  if (!is.null(artifact)) 
    md5hash = digest(artifact)
  if (is.null(md5hash)) 
    stop("Either artifact or md5hash has to be set")
  
  stopifnot(length(format) == 1 & format %in% c("regular", "kable"))
  
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
        if (format == "kable") {
          class(df) = c("ahistoryKable", "data.frame") 
          if (alink) {
            df$md5hash <- paste0("[",
                                df$md5hash,
                                "]",
                                sapply(df$md5hash, alink, ...) %>%
                                  as.vector() %>%
                                  strsplit(split = "]") %>%
                                  lapply(`[[`, 2)
            )
          }
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
  if (format == "kable") {
    class(df) = c("ahistoryKable", "data.frame")  
    if (alink) {
      df$md5hash <- paste0("[",
                           df$md5hash,
                           "]",
                           sapply(df$md5hash, alink, ...) %>%
                             as.vector() %>%
                             strsplit(split = "]") %>%
                             lapply(`[[`, 2)
      )
    }
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
