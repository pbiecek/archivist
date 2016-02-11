parametrizeRepo <- function(repoDir = NULL, repo = NULL, user = NULL,
                            branch = "master", repoDirGit = FALSE,
                            create = FALSE, set = FALSE, ...) {
  stopifnot((is.character(repoDir) & length(repoDir) == 1) | is.null(repoDir))
  stopifnot((is.character(repo) & length(repo) == 1) | is.null(repo))
  stopifnot((is.character(user) & length(user) == 1) | is.null(user))
  stopifnot((is.character(repoDir) & length(repoDir) == 1))
  stopifnot((is.character(repoDirGit) & length(repoDirGit) == 1) |
              is.logical(repoDirGit) & length(repoDirGit) == 1)
  stopifnot(is.logical(create) & length(create) == 1)
  stopifnot(is.logical(set) & length(set) == 1)
  
  if (is.character(repoDir)){
    repository <- list(repoDir = repoDir)
    class(repository) <- c("repository", "Local")
    if (create) {
      createEmptyLocalRepo(repoDir)
    }
    if (set) {
      setLocalRepo(repoDir = repoDir)
    }
    return(repository)
  } 
  if (is.character(repo) & is.character(user)) {
    repository <- list(repo = repo,
                       user = user,
                       branch = branch,
                       repoDirGit = repoDirGit)
    class(repository) <- c("repository", "GitHub")
    if (create) {
      createEmptyGithubRepo(repoName = repo, ...) 
      # zmienic parametr repoName na repo w createEmptyGithubRepo
      # dodac parametr repoLocal 
    }
    if (set) {
      setGithubRepo(user = user, repo = repo,
                    branch = branch, repoDirGit = repoDirGit)
    }
    return(repository)
  }
    
  warning("Couldn't parametrize Repository. 
Please provide at least one of 'repoDir' or ('user' and 'repo') parameters.")
}

############################################################################
############################################################################
############################################################################
############################################################################


createRepo <- function(repository, set = FALSE, ...){
  stopifnot('repository' %in% class(repository))
  stopifnot(is.logcial(set) & length(set) == 1)
  
  if ('Local' %in% class(repository)) {
    createEmptyLocalRepo(repoDir = repository$repoDir, default = set)
    return(invisible(NULL))
  }
  if ('GitHub' %in% class(repository)) {
    createEmptyGithubRepo(repoName = repository$repo,
                          user = repository$user, ..., default = set)
    # zmienic parametr repoName na repo w createEmptyGithubRepo
  }
}

############################################################################
############################################################################
############################################################################
############################################################################

searchInRepo <- function(pattern, repository = NULL, fixed){
  stopifnot('repository' %in% class(repository))
  
  if (is.null(repository)) {
    repository <- aoptions('repository')
  }
    
  if ('Local' %in% class(repository)) {
    # here parameters are checked inside searchInLocalRepo
    searchInLocalRepo(pattern = pattern, repoDir = repository$repoDir, 
                      fixed = fixed)
  }
  if ('Github' %in% class(repository)) {
    # here parameters are checked inside searchInGithubRepo
    searchInGithubRepo(pattern = patter, repo = repository$repo,
                       user = repository$user, branch = repository$branch,
                       repoDirGit = repository$repoDirGit, fixed = fixed)
  }
}

############################################################################
############################################################################
############################################################################
############################################################################


reparametrizeRepo <- function(repository, value, key){
  stopifnot('repository' %in% class(repository))
  repository[[value]] <- key
  repository
}
