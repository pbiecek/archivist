##    archivist package for R
##
#' @title Split Tags in Repository
#'
#' @description
#' \code{splitTagsLocal} and \code{splitTagsGithub} functions split \code{tag} column from
#' \emph{tag} table placed in \code{backpack.db} into two separate columns:
#' \code{tagKey} and \code{tagValue}.
#' 
#' @details
#' \code{tag} column from \emph{tag} table has normally the follwing structure:
#' \code{TagKey:TagValue}. \code{splitTagsLocal} and \code{splitTagsGithub} functions
#' can be used to split \code{tag} column into two separate columns:
#' \code{tagKey} and \code{tagValue}. As a result functions from \code{dplyr} package
#' can be used to easily summarize, search, and extract artifacts' Tags.
#' See \code{examples}.
#' 
#' @param repoDir While working with the local repository. A character denoting 
#' an existing directory of the Repository. If it is set to \code{NULL} (by default),
#' it will use the \code{repoDir} specified in \link{setLocalRepo}.
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
#' @param repoDirGit While working with the Github repository. A character containing
#' a name of a directory on the Github repository on which the Repository is stored.
#' If the Repository is stored in the main folder of the Github repository,
#' this should be set to \code{repoDirGit = FALSE} as default.
#' 
#' @return
#' A \code{data.frame} with 4 columns: \code{artifact}, \code{tagKey},
#' \code{tagValue} and \code{createdDate}, corresponding to the current state of \link{Repository}.
#' 
#' @note
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in the Github mode
#' then global parameters set in \link{setGithubRepo} function are used.
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
#' # Creating example default repository
#' exampleRepoDir <- tempfile()
#' createEmptyRepo( exampleRepoDir, default = TRUE )
#' 
#' # Adding new artifacts to repository
#' data(iris)
#' saveToRepo(iris, repoDir = exampleRepoDir )
#' library(datasets)
#' data(iris3)
#' saveToRepo(iris3)
#' data(longley)
#' saveToRepo(longley)
#' 
#' # Let's see the difference in tag table in backpack.db
#' showLocalRepo( method = "tags" ) # a data frame with 3 columns
#' splitTagsLocal()                 # a data frame with 4 columns
#'
#' # Now we can sum up what kind of Tags we have in our repository.
#' library(dplyr)
#' splitTagsLocal() %>%
#'   group_by(tagKey) %>%
#'   summarise(count = n())
#'    
#' # Deleting existing repository
#' deleteRepo(exampleRepoDir, deleteRoot = TRUE)
#' rm(exampleRepoDir)
#' 
#' ## Example with Tag that does not match TagKey:TagValue structure
#' 
#' # Creating example default repository
#' exampleRepoDir <- tempfile()
#' createEmptyRepo( exampleRepoDir, default = TRUE )
#' data(iris)
#' # adding special Tag "lengthOne" to iris artifact and saving to repository
#' saveToRepo(iris, repoDir = exampleRepoDir, 
#'            userTags = "lengthOne")
#'            
#' # Let's see the difference in tag table in backpack.db
#' showLocalRepo(method = "tags")
#' splitTagsLocal() 
#' # We can see that splitTagsLocal added tagKey = userTags to "lengthOne" Tag.
#' 
#' # Deleting existing repository
#' deleteRepo(exampleRepoDir, deleteRoot = TRUE)
#' rm(exampleRepoDir)
#' 
#' ## Github Version
#' # Let's check how does table tag look like while we are using the
#' # Gitub repository.
#' # We will choose only special columns of data frames that show Tags
#' showGithubRepo( user = "pbiecek", repo = "archivist", method = "tags" )[,2]
#' splitTagsGithub( user = "pbiecek", repo = "archivist" )[,2:3]
#' 
#' }
#' @family archivist
#' @rdname splitTags
#' @export
splitTagsLocal <- function( repoDir = NULL ){
  
  splitTags( repoDir = repoDir )
  
}


#' @rdname splitTags
#' @export
splitTagsGithub <- function( repo = NULL, user = NULL, branch = "master",
                              repoDirGit = FALSE ){ 
  
  splitTags( repo = repo, user = user, branch = branch, repoDirGit = repoDirGit,
              local = FALSE )
  
}

splitTags <- function( repoDir = NULL, repo = NULL, user = NULL,
                        branch = "master", repoDirGit = FALSE,
                        local = TRUE ){  
  # We will expand tag table in backpack.db
  if (local) {
    showLocalRepo( repoDir = repoDir, method = "tags" ) -> tags_df
  } else {
    showGithubRepo( repo = repo, user = user, branch = branch,
                    repoDirGit = repoDirGit,
                    method = "tags" ) -> tags_df
  }
  
  if (nrow(tags_df) == 0 & local) {
    stop("There were no Tags for this Repository. Try showLocalRepo(method='tags') to ensure there are any Tags.")
  }
  if (nrow(tags_df) == 0 & !local) {
    stop("There were no Tags for this Repository. Try showGithubRepo(method='tags') to ensure there are any Tags.")
  }
  
  # We will split tag column into tagKey and tagValue columns
  strsplit(tags_df$tag, ":") %>%
    lapply( function(element){
      if (length(element) > 2) {
        # in case of Tags with TagKey = date
        element[2] <- paste0(element[-1], collapse = ":")
        element <- element[1:2]
      } else if (length(element) == 1){ 
        # when a user gives Tag which does not match "TagKey:TagValue" structure
        element <- c("userTags", element)
      } else if (length(element) == 0){ 
        # when a user gives Tag which is a character of length 0 :)
        element <- c("userTags", "")
      }
      element
    }) %>% 
    simplify2array %>%
    t %>%
    cbind(tags_df) -> tags_df
  tags_df <- tags_df[, c(3,1,2,5)]
  names(tags_df)[2:3] <- c("tagKey", "tagValue")
  
  tags_df
}