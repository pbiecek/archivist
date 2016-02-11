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
#' If \code{repo = NULL} then hooks will be added to files in local directories.
#' @param user A character containing a name of a Git user on whose account the \code{repo} is created.
#' @param branch A character containing a name of Git Repository's branch on which the Repository is archived. 
#' Default \code{branch} is \code{master}.
#' @param subdir A character containing a name of a directory on Git repository 
#' on which the Repository is stored. If the Repository is stored in main folder on Git repository, this should be set 
#' to \code{subdir = "/"} as default.
#' @param repoDir A character containing a name of Local Repository.
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#'  
#' @note
#' One can specify \code{userTags} as in \link{saveToLocalRepo} for artifacts by adding code{"tags"} attribute.
#' See note secion about that in \link{saveToLocalRepo}.
#'  
#' @examples
#' 
#' \dontrun{
#' # only in Rmd report, links to github repository
#' addHooksToPrint(class="ggplot", repoDir = "arepo",
#' repo="graphGallery", user="pbiecek")
#' # only in Rmd report, links to local files
#' addHooksToPrint(class="ggplot", repoDir = "arepo",
#' repo=NULL)
#' }
#' @family archivist
#' @rdname addHooksToPrint
#' @export

addHooksToPrint <- function(class = "ggplot",
                            repoDir = aoptions("repoDir"), 
                            repo = aoptions("repo"), user = aoptions("user"), branch = "master", subdir = aoptions("subdir")
){
  stopifnot( is.character( class ), 
             is.character( repoDir ), 
             (is.null(repo) || is.character( repo )), 
             is.character( user ) )
  
  # set local repo to repoDir
  if (!file.exists( repoDir )) 
    createLocalRepo(repoDir)  
  setLocalRepo(repoDir)
  
  for (class1 in class) {
    namespace <- gsub(grep(getAnywhere(paste0("print.",class1))$where, 
                           pattern="namespace:", value=T), 
                      pattern="namespace:", replacement="")
    
    if (length(namespace) == 0) {
      stop(paste0("The function print.", class1, " has not been found."))
    }
    
    if (is.null(repo)) { # local version
      fun <- paste0('function(x, ...) {
                  hash <- saveToRepo(x)
                    cat("Load: [",hash,"](", repoDir, "/gallery/",hash,".rda)\n", sep="")
                    ',namespace,':::print.',class1,'(x, ...)
    }')
    } else { # remote version
      fun <- paste0('function(x, ...) {
                  hash <- saveToRepo(x)
                  al <- alink(hash, repo = "',repo,'", user = "',user,'", subdir = "',subdir,'")
                  cat("Load: ", al, "\n", sep="")
                  ',namespace,':::print.',class1,'(x, ...)
    }')
    }

    fun <- eval(parse(text=fun))
    veryDirtyHack <- 1
    assign(paste0("print.", class1), fun, pos=veryDirtyHack) # 1 should stand for Global Env
  }
  invisible(NULL)
}
