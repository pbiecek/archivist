##    archivist package for R
##
#' @title View the Summary of a Repository 
#'
#' @description
#' \code{summaryLocalRepo} and \code{summaryGithubRepo} functions produce the summary
#' of a \link{Repository} saved in a given \code{repoDir} (directory). \code{summaryLocalRepo}
#' shows the summary of the \code{Repository} that exists on the user's computer, whereas \code{summaryGithubRepo}
#' shows the summary of the \code{Repository} existing on a Github repository.
#' 
#' @details
#' \code{summaryLocalRepo} and \code{summaryGithubRepo} functions produce the summary
#' of a \link{Repository} saved in a given \code{repoDir} (directory). \code{summaryLocalRepo}
#' works on a \code{Repository} that exists on the user's computer, whereas \code{summaryGithubRepo}
#' shows the summary of the \code{Repository} existing on a Github repository.
#' 
#' Both functions show the current state of a \code{Repository}, inter alia, all archived objects can
#' be seen with their unique \link{md5hash} or a \code{data.frame} with archived \link{Tags} can 
#' be obtained. Also there is an extra column with a date of creation the \code{Tag} or the \code{md5hash}.
#' 
#' @param method A character specifying the method to be used to summarize the Repository. Available methods: 
#' \code{md5hashes} (default), \code{tags}. TODO: Extend
#' 
#' @param repoDir A character denoting an existing directory of a Repository for which a summary will be returned.
#' 
#' @param repo Only if working with a Github repository. A character containing a name of a Github repository on which the Repository is archived.
#' 
#' @param user Only if working with a Github repository. A character containing a name of a Github user on whose account the \code{repo} is created.
#' 
#' @param branch Only if working with a Github repository. A character containing a name of 
#' Github Repository's branch on which a Repository is archived. Default \code{branch} is \code{master}.
#'
#' @return
#' 
#' If parameter \code{method} was set as \code{md5hashes} a \code{data.frame} with objects' names and archived
#' \code{md5hashes} is returned.
#' 
#' If parameter \code{method} was set as \code{tags} a \code{data.frame} with archived \code{Tags} and archived
#' objects' \code{md5hash}es is returned.
#' 
#' 
#' @author 
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#'
#' @examples
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
#' # creating example Repository - that examples will work
#' 
#' 
#' exampleRepoDir <- tempdir()
#' createEmptyRepo(repoDir = exampleRepoDir)
#' saveToRepo(myplot123, repoDir=exampleRepoDir)
#' saveToRepo(iris, repoDir=exampleRepoDir)
#' saveToRepo(model, repoDir=exampleRepoDir)
#'
#' # summary examples
#'
#' summaryLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' summaryLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # let's add more md5hashes
#'
#' saveToRepo(glmnet1, repoDir=exampleRepoDir)
#' saveToRepo(lda1, repoDir=exampleRepoDir)
#' (qda1Md5hash <- saveToRepo(qda1, repoDir=exampleRepoDir))
#' 
#' # summary now
#' 
#' summaryLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' summaryLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # what if we remove an object
#' 
#' rmFromRepo(qda1Md5hash, repoDir = exampleRepoDir)
#'
#' # summary now
#' 
#' summaryLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' summaryLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # GitHub version
#' 
#' summaryGithubRepo(method = "md5hashes", user = "pbiecek", repo = "archivist")
#' summaryGithubRepo(method = "tags", user = "pbiecek", repo = "archivist", branch = "master")
#' 
#' 
#' 
#' # removing all files generated to this function's examples
#' x <- list.files( paste0( exampleRepoDir, "/gallery/" ) )
#' sapply( x , function(x ){
#'      file.remove( paste0( exampleRepoDir, "/gallery/", x ) )
#'    })
#' file.remove( paste0( exampleRepoDir, "/backpack.db" ) )
#' @family archivist
#' @rdname summaryLocalRepo
#' @export
summaryLocalRepo <- function( method = "md5hashes", repoDir ){
  stopifnot( is.character( c( method, repoDir ) ) )
  
  # check if repoDir has "/" at the end and add it if not
  if ( regexpr( pattern = ".$", text = repoDir ) != "/" ){
    repoDir <- paste0(  repoDir, "/"  )
  }
  
  # creates connection and driver
  repoDirBase <- paste0( repoDir, "backpack.db")
  sqlite <- dbDriver( "SQLite" )
  conn <- dbConnect( sqlite, repoDirBase )
  
  if ( method == "md5hashes" )
    value <- dbReadTable( conn, "artifact" )
  
  if ( method == "tags" )
    value <- dbReadTable( conn, "tag" )
  
  
  # deletes connection and driver
  dbDisconnect( conn )
  dbUnloadDriver( sqlite ) 
  
  return( value )
}


#' @rdname summaryLocalRepo
#' @export
summaryGithubRepo <- function( method = "md5hashes", repo, user, branch = "master"){
  stopifnot( is.character( c( method, repo, user, branch ) ) )
  
  # database is needed to be downloaded
  URLdb <- paste0( .GithubURL, user, "/", repo, 
                   "/", branch, "/backpack.db") 
  library( RCurl )
  db <- getBinaryURL( URLdb, ssl.verifypeer = FALSE )
  Temp <- tempfile()
  writeBin( db, Temp)
  
  sqlite <- dbDriver( "SQLite" )
  conn <- dbConnect( sqlite, Temp )
  
  # now perform summary
  if ( method == "md5hashes" )
    value <- dbReadTable( conn, "artifact" )
  
  if ( method == "tags" )
    value <- dbReadTable( conn, "tag" )
  
  
  # deletes connection and driver
  dbDisconnect( conn )
  dbUnloadDriver( sqlite ) 
  
  # when summary is returned, delete downloaded database
  file.remove( Temp ) 
  
  return( value )

  
}