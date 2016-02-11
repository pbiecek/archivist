##    archivist package for R
##
#' @title Create the Summary for Each Artifact in a Markdown Format
#'
#' @description
#' \code{createMDGallery} creates a summary for each artifact from \link{Repository} stored on a GitHub.
#' For each artifact tihd function creates a markdown file with: the download link, artifact's \link{Tags} (when \code{addTags = TRUE}) and
#' miniature (\code{addMiniature = TRUE}) if the artifact was archived with it's miniature and \code{Tags}. The miniature is a \link{print}
#'  or \link{head} over an artifact or it's \code{png} when it was a plot. But this function only supports \code{png} miniatures.
#'
#' @param repoType A character containing a type of the remote repository. Currently it can be 'github' or 'bitbucket'.
#'
#' @param repo A character containing a name of the Remote repository on which the Repository is stored.
#' By default set to \code{NULL} - see \code{Note}.
#'
#' @param user A character containing a name of the Github user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}.
#'
#' @param branch A character containing a name of
#' the Remote Repository's branch on which the Repository is stored. Default \code{branch} is \code{master}.
#'
#' @param subdir A character containing a name of a directory on the Remote repository
#' on which the Repository is stored. If the Repository is stored in the main folder of the Remote repository, this should be set
#' to \code{subdir = "/"} as default.
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
#' @note
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in the Remote mode then global parameters
#' set in \link{setRemoteRepo} (or via \link{aoptions}) function are used.
#'
#' @author
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#'
#' createMDGallery(user = 'MarcinKosinski', repo = 'Museum',
#'  'README_test1.md', addTags = TRUE)
#' createMDGallery('graphGallery', 'pbiecek', addMiniature = TRUE,
#'  'README_test2.md', addTags = TRUE)
#'
#' }
#'
#' @family archivist
#' @rdname createMDGallery
#' @export
createMDGallery <- function(output, repo = aoptions("repo"), user = aoptions("user"), branch = aoptions("branch"), subdir = aoptions("subdir"),
                                  repoType = aoptions("repoType"),
                                addTags = FALSE, addMiniature = FALSE){
  stopifnot(is.logical(c(addTags, addMiniature)) & length(addTags) == 1 & length(addMiniature) == 1 )

  RemoteRepoCheck( repo, user, branch, subdir, repoType) # implemented in setRepo.R

  # as in loadFromRemoteRepo
  remoteHook <- getRemoteHook(repo=repo, user=user, branch=branch, subdir=subdir, repoType=repoType)
  Temp <- downloadDB(remoteHook )
  on.exit( unlink( Temp, recursive = TRUE, force = TRUE) )
  md5hashList <- executeSingleQuery( dir = Temp, 
                                     "SELECT DISTINCT artifact, tag FROM tag ")#WHERE tag LIKE 'name%'" )

  if (addMiniature) {
    req <- GET(paste0("https://api.github.com/repos/", user, "/", repo, "/git/trees/master?recursive=1"))
    stop_for_status(req)
    filelist <- unlist(lapply(content(req)$tree, "[", "path"), use.names = F)
    # artifacts in a required directory with png miniature
    pattern <- paste0("^",
                      ifelse(subdir == "/",
                             "gallery",
                             file.path(subdir, "gallery") ))
    grep(filelist, pattern=pattern, value = TRUE) -> repoList
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
              ifelse(subdir == "/",
                     "gallery/",
                     file.path(subdir, "gallery/")),
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
