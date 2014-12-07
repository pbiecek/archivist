##    archivist package for R
##
#' @title View the Lisf of Artifacts from a Repository 
#'
#' @description
#' \code{showLocalRepo} and \code{showGithubRepo} functions produce the \code{data.frame} of the artifacts from
#' a \link{Repository} saved in a given \code{repoDir} (directory). \code{showLocalRepo}
#' shows the artifacts from the \code{Repository} that exists on the user's computer, whereas \code{showGithubRepo}
#' shows the artifacts of the \code{Repository} existing on a Github repository.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' \code{showLocalRepo} and \code{showGithubRepo} functions produce the \code{data.frame} of the artifacts from
#' a \link{Repository} saved in a given \code{repoDir} (directory). \code{showLocalRepo}
#' shows the artifacts from the \code{Repository} that exists on the user's computer, whereas \code{showGithubRepo}
#' shows the artifacts of the \code{Repository} existing on a Github repository.
#' 
#' Both functions show the current state of a \code{Repository}, inter alia, all archived artifacts can
#' be seen with their unique \link{md5hash} or a \code{data.frame} with archived \link{Tags} can 
#' be obtained. Also there is an extra column with a date of creation the \code{Tag} or the \code{md5hash}.
#' 
#' @param method A character specifying the method to be used to show the Repository. Available methods: 
#' \code{md5hashes} (default), \code{tags}.
#' 
#' @param repoDir A character denoting an existing directory of a Repository for which a summary will be returned.
#' If set to \code{NULL} (by default), uses the \code{repoDir} specified in \link{setLocalRepo}.
#' 
#' @param repo Only if working with a Github repository. A character containing a name of a Github repository on which the Repository is archived.
#' By default set to \code{NULL} - see \code{Note}.
#' @param user Only if working with a Github repository. A character containing a name of a Github user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}.
#' @param branch Only if working with a Github repository. A character containing a name of 
#' Github Repository's branch on which a Repository is archived. Default \code{branch} is \code{master}.
#'
#' @param repoDirGit Only if working with a Github repository. A character containing a name of a directory on Github repository 
#' on which the Repository is stored. If the Repository is stored in main folder on Github repository, this should be set 
#' to \code{repoDirGit = FALSE} as default.
#' 
#' @return
#' 
#' If parameter \code{method} was set as \code{md5hashes} a \code{data.frame} with artifacts' names and archived
#' \code{md5hashes} is returned.
#' 
#' If parameter \code{method} was set as \code{tags} a \code{data.frame} with archived \code{Tags} and archived
#' artifacts' \code{md5hashes} is returned.
#' 
#' To learn more about \code{Tags} or \code{md5hashes} check: \link{Tags} or \link{md5hash}.
#' 
#' 
#' @note
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in Github mode then global parameters
#' set in \link{setGithubRepo} function are used.
#' 
#' @author 
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' # objects preparation
#' \dontrun{
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
#' # creating example Repository - that examples will work
#' 
#' exampleRepoDir <- tempdir()
#' createEmptyRepo(repoDir = exampleRepoDir)
#' saveToRepo(myplot123, repoDir=exampleRepoDir)
#' saveToRepo(iris, repoDir=exampleRepoDir)
#' saveToRepo(model, repoDir=exampleRepoDir)
#'
#' # show examples
#'
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # let's add more artifacts
#'
#' saveToRepo(glmnet1, repoDir=exampleRepoDir)
#' saveToRepo(lda1, repoDir=exampleRepoDir)
#' (qda1Md5hash <- saveToRepo(qda1, repoDir=exampleRepoDir))
#' 
#' # show now
#' 
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # what if we remove an artifact
#' 
#' rmFromRepo(qda1Md5hash, repoDir = exampleRepoDir)
#'
#' # show now
#' 
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # GitHub version
#' 
#' showGithubRepo(method = "md5hashes", user = "pbiecek", repo = "archivist")
#' showGithubRepo(method = "tags", user = "pbiecek", repo = "archivist", branch = "master")
#' 
#' # removing an example Repository
#'   
#' deleteRepo( exampleRepoDir )
#'   
#' rm( exampleRepoDir )
#' 
#' # many archivist-like Repositories on one Github repository
#' 
#' showGithubRepo( user="MarcinKosinski", repo="Museum", branch="master",
#' repoDirGit="ex1")
#' showGithubRepo( user="MarcinKosinski", repo="Museum", branch="master",
#'                 repoDirGit="ex2")
#' 
#' }
#' @family archivist
#' @rdname showRepo
#' @export
showLocalRepo <- function( repoDir = NULL, method = "md5hashes" ){
  stopifnot( is.character( method ) )
  stopifnot( is.character( repoDir ) | is.null( repoDir ) )
  
  repoDir <- checkDirectory( repoDir )
  
  showRepo( method = method, dir = repoDir )
}


#' @rdname showRepo
#' @export
showGithubRepo <- function( repo = NULL, user = NULL, branch = "master", repoDirGit = FALSE,
                            method = "md5hashes" ){
  stopifnot( is.character( c( method, branch ) ) )
  
  GithubCheck( repo, user, repoDirGit ) # implemented in setRepo.R
  
  # database is needed to be downloaded
  Temp <- downloadDB( repo, user, branch, repoDirGit )
  
  showRepo( method = method, dir = Temp, local = FALSE )
}


showRepo <- function( method, local = TRUE, dir ){
  
  if ( method == "md5hashes" )
    value <- readSingleTable( dir, "artifact", realDBname = local )
  
  if ( method == "tags" )
    value <- readSingleTable( dir, "tag", realDBname = local )
  
  return( value )
}