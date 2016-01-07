##    archivist package for R
##
#' @title Delete the Existing Repository from the Given Directory
#'
#' @description
#' \code{deleteRepo} deletes the existing \link{Repository} from the given directory.
#' As a result all artifacts from \code{gallery} folder are removed and database \code{backpack.db}
#' is deleted. \code{deleteGithubRepo} can delete whole GitHub-Repository or only archivist-like Repository
#' stored on a GitHub-Repository (then it requires more parameters to be specified).
#' To learn more about  \code{Archivist Integration With GitHub API} visit
#'  \link{archivist-github-integration} (\link{agithub}).
#'  
#' @param repoDir A character that specifies the directory for the Repository
#' which is to be deleted.
#' @param deleteRoot A logical value that specifies if the repository root directory
#' should be deleted for Local Repository or for GitHub whether to delete whole GitHub-Repository.
#' @param unset A logical. If deleted \code{repoDir/repo} was set to be default Local/GitHub Repository
#' and \code{unset} is TRUE, then \code{repoDir/repo} is unset as a default Local/GitHub Repository (\code{aoptions('repoDir/repo', NULL)}).
#' @param repo While working with a Github repository. A character denoting GitHub repository name to be deleted.
#' @param github_token While working with a Github repository. An OAuth GitHub Token created with the \link{oauth2.0_token} function. To delete GitHub Repository you
#' need to have \code{delete_repo} scope set - see examples. See \link{archivist-github-integration}.
#' Can be set globally with \code{aoptions("github_token", github_token)}.
#' @param user While working with a Github repository. A character denoting GitHub user name. Can be set globally with \code{aoptions("user", user)}.
#'  See \link{archivist-github-integration}.
#' @param response A logical value. Should the GitHub API response be returned (only when \code{deleteRoot = TRUE}).
#' @param repoDirGit Only when \code{deleteRoot = FALSE}. Subdirectory in which the archivist-Repository is stored on a GitHub Repository.
#' If it's in main directory, then specify to \code{NULL} (default).
#' @param password Only when \code{deleteRoot = FALSE}. While working with a Github repository. A character denoting GitHub user password. Can be set globally with \code{aoptions("password", password)}.
#' See \link{archivist-github-integration}.
#' 
#' @details
#' 
#' To delete GitHub Repository you
#' need to have \code{delete_repo} scope set - see examples.
#' 
#' Since version 1.9 \code{deleteRepo} is a wrapper around \code{deleteLocalRepo} (in earlier versions deleteRepo) and \code{deleteGithubRepo}
#'  functions and by default triggers \code{deleteLocalRepo} to maintain consistency with the previous \pkg{archivist} versions (<1.9.0)
#'  where there was only \code{deleteRepo} which deleted local \code{Repository}. 
#' 
#' @note
#' Remember that using \code{tempfile()} instead of \code{tempdir()}
#' in examples section is crucial. \code{tempdir()} is existing directory
#' in which R works so calling \code{deleteRepo(exampleRepoDir, deleteRoot=TRUE)}
#' removes important R files. You can find out more information about this problem at 
#' \href{http://stackoverflow.com/questions/22325820/unlink-function-causing-an-error-for-consequent-and-plot-functions}{stackoverflow}
#' webpage.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#' 
#' ########################
#' #### GitHub version ####
#' ########################
#' 
#' library(httr)
#' myapp <- oauth_app("github",
#'                    key = app_key,
#'                    secret = app_secret)
#' github_token <- oauth2.0_token(oauth_endpoints("github"),
#'                                 myapp,
#'                                 scope = c("public_repo",
#'                                           "delete_repo"))
#' aoptions("github_token", github_token)
#' aoptions("user", user)
#' aoptions("password", password)
#' 
#' createEmptyGithubRepo("Museum")
#' deleteGithubRepo(repo = "Museum", deleteRoot = TRUE, response = TRUE)
#' 
#' ########################
#' #### Local version ####
#' ########################
#' 
#' # objects preparation
#' # data.frame object
#' data(iris)
#' 
#' # ggplot/gg object
#' library(ggplot2)
#' df <- data.frame(gp = factor(rep(letters[1:3], each = 10)),y = rnorm(30))
#' library(plyr)
#' ds <- ddply(df, .(gp), summarise, mean = mean(y), sd = sd(y))
#' myplot123 <- ggplot(df, aes(x = gp, y = y)) +
#'   geom_point() +  geom_point(data = ds, aes(y = mean),
#'                colour = 'red', size = 3)
#'                
#' # lm object                
#' model <- lm(Sepal.Length~ Sepal.Width + Petal.Length + Petal.Width, data= iris)
#' 
#' # agnes (twins) object 
#' library(cluster)
#' data(votes.repub)
#' agn1 <- agnes(votes.repub, metric = "manhattan", stand = TRUE)
#' 
#' # fanny (partition) object
#' x <- rbind(cbind(rnorm(10, 0, 0.5), rnorm(10, 0, 0.5)),
#'          cbind(rnorm(15, 5, 0.5), rnorm(15, 5, 0.5)),
#'           cbind(rnorm( 3,3.2,0.5), rnorm( 3,3.2,0.5)))
#' fannyx <- fanny(x, 2)
#' 
#' # lda object
#' library(MASS)
#'
#' Iris <- data.frame(rbind(iris3[,,1], iris3[,,2], iris3[,,3]),
#'                   Sp = rep(c("s","c","v"), rep(50,3)))
#' train <- c(8,83,115,118,146,82,76,9,70,139,85,59,78,143,68,
#'            134,148,12,141,101,144,114,41,95,61,128,2,42,37,
#'            29,77,20,44,98,74,32,27,11,49,52,111,55,48,33,38,
#'            113,126,24,104,3,66,81,31,39,26,123,18,108,73,50,
#'            56,54,65,135,84,112,131,60,102,14,120,117,53,138,5)
#' lda1 <- lda(Sp ~ ., Iris, prior = c(1,1,1)/3, subset = train)
#'
#' # qda object
#' tr <- c(7,38,47,43,20,37,44,22,46,49,50,19,4,32,12,29,27,34,2,1,17,13,3,35,36)
#' train <- rbind(iris3[tr,,1], iris3[tr,,2], iris3[tr,,3])
#' cl <- factor(c(rep("s",25), rep("c",25), rep("v",25)))
#' qda1 <- qda(train, cl)
#'
#' # glmnet object
#' library( glmnet )
#'
#' zk=matrix(rnorm(100*20),100,20)
#' bk=rnorm(100)
#' glmnet1=glmnet(zk,bk)
#'
#' 
#' # creating example Repository - on which examples will work
#' 
#' # save examples
#' 
#' exampleRepoDir <- tempfile()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' saveToRepo( myplot123, repoDir=exampleRepoDir )
#' saveToRepo( iris, repoDir=exampleRepoDir )
#' saveToRepo( model, repoDir=exampleRepoDir )
#' saveToRepo( agn1, repoDir=exampleRepoDir )
#' saveToRepo( fannyx, repoDir=exampleRepoDir )
#' saveToRepo( lda1, repoDir=exampleRepoDir )
#' saveToRepo( qda1, repoDir=exampleRepoDir )
#' saveToRepo( glmnet1, repoDir=exampleRepoDir )
#' 
#' 
#' # let's see how the Repository looks like: show
#' 
#' showLocalRepo( method = "md5hashes", repoDir = exampleRepoDir )
#' showLocalRepo( method = "tags", repoDir = exampleRepoDir )
#' 
#' # let's get information about that Repository
#' 
#' summaryLocalRepo( repoDir = exampleRepoDir )
#' 
#' # now let's delete the Repository without it's root
#' 
#' deleteRepo( repoDir = exampleRepoDir)
#' 
#' rm( exampleRepoDir )
#' 
#' ## Using deleteRoot = TRUE argument 
#'
#' # First we create default Repository on our computer
#' createEmptyRepo( repoDir = "defRepo", force = TRUE, default = TRUE )
#' saveToRepo( myplot123)
#' saveToRepo( iris)
#' saveToRepo( model)
#'
#' # Let's see how the Repository looks like: show
#' 
#' showLocalRepo( method = "md5hashes")
#' showLocalRepo( method = "tags")
#' 
#' # Let's get information about that Repository
#' 
#' summaryLocalRepo()
#' 
#' # Now let's delete the Repository and it's root folder by using
#' # deleteRoot = TRUE argument
#' 
#' deleteRepo(repoDir = "defRepo", deleteRoot = TRUE) 
#' # defRepo was completely deleted indeed! We may notice it on our computer.
#' #
#' # or if aoptions('repodir') == repodir then 
#' # deleteRepo(repoDir, deleteRoot = TRUE, unset = TRUE)
#' 
#' 
#' 
#' 
#' 
#' }
#' 
#' @family archivist
#' @rdname deleteRepo
#' @export
deleteRepo <- function(repoDir, repo,
                       github_token = aoptions("github_token"), 
                       user = aoptions("user"),
                       password = aoptions("password"),
                       unset = FALSE, 
                       deleteRoot = FALSE, 
                       repoDirGit = NULL, 
                       response = aoptions("response"),
                       type = "local"){
  stopifnot(is.character(type) & length(type) ==1 & type %in% c("local", "github"))
  if (type == "local") {
    deleteLocalRepo(repoDir = repoDir, deleteRoot = deleteRoot,
                    unset = unset)
  } else {
    deleteGithubRepo(repo = repo,
                     github_token = github_token, 
                     user = user,
                     password = password,
                     unset = unset, 
                     deleteRoot = deleteRoot, 
                     repoDirGit = repoDirGit,
                     response = response)
  }
} 

#' @rdname deleteRepo
#' @export
deleteLocalRepo <- function(repoDir, deleteRoot = FALSE, unset = FALSE){
  stopifnot( is.character( repoDir ), length( repoDir ) == 1 )
  
  repoDir <- checkDirectory( repoDir )
  
  x <- list.files( file.path( repoDir , "gallery") )
  sapply( x , function(x ){
       file.remove( file.path( repoDir, "gallery", x ) )
       })
  
  
  file.remove( file.path( repoDir, "backpack.db" ) )
  unlink( file.path( repoDir, "gallery" ), recursive = TRUE )    
  
  if (deleteRoot) {
    unlink( file.path(repoDir), recursive = TRUE )    
  }
  
  if (unset) {
    aoptions('repoDir', NULL)
  }
  
}

#' @rdname deleteRepo
#' @export
deleteGithubRepo <- function(repo,
                             github_token = aoptions("github_token"), 
                             user = aoptions("user"),
                             password = aoptions("password"),
                             unset = FALSE, 
                             deleteRoot = FALSE, 
                             repoDirGit = NULL, 
                             response = aoptions("response")) {
  stopifnot(is.character(repo) & length(repo) ==1)
  stopifnot(is.character(user) & length(user)==1)

  if (deleteRoot) {
    DELETE(url = file.path("https://api.github.com/repos",user,repo),
           config = httr::config(token = github_token)
    ) -> resp
  } else {
    tempfile() -> tmpDir
    # clone repo to tmpDir
    cloneGithubRepo(file.path("https://github.com/", user, repo), 
                    repoDir = tmpDir) -> clonedRepo
    # remove archivist-repository
    deleteLocalRepo(repoDir = file.path(tmpDir, 
                                   ifelse(is.null(repoDirGit), "", repoDirGit)
                                   ))
    # add changes to git 
    add(clonedRepo, c("backpack.db", "gallery/"))
    # message
    delete_commit <- commit(clonedRepo, "archivist Repository deletion.")
    # GitHub authorization
    # to perform pull and push operations
    cred <- git2r::cred_user_pass(user,
                                  password)
    # push archivist-like Repository deletion to GitHub
    push(clonedRepo,
         refspec = "refs/heads/master",
         credentials = cred)
    
  }
  
  if (unset) {
    aoptions('repo', NULL)
  }
  
  
  if (response & deleteRoot){
    return(resp)
  }
  
  
}




