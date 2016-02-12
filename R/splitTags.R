##    archivist package for R
##
#' @title Split Tags in Repository
#'
#' @description
#' \code{splitTagsLocal} and \code{splitTagsRemote} functions split \code{tag} column from
#' \emph{tag} table placed in \code{backpack.db} into two separate columns:
#' \code{tagKey} and \code{tagValue}.
#' 
#' @details
#' \code{tag} column from \emph{tag} table has normally the follwing structure:
#' \code{TagKey:TagValue}. \code{splitTagsLocal} and \code{splitTagsRemote} functions
#' can be used to split \code{tag} column into two separate columns:
#' \code{tagKey} and \code{tagValue}. As a result functions from \code{dplyr} package
#' can be used to easily summarize, search, and extract artifacts' Tags.
#' See \code{examples}.
#' 
#' @param repoType A character containing a type of the remote repository. 
#' Currently it can be 'github' or 'bitbucket'.
#' 
#' @param repoDir While working with the local repository. A character denoting 
#' an existing directory of the Repository. 
#' 
#' @param repo While working with the Github repository. A character containing
#' a name of the Github repository on which the Repository is stored.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param user While working with the Github repository. A character containing
#' a name of the Github user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}.
#'
#' @param branch While working with the Github repository. A character containing
#' a name of the Github Repository's branch on which the Repository is stored.
#' Default \code{branch} is \code{master}.
#'
#' @param subdir While working with the Github repository. A character containing
#' a name of a directory on the Github repository on which the Repository is stored.
#' If the Repository is stored in the main folder of the Github repository,
#' this should be set to \code{subdir = "/"} as default.
#' 
#' @return
#' A \code{data.frame} with 4 columns: \code{artifact}, \code{tagKey},
#' \code{tagValue} and \code{createdDate}, corresponding to the current state of \link{Repository}.
#' 
#' @note
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in the Github mode
#' then global parameters set in \link{setRemoteRepo} function are used.
#' 
#' Sometimes we can use \code{addTags*} function or \code{userTags} parameter
#' in \code{saveToRepo} to specify a \code{Tag} which might not match
#' \code{TagKey:TagValue} structure. It is simply \code{Tag}. In this case 
#' \code{tagKey = userTags} and \code{tagValue = Tag}. See \code{examples}.
#' 
#' To learn more about \code{Tags} and \code{Repository} structure check 
#' \link{Tags} and \link{Repository}.
#' @author 
#' Witold Chodor , \email{witoldchodor@@gmail.com}
#'
#' @examples
#' \dontrun{
#' ## LOCAL VERSION 
#' 
#' setLocalRepo(system.file("graphGallery", package = "archivist"))
#' head(showLocalRepo(method = "tags"))
#' head(splitTagsLocal() )
#' 
#' ## Github Version
#' # Let's check how does table tag look like while we are using the
#' # Gitub repository.
#' # We will choose only special columns of data frames that show Tags
#' head(showRemoteRepo( user = "pbiecek", repo = "archivist", method = "tags" )[,2])
#' head(splitTagsRemote( user = "pbiecek", repo = "archivist" )[,2:3])
#' 
#' head(splitTagsRemote("PieczaraPietraszki", "BetaAndBit", "master", "UniwersytetDzieci/arepo"))
#' }
#' @family archivist
#' @rdname splitTags
#' @export
splitTagsLocal <- function( repoDir = aoptions("repoDir") ){
  splitTags( repoDir = repoDir )
}


#' @rdname splitTags
#' @export
splitTagsRemote <- function( repo = aoptions("repo"), user = aoptions("user"), 
                             branch = aoptions("branch"), subdir = aoptions("subdir"),
                             repoType = aoptions("repoType") ){ 
  
  splitTags( repo = repo, user = user, branch = branch, subdir = subdir, repoType = repoType,
              local = FALSE )
  
}

splitTags <- function( repoDir = NULL, repo = aoptions("repo"), user = aoptions("user"),
                        branch = "master", subdir = aoptions("subdir"), repoType = aoptions("repoType"),
                        local = TRUE ){  
  # We will expand tag table in backpack.db
  if (local) {
    showLocalRepo( repoDir = repoDir, method = "tags" ) -> tags_df
  } else {
    showRemoteRepo( repo = repo, user = user, branch = branch,
                    subdir = subdir,
                    method = "tags", repoType=repoType) -> tags_df
  }
  
  if (nrow(tags_df) == 0) {
    stop("There were no Tags for this Repository. Try ",
         ifelse(local, "showLocalRepo(method='tags')", "showRemoteRepo(method='tags')"),
         " to ensure there are any Tags.")
  }

  # We will split tag column into tagKey and tagValue columns
  tags_df$tagKey <- gsub(tags_df$tag, pattern=":.*$", replacement="") 
  tags_df$tagValue <- gsub(tags_df$tag, pattern="^[^:]*:", replacement="") 
  tags_df[,c("artifact", "tagKey", "tagValue", "createdDate")]
}
