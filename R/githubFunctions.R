##    archivist package for R
##
#' @title Archivist Integration With GitHub API
#' 
#' @description
#' Set of functions to integrate \link[archivist]{archivist-package} with
#' GitHub API \href{https://developer.github.com/v3/}{https://developer.github.com/v3/}.
#' 
#' It is possible to create new GitHub repository with an empty \pkg{archivist}-like \link{Repository}
#' with \link{createEmptyGithubRepo} function. 
#' 
#' \link{archive} stores artifacts in the Local
#' \code{Repository} and automatically pushes archived artifacts to the Github
#' \code{Repository} with which the local \code{Repository} is synchronized. 
#' 
#' \link{cloneGithubRepo} clones GitHub Repository into the local directory.
#' 
#' \link{deleteGithubRepo} can delete whole GitHub-Repository or only archivist-like Repository
#' stored on a GitHub-Repository
#' 
#' @details
#' 
#' To use this set of functionalities, one firstly has to authorize himselft to the GitHub API.
#' It can be done by creating \href{OAuth application on GitHub}{https://github.com/settings/developers}
#' (register new application). When application is created, one will have to copy its \code{Client ID} and
#' \code{Client Secret} and authorize his github user with this application by running those commands:
#'  \itemize{
#'    \item \code{myapp <- oauth_app("github", key = Client_ID, secret = Client_Secret)},
#'    \item \code{github_token <- oauth2.0_token(oauth_endpoints("github"), myapp, scope = "public_repo")}.
#'  } 
#' The \code{scope} limits can be found here 
#' \href{https://developer.github.com/v3/oauth/#scopes}{https://developer.github.com/v3/oauth/#scopes}.
#' Basically, this is how you grant an access to your application  and give permissions.
#' With such a token one is authorized and can work with GitHub API and \pkg{archivist}
#' functions devoted to GitHub integration.
#'  
#' To perform GitHub integration operations such as \code{push}, \code{pull}, \code{commit}, \code{add} etc.
#' a user has to pass his GitHub user name (\code{user.name} parameter), user email (\code{user.email}
#' parameter) and user password (\code{user.password} parameter). Those parameters can be set globbaly
#' with \code{aoptions("user.email", user.email)}, \code{aoptions("user.name", user.name)}
#' and \code{aoptions("user.password", user.password)}.
#'  
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
#'                                 scope = c("public_repo",
#'                                           "delete_repo"))
#' aoptions("github_token", github_token)
#' aoptions("name", user.name)
#' aoptions("password", user.password)
#' 
#' createEmptyGithubRepo("Museum")
#' createEmptyGithubRepo("Museum-Extras", response = TRUE)
#' createEmptyGithubRepo("Gallery", readme = NULL)
#' createEmptyGithubRepo("Landfill", repoDescription = "My models and stuff")                                                                
#'
#' }
#' @family archivist
#' @name archivist-github-integration
#' @aliases agithub
#' @docType class
invisible(NULL)