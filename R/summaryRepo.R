##    archivist package for R
##
#' @title View the Summary of a Repository 
#'
#' @description
#' \code{summaryLocalRepo} and \code{summaryGithubRepo} functions show the summary
#' of a \link{Repository} saved in given \code{dir} (directory). \code{summaryLocalRepo}
#' works on a \code{Repository} that exists on a user's computer when \code{summaryGithubRepo}
#' shows the summary of the \code{Repository} existing on Github Repository.
#' 
#' 
#' @details
#' \code{summaryLocalRepo} and \code{summaryGithubRepo} functions show the summary
#' of a \link{Repository} saved in given \code{dir} (directory). \code{summaryLocalRepo}
#' works on a \code{Repository} that exists on a user's computer when \code{summaryGithubRepo}
#' shows the summary of the \code{Repository} existing on Github Repository.
#' 
#' Both functions show the current state of a \code{Repository}, inter alia all archivised objects can
#' be seen with their unique \link{md5hash} or a \code{data.frame} with archivised \link{Tags} can 
#' be obtained.
#' 
#' @param method A character specifying what method use to summary a Repository. Available methods: 
#' \code{objects} (default), \code{tags}. TODO: Extend
#' 
#' @param dir A character denoting an existing directory of a Repository from which a summary will be returned.
#' 
#' @param repo Only if working on Github Repository. A character containing a name of Github Repository on which a Repository is archivised.
#' 
#' @param user Only if working on Github Repository. A character containing a name of Github User on which a Repository is archivised.
#' 
#' @param branch Only if working on Github Repository. A character containing a name of 
#' Github Repository's branch on which a Repository is archivised. Default \code{branch} is \code{master}.
#'
#' @return
#' 
#' If parameter \code{method} was specified as \code{objects} a \code{data.frame} with objects' names and archivised
#' \code{md5hash}es is returned.
#' 
#' If parameter \code{method} was specified as \code{tags} a \code{data.frame} with archivised \code{Tags} and archivised
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
#' exampleDir <- tempdir()
#' createEmptyRepo(dir = exampleDir)
#' saveToRepo(myplot123, dir=exampleDir)
#' saveToRepo(iris, dir=exampleDir)
#' saveToRepo(model, dir=exampleDir)
#'
#' # summary examples
#'
#' summaryLocalRepo(method = "objects", dir = exampleDir)
#' summaryLocalRepo(method = "tags", dir = exampleDir)
#' 
#' # let's add more objects
#'
#' saveToRepo(glmnet1, dir=exampleDir)
#' saveToRepo(lda1, dir=exampleDir)
#' (qda1Md5hash <- saveToRepo(qda1, dir=exampleDir))
#' 
#' # summary now
#' 
#' summaryLocalRepo(method = "objects", dir = exampleDir)
#' summaryLocalRepo(method = "tags", dir = exampleDir)
#' 
#' # what if we remove an object
#' 
#' rmFromRepo(qda1Md5hash, dir = exampleDir)
#'
#' # summary now
#' 
#' summaryLocalRepo(method = "objects", dir = exampleDir)
#' summaryLocalRepo(method = "tags", dir = exampleDir)
#' 
#' # GitHub version
#' 
#' summaryGithubRepo(method = "objects", user = "pbiecek", repo = "archivist")
#' summaryGithubRepo(method = "tags", user = "pbiecek", repo = "archivist", branch = "master")
#' 
#' 
#' 
#' # removing all files generated to this function's examples
#' x <- list.files( paste0( exampleDir, "/gallery/" ) )
#' sapply( x , function(x ){
#'      file.remove( paste0( exampleDir, "/gallery/", x ) )
#'    })
#' file.remove( paste0( exampleDir, "/backpack.db" ) )
#' file.remove( paste0( exampleDir, "/gallery" ) )
#' @family archivist
#' @rdname summaryLocalRepo
#' @export
summaryLocalRepo <- function( method = "objects", dir ){
  stopifnot( is.character( c( method, dir ) ) )
  
  # check if dir has "/" at the end and add it if not
  if ( regexpr( pattern = ".$", text = dir ) != "/" ){
    dir <- paste0(  dir, "/"  )
  }
  
  # creates connection and driver
  dirBase <- paste0( dir, "backpack.db")
  sqlite <- dbDriver( "SQLite" )
  conn <- dbConnect( sqlite, dirBase )
  
  if ( method == "objects" )
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
summaryGithubRepo <- function( method = "objects", repo, user, branch = "master "){
  stopifnot( is.character( c( method, repo, user, branch ) ) )
  
  # download database
  GitUrl <- paste0( "https://raw.githubusercontent.com/", user, "/", repo, "/", branch, "/backpack.db" )
  LocDir <- tempfile()
  LocDir <- paste0( LocDir, "\\")
  download.file( url = GitUrl, destfile = LocDir )
  
  GitMethod <- method
  summaryLocalRepo( method = GitMethod , dir = LocDir)
  
  # when summary is returned, delete downloaded database
  file.remove( paste0( LocDir, "backpack.db" ) )
  LocDir <- NULL 
  
}