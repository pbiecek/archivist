##    archivist package for R
##
#' @title Archivist Integration With GitHub API
#' 
#' @description
#' Set of functions to integrate \link[archivist]{archivist-package} with
#' GitHub API \href{https://developer.github.com/v3/}{https://developer.github.com/v3/}.
#' It is possible to create new GitHub repository with an empty \pkg{archivist}-like \link{Repository}
#' with \code{createEmptyGithubRepo} function.
#' 
#' @details
#' 
#' To use this set of functionalities, one first has to authorize himselft to the GitHub API.
#' It can be done by creating an \href{OAuth application on GitHub}{https://github.com/settings/developers}
#'  (register new application). When application is created, one will have to copy its \code{Client ID} and
#'  \code{Client Secret} and authorize his github user with this application with running those command
#'  \itemize{
#'    \item \code{myapp <- oauth_app("github", key = Client_ID, secret = Client_Secret)},
#'    \item \code{github_token <- oauth2.0_token(oauth_endpoints("github"), myapp, scope = "public_repo")}.
#'  } 
#'  The \code{scope} limits can be found here \href{https://developer.github.com/v3/oauth/#scopes}{https://developer.github.com/v3/oauth/#scopes}.
#'  Basically this is how you grant your application an access and give permissions. With such a token one
#'  is authorized and can work with GitHub API and \pkg{archivist} functions devoted to GitHub integration.
#'  
#' To perform GitHub integration operations such as \code{push}, \code{pull}, \code{commit}, \code{add} etc. a user
#' has to pass his GitHub user name (\code{user.name} parameter), user email (\code{user.email} parameter) and user password
#' (\code{user.password} parameter). Those parameters can be set globbaly with \code{aoptions("user.email", user.email)}, \code{aoptions("user.name", user.name)}
#' and \code{aoptions("user.password", user.password)}.
#'  
#' @param repoName A character denoting new GitHub repository name. White spaces will be substitued with a dash.
#' @param github_token An OAuth GitHub Token created with the \link{oauth2.0_token} function. See Details.
#' Can be set globally with \code{aoptions("github_token", github_token)}.
#' @param repoDescription A character specifing the new GitHub repository description.
#' @param user.name A character denoting GitHub user name. Can be set globally with \code{aoptions("user.name", user.name)}.
#'  See Details.
#' @param user.email A character denoting GitHub user email. Can be set globally with \code{aoptions("user.email", user.email)}.
#' See Details.
#' @param user.password A character denoting GitHub user password. Can be set globally with \code{aoptions("user.password", user.password)}.
#' See Details.
#' @param readmeDescription A character of the content of \code{README.md} file. By default a description of \link{Repository}.
#' Can be set globally with \code{aoptions("readmeDescription", readmeDescription)}. For no \code{README.md} file 
#' set \code{aoptions("readmeDescription", NULL)}.
#' 
#' @return
#' 
#' \code{createEmptyGithubRepo} creates a new GitHub repository with an empty \pkg{archivist}-like \link{Repository} and
#' also creates a local \code{Repository} with \link{createEmptyRepo} which is git-synchronized with
#' new GitHub repository.
#' 
#' @note
#' 
#' Note that global configuration of the \code{git config} is used for initial commit.
#' One can later specify local configuration for the repository with \link[git2r]{config}, e.g
#' \code{config(repoName, user.name = "Alice", user.email = "mail_at_gmail.com")}.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @examples
#' \dontrun{
#' library(httr)
#' myapp <- oauth_app("github",
#'                    key = app_key,
#'                    secret = app_secret)
#' github_token <- oauth2.0_token(oauth_endpoints("github"),
#'                                 myapp,
#'                                 scope = "public_repo")
#' aoptions("github_token", github_token)
#' aoptions("user.name", user.name)
#' aoptions("user.password", user.password)
#' 
#' createEmptyGithubRepo("Museum")
#' createEmptyGithubRepo("Museum-Extras", response = TRUE)
#' createEmptyGithubRepo("Gallery", readme = NULL)
#' createEmptyGithubRepo("Landfill", repoDescription = "My models and stuff")                                                                
#'
#' }
#' @aliases createEmptyGithubRepo
#' @family archivist
#' @rdname githubFunctions
#' @export
createEmptyGithubRepo <- function(repoName,
                                  github_token = aoptions("github_token"), 
                                  user.name = aoptions("user.name"),
                                  #user.email = aoptions("user.email"),
                                  user.password = aoptions("user.password"),
                                  repoDescription = aoptions("repoDescription"),
                                  readme = aoptions("readmeDescription"),
                                  response = aoptions("response")){
  stopifnot(is.character(repoName) & length(repoName) ==1)
  stopifnot(is.character(repoDescription) & length(repoDescription) ==1)
  #stopifnot(any(class(github_token) %in% "Token"))
  stopifnot(is.character(user.name) & length(user.name)==1)
  #stopifnot(is.character(user.email) & length(user.email)==1)
  stopifnot(is.character(user.password) & length(user.password)==1)
  stopifnot((is.character(readme) & length(readme)==1) |
              is.null(readme))
  
  repoName <- gsub(pattern = " ", "-", repoName)
  
  # httr imports are in archivist-package.R file
  # creating an empty GitHub Repository
  POST(url = "https://api.github.com/user/repos",
       encode = "json",
       body = list(
         name = jsonlite::unbox(repoName),
         description = jsonlite::unbox(repoDescription)
       ),
       config = httr::config(token = github_token)
  ) -> resp
  
  
  # git2r imports are in the archivist-package.R
  path <- repoName
  dir.create(path)
  
  # initialize local git repository
  # git init
  repo <- init(path)
  
  ## Create and configure a user
  # git config - added to Note section
  #git2r::config(repo, ...) # if about to use, the add to archivist-package.R
  
  # archivist-like Repository creation
  createEmptyRepo(repoDir = path)
  file.create(file.path(path, "gallery", ".gitkeep"))
  # git add
  if (!is.null(readme)){
    file.create(file.path(path, "README.md"))
    writeLines(aoptions("readmeDescription"), file.path(path, "README.md"))
    add(repo, c("backpack.db", "gallery/", "README.md"))
  } else {
    add(repo, c("backpack.db", "gallery/"))
  }
  
  # git commit
  new_commit <- commit(repo, "archivist Repository creation.")
  
  # association of the local and GitHub git repository
  # git add remote
  remote_add(repo,
             "upstream2",
             paste0("https://github.com/", user.name, "/", repoName, ".git"))
  
  # GitHub authorization
  # to perform pull and push operations
  cred <- cred_user_pass(user.name,
                         user.password)
  
  # push archivist-like Repository to GitHub repository
  push(repo,
       name = "upstream2",
       refspec = "refs/heads/master",
       credentials = cred)
  
  if (response){
    return(resp)
  }
}