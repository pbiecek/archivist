##    archivist package for R
##
#' @title View the Summary of the Repository
#'
#' @description
#' \code{summaryRepo} summarizes the current state of the \link{Repository}.
#' 
#' @details
#' \code{summaryRepo} summarizes the current state of a \link{Repository}. Recommended to use
#' \code{print( summaryRepo ) )}. See examples.
#' 
#' @param repoType A character containing a type of the remote repository. Currently it can be 'github' or 'bitbucket'.
#' 
#' @param repoDir A character denoting an existing directory of the Repository for which a summary will be returned.
#' If it is set to \code{NULL} (by default), it will use the \code{repoDir} specified in \link{setLocalRepo}.
#' 
#' @param repo While working with the Remote repository. A character containing a name of the Remote repository on which the Repository is stored.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param user While working with the Remote repository. A character containing a name of the Remote user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}.
#'
#' @param branch While working with the Remote repository. A character containing a name of 
#' the Remote Repository's branch on which the Repository is stored. Default \code{branch} is \code{master}.
#' 
#' @param repoDirGit While working with the Remote repository. A character containing a name of a directory on the Remote repository 
#' on which the Repository is stored. If the Repository is stored in the main folder of the Remote repository, this should be set 
#' to \code{repoDirGit = FALSE} as default.
#'
#' @return An object of class \code{repository} which can be printed: \code{print(object)}.
#' 
#' @note If the same artifact was archived many times then it is counted as one artifact or database in \code{print(summaryRepo)}.
#' 
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in the Remote mode then global parameters
#' set in \link{setRemoteRepo} function are used.
#' @author 
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#' # objects preparation
#' 
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
#' # creating example Repository - on which examples will work
#' 
#' exampleRepoDir <- tempfile()
#' createEmptyRepo(repoDir = exampleRepoDir)
#' saveToRepo(myplot123, repoDir=exampleRepoDir)
#' saveToRepo(iris, repoDir=exampleRepoDir)
#' saveToRepo(model, repoDir=exampleRepoDir)
#'
#' # summary examples
#'
#' summaryLocalRepo( repoDir = exampleRepoDir )
#' 
#' # let's add more artifacts
#'
#' saveToRepo(glmnet1, repoDir=exampleRepoDir)
#' saveToRepo(lda1, repoDir=exampleRepoDir)
#' (qda1Md5hash <- saveToRepo(qda1, repoDir=exampleRepoDir))
#' 
#' # summary now
#' 
#' summaryLocalRepo( repoDir = exampleRepoDir ) 
#' 
#' # what if we remove an artifact
#' 
#' rmFromRepo(qda1Md5hash, repoDir = exampleRepoDir)
#'
#' # summary now
#' 
#' summaryLocalRepo( repoDir = exampleRepoDir )
#' 
#' # removing an example Repository
#' 
#' deleteRepo( exampleRepoDir, TRUE)
#' 
#' rm( exampleRepoDir )
#' 
#' #
#' # Remote version
#' #
#'  
#' x <- summaryRemoteRepo( user="pbiecek", repo="archivist")
#' print( x )
#' 
#' # many archivist-like Repositories on one Remote repository
#'   
#' summaryRemoteRepo(user="MarcinKosinski", repo="Museum", 
#' branch="master", repoDirGit="ex2" )
#' 
#' }
#' @family archivist
#' @rdname summaryRepo
#' @export
summaryLocalRepo <- function( repoDir = NULL ){
  stopifnot( ( is.character( repoDir ) & length( repoDir ) == 1 ) | is.null( repoDir ) )
  
  repoDir <- checkDirectory( repoDir )
  
  summaryRepo( dir = repoDir, realDBname = TRUE)
  
}



#' @rdname summaryRepo
#' @export
summaryRemoteRepo <- function( repo = aoptions("repo"), user = aoptions("user"), branch = "master", 
                               repoDirGit = aoptions("repoDirGit"),  repoType = aoptions("repoType")){
  stopifnot( is.character( branch ), length( branch ) == 1 )

  RemoteRepoCheck( repo, user, branch, repoDirGit, repoType) # implemented in setRepo.R
  
  # database is needed to be downloaded
  remoteHook <- getRemoteHook(repo=repo, user=user, branch=branch, repoDirGit=repoDirGit)
  Temp <- downloadDB( remoteHook )
  
  summaryRepo( dir = Temp, realDBname = FALSE )
  
}

summaryRepo <- function( dir, realDBname ){
    # what classes types are there in the Repository
    classes <- executeSingleQuery( dir = dir , realDBname = realDBname,
                  paste0( "SELECT DISTINCT tag FROM tag WHERE tag LIKE 'class%'" ) )
    classes <- as.character( apply( classes, 1, function(y) sub( x = y, pattern = "class:", replacement="") ) )
  
info <- list( artifactsNumber = NULL, dataSetsNumber = NULL, classesNumber = NULL, 
              savesPerDay = NULL, classesTypes = classes )
    
    # how many different objects are there in the Repository
    info$artifactsNumber <- length( searchInLocalRepo( pattern = "name", fixed = FALSE, 
                                                       realDBname = realDBname, repoDir = dir ) )
    
    # how many datasets are there in the Repository
    info$dataSetsNumber <- length( searchInLocalRepo( pattern = "relationWith", fixed = FALSE, 
                                                      realDBname = realDBname, repoDir = dir ) )


    # how many different objects classes are there in the Repository
    info$classesNumber <- sapply( classes, function(x){
                          length( searchInLocalRepo( pattern = paste0("class:", x), 
                                                  fixed = TRUE, realDBname = realDBname, repoDir = dir ) ) })
    # how many different objects were saved in different days
    days <- unique( as.Date( unlist( executeSingleQuery( dir = dir , realDBname = realDBname,
                                paste0( "SELECT createdDate FROM tag" ) ) ) ) )
    info$savesPerDay <- sapply( days, function(x){
                                length( searchInLocalRepo( pattern = list( dateFrom = x, dateTo = x),
                                                   repoDir = dir, realDBname = realDBname ) ) } )
    names( info$savesPerDay ) <- days
    
  class( info ) <- "repository"
  
  return( info )
}

#' @export
print.repository <- function( x, ... ){
  
  if( x$artifactsNumber == 0 & x$dataSetsNumber == 0 ){
    cat( "Repository is empty." )
  } else {
  cat( "Number of archived artifacts in Repository: ", x$artifactsNumber, "\n")
  cat( "Number of archived datasets in Repository: ", x$dataSetsNumber, "\n") 
  if( x$artifactsNumber > 1 ){
    cat( "Number of various classes archived in Repository: \n ")
    classes <- data.frame( x$classesNumber )
    names( classes ) <- "Number"
    print( classes )
  }
  
  cat( "Saves per day in Repository: \n ")
  saves <- data.frame( x$savesPerDay )
  names( saves ) <- "Saves"
  print( saves )
  
  }
    
  invisible( x )
}

# #' @export
# plot.repository <- function( x, ... ){
#   barplot( x$savesPerDay, ... )
#   # invisible( x )
# }

