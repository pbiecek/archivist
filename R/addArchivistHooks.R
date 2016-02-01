##    archivist package for R
##
#' @title Add Archivist Hooks to Report
#'
#' @description
#' \code{addHooksToPrint} adds an overloaded version of the print function for objects of selected class. 
#' The overloaded function will add all object of selected class to the repo and then add hooks to the report for these objects .
#' 
#' @param class A character containing a name of class (one or more) that should be archivised.
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
#' addHooksToPrint(class="ggplot", repoDir = "arepo",
#' repo="graphGallery", user="pbiecek")
#' }
#' @family archivist
#' @rdname addHooksToPrint
#' @export

addHooksToPrint <- function(class = "ggplot",
  repoDir = aoptions("repoDir"), 
  repo = aoptions("repo"), user = aoptions("user"), branch = "master", repoDirGit = aoptions("repoDirGit")
  ){
  stopifnot( is.character( class ), 
             is.character( repoDir ), 
             is.character( repo ), 
             is.character( user ) )
  
  # set local repo to repoDir
  if (!file.exists( repoDir )) 
    createEmptyLocalRepo(repoDir)  
  setLocalRepo(repoDir)
  
  for (class1 in class) {
    namespace <- gsub(grep(getAnywhere(paste0("print.",class1))$where, 
                           pattern="namespace:", value=T), 
                      pattern="namespace:", replacement="")
    
    if (length(namespace) == 0) {
      stop(paste0("The function print.",class1, " has not been found."))
    }
    
    fun <- paste0('function(x, ...) {
    hash <- saveToRepo(x)
    al <- alink(hash, repo = "',repo,'", user = "',user,'", repoDirGit = ',ifelse(repoDirGit == FALSE, FALSE, paste0('"',repoDirGit,'"')),')
    cat("Load: ", al, "\n", sep="")
    ',namespace,':::print.',class1,'(x, ...)
  }')
    
    fun <- eval(parse(text=fun))
    assign(paste0("print.", class1), fun, pos=.GlobalEnv)
  }
}

