##    archivist package for R
##
#' @title Create the Summary for Each Artifact in a Markdown Format
#'
#' @description
#' \code{createGithubMDGallery} creates a summary for each artifact from \link{Repository} stored on a GitHub.
#' For each artifact tihd function creates a markdown file with: the download link, artifact's \link{Tags} (when \code{addTags = TRUE}) and
#' miniature (\code{addMiniature = TRUE}) if the artifact was archived with it's miniature and \code{Tags}. The miniature is a \link{print}
#'  or \link{head} over an artifact or it's \code{png} when it was a plot. But this function only supports \code{png} miniatures.
#' 
#' @param repo A character containing a name of the Github repository on which the Repository is stored.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param user A character containing a name of the Github user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}.
#'
#' @param branch A character containing a name of 
#' the Github Repository's branch on which the Repository is stored. Default \code{branch} is \code{master}.
#'
#' @param repoDirGit A character containing a name of a directory on the Github repository 
#' on which the Repository is stored. If the Repository is stored in the main folder of the Github repository, this should be set 
#' to \code{repoDirGit = FALSE} as default.
#'
#' @param output A name of the file in which artifacts should be summarized.
#' 
#' @param addTags Logical, whether to add artfiact's \link{Tags} to the \code{output}.
#' 
#' @param addMiniature Logical, whether to add artfiact's \code{miniature/plots} to the \code{output}.
#'   
#' @details
#' 
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @seealso
#' 
#' Markdown example: \url{https://github.com/pbiecek/archivist/issues/144#issuecomment-174192366}
#' 
#' @note#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in the Github mode then global parameters
#' set in \link{setGithubRepo} (or via \link{aoptions}) function are used.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#' 
#' createGithubMDGallery(user = 'MarcinKosinski', repo = 'Museum',
#'  'README_test7.md', addTags = TRUE)
#' createGithubMDGallery('graphGallery', 'pbiecek', addMiniature = TRUE,
#'  'README_test7.md', addTags = TRUE)
#' 
#' }
#' 
#' @family archivist
#' @rdname createMDGallery
#' @export
createGithubMDGallery <- function(output, repo = NULL, user = NULL, repoDirGit = FALSE,  branch = "master",
                                addTags = FALSE, addMiniature = FALSE){
  stopifnot( is.character( branch ), length( branch ) == 1 )
  GithubCheck( repo, user, repoDirGit ) # implemented in setRepo.R
  stopifnot(is.logical(c(addTags, addMiniature)) & length(addTags) == 1 & length(addMiniature) == 1 )
  
  # as in loadFromGithubRepo
  Temp <- downloadDB( repo, user, branch, repoDirGit )
  on.exit( file.remove( Temp ) )
  md5hashList <- executeSingleQuery( dir = Temp, realDBname = FALSE,
                                     "SELECT DISTINCT artifact, tag FROM tag ")#WHERE tag LIKE 'name%'" )
  
  if (addMiniature) {
    req <- GET(paste0("https://api.github.com/repos/", user, "/", repo, "/git/trees/master?recursive=1"))
    stop_for_status(req)
    filelist <- unlist(lapply(content(req)$tree, "[", "path"), use.names = F)
    # artifacts in a required directory with png miniature
    filelist[substr(filelist,1, nchar(ifelse(repoDirGit, file.path("gallery", repoDirGit), "gallery/"))) ==
             ifelse(repoDirGit, file.path("gallery", repoDirGit), "gallery/")] -> repoList
  }
  
  
  #md5hashes <- as.character( md5hashList[, 1] )
  # let's create output file
  if (!file.exists(output)) {
    file.create(output)
  }
  sink(output)
  cat("# Summary of artifacts \n\n ")
  for(md5 in unique(md5hashList$artifact)) {
    cat(alink(md5, repo = repo, user = user), sep = "\n\n")
    if (addMiniature) {
      if (any(grepl(paste0(md5,".png"), repoList))) {
        cat("\n")
        cat(paste0("![", md5, " miniature](https://raw.githubusercontent.com/",
              user,
              "/",
              repo,
              "/",
              branch,
              "/",
              ifelse(repoDirGit,
                     paste0("gallery", repoDirGit),
                     "gallery/"), 
              md5, ".png)"))
        cat("\n")
      }
    }
    if (addTags) {
      cat("```{R} \n")
      cat(md5hashList$tag[md5hashList$artifact == md5], sep = "\n")
      cat("``` \n")
    }
    
    
  }
  sink()
}


