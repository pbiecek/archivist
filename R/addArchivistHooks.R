##    archivist package for R
##
#' @title Add \pkg{archivist} Hooks to \pkg{rmarkdown} Reports
#'
#' @description
#' \code{addHooksToPrint} adds an overloaded version of the print function for objects of selected class. 
#' The overloaded function will add all objects of selected class to the \link{Repository} and then will add hooks (to the Remote or Local Repository) 
#' to the HTML report (generated in \pkg{rmarkdown}) for these objects (\code{artifacts} - \link{archivist-package}).
#' The great example can be seen in this blogpost \href{http://www.r-bloggers.com/why-should-you-backup-your-r-objects/}{http://www.r-bloggers.com/why-should-you-backup-your-r-objects/}.
#' 
#' @param class A character with a name of class (one or more) that should be archived.
#' @param repo A character with a name of a Remote repository on which the Repository is archived.
#' If \code{repo = NULL} then hooks will be added to files in local directories.
#' @param user A character with a name of a Remote-repository user on whose account the \code{repo} is created.
#' @param branch A character with a name of Remote-repository's branch on which the Repository is archived. 
#' Default \code{branch} is \code{master}.
#' @param subdir A character with a name of a subdirectory on a Remote repository 
#' on which the Repository is stored. If the Repository is stored in main folder on a Remote repository, this should be set 
#' to \code{subdir = "/"} as default.
#' @param repoDir A character containing a name of a Local Repository.
#' @param format A character denoting \code{format} as in \link{alink}.
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#'  
#' @template roxlate-references
#' @template roxlate-contact
#' @note
#' One can specify \code{userTags} as in \link{saveToLocalRepo} for artifacts by adding \code{"tags"} attribute.
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
                            repo = aoptions("repo"),
                            user = aoptions("user"),
                            branch = "master",
                            subdir = aoptions("subdir"),
                            format = "markdown"
){
  stopifnot( is.character( class ), 
             is.character( repoDir ), 
             (is.null(repo) || is.character( repo )), 
             is.character( user ) )
  
  # check is all print function exist
  # if any of them is not avaliable then stop
  for (class1 in class) {
    namespace <- gsub(grep(getAnywhere(paste0("print.",class1))$where, 
                           pattern="namespace:", value=T), 
                      pattern="namespace:", replacement="")
    if (length(namespace) == 0) {
      stop(paste0("The function print.", class1, " has not been found. Evaluation stopped for further classes."))
    }
  }
  
  # set local repo to repoDir
  if (!file.exists( repoDir )) 
    createLocalRepo(repoDir)  
  setLocalRepo(repoDir)
  
  for (class1 in class) {
    namespace <- gsub(grep(getAnywhere(paste0("print.",class1))$where, 
                           pattern="namespace:", value=T), 
                      pattern="namespace:", replacement="")
    
    if (is.null(repo)) { # local version
      fun <- paste0('function(x, ..., artifactName = deparse(substitute(x))) {
                  hash <- saveToRepo(x, artifactName = artifactName)
                    cat("Load: [",hash,"](", repoDir, "/gallery/",hash,".rda)\n", sep="")
                    ',namespace,':::print.',class1,'(x, ...)
    }')
    } else { # Remote version
      fun <- paste0('function(x, ..., artifactName = deparse(substitute(x))) {
                  hash <- saveToRepo(x, artifactName = artifactName)
                  al <- alink(hash, repo = "',repo,'", user = "',user,'", subdir = "',subdir,'", format = "',format,'")
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
