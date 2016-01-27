##    archivist package for R
##
#' @title Push Local Repository to GitHub
#'
#' @description
#' 
#' \code{pushRepo} add files, commits them and pushes from Local \link{Repository} to synchronized GitHub one.
#'  
#' @param repoDir A character specifing the directory to Local \code{Repository} from which artifacts will be pushed to GitHub.
#' @param commitMessage A character denoting a message added to the commit while performing push.
#' By default specified to \code{NULL} which corresponds to commit message \code{archivist: pushRepo}.
#' @param repo A character denoting GitHub repository name and synchronized local existing directory in which an artifact will be saved.
#' @param user A character denoting GitHub user name. Can be set globally with \code{aoptions("user", user)}.
#'  See \link{archivist-github-integration}.
#' @param password A character denoting GitHub user password. Can be set globally with \code{aoptions("password", password)}.
#' See \link{archivist-github-integration}.
#' @param files A character vector containing directories to files that should be commited and pushed. The working directory
#' is \code{repoDir}. By default all uncommited artifacts and \code{backpack.db} will be pushed.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @examples 
#' \dontrun{
#' 
#' # TODO
#' 
#' }
#' @family archivist
#' @rdname pushRepo
#' @export
pushRepo <- function(repoDir = aoptions('repoDir'), 
                     commitMessage = aoptions("commitMessage"),
                     repo = aoptions("repo"), 
                     user = aoptions("user"),
                     password = aoptions("password"),
                     files = c("gallery", "backpack.db")) {
  stopifnot(is.character(repo) & length(repo) ==1)
  stopifnot(is.character(user) & length(user)==1)
  stopifnot(is.character(password) & length(password)==1)
                         
  repo <- git2r::repository(repoDir)
  
  git2r::add(repo, files)
  
  if (is.null(commitMessage)){
    new_commit <- commit(repo, "archivist: pushRepo")
  } else {
    new_commit <- commit(repo, commitMessage)
  }
    
  # authentication with GitHub
  cred <- cred_user_pass(user,
                         password)
  
  # wyslanie do repozytorium na githubie
  push(repo,
       #name = "upstream2",
       refspec = "refs/heads/master",
       credentials = cred)
}