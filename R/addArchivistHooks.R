##    archivist package for R
##
#' @title Add Archivist Hooks to Report
#'
#' @description
#' \code{addArchivistHook} adds a generic version of the print function for objects of selected class. 
#' The generic function will add all object of selected class to the repo and then add hooks to the report for these objects .
#' 
#' @param class A character containing a name of class that should be archivised.
#' @param repo A character containing a name of a Git repository on which the Repository is archived.
#' @param user A character containing a name of a Git user on whose account the \code{repo} is created.
#' @param branch A character containing a name of Git Repository's branch on which the Repository is archived. 
#' Default \code{branch} is \code{master}.
#' @param repoDirGit A character containing a name of a directory on Git repository 
#' on which the Repository is stored. If the Repository is stored in main folder on Git repository, this should be set 
#' to \code{repoDirGit = FALSE} as default.
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#'  
#' @examples
#' 
#' \dontrun{
#' # only in Rmd report
#' addArchivistHook(class="ggplot", repoDir = "arepo",
#' repo="graphGallery", user="pbiecek")
#' }
#' @family archivist
#' @rdname addArchivistHook
#' @export

addArchivistHook <- function(class = "ggplot",
  repoDir = NULL, 
  repo = NULL, user = NULL, branch = "master", repoDirGit = FALSE
  ){
  
  # set local repo to repoDir
  if (!file.exists( repoDir )) 
    createEmptyLocalRepo(repoDir)  
  setLocalRepo(repoDir)
  
  namespace <- gsub(grep(getAnywhere(paste0("print.",class))$where, 
                         pattern="namespace:", value=T), 
                    pattern="namespace:", replacement="")
  
  if (length(namespace) == 0) {
    stop(paste0("The function print.",class, " has not been found."))
  }
  
  fun <- paste0('function(x, ...) {
    hash <- saveToRepo(x)
    al <- alink(hash, repo = "',repo,'", user = "',user,'", repoDirGit = ',ifelse(repoDirGit == FALSE, FALSE, paste0('"',repoDirGit,'"')),')
    cat("Load: ", al, "\n", sep="")
    ',namespace,':::print.',class,'(x, ...)
  }')
  
  fun <- eval(parse(text=fun))
  assign(paste0("print.", class), fun, pos=.GlobalEnv)
}

