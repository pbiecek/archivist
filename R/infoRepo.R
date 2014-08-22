##    archivist package for R
##
#' @title View the Information About a Repository
#'
#' @description
#' TO DO
#' @details
#' TO DO
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
#' @return TODO
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
#' 
#' exampleRepoDir <- tempdir()
#' 
#' x <- infoGithubRepo( user="pbiecek", repo="archivist")
#' print( x )
#' plot( x )
#' }
#' @family archivist
#' @rdname infoRepo
#' @export
infoLocalRepo <- function( repoDir ){
  stopifnot( is.character( c( repoDir ) ) )
  
  repoDir <- checkDirectory( repoDir )
  
  infoRepo( dir = repoDir, paste = TRUE)
  
}



#' @rdname infoRepo
#' @export
infoGithubRepo <- function( repo, user, branch = "master" ){
  stopifnot( is.character( c( repo, user, branch ) ) )
  
  # database is needed to be downloaded
  Temp <- downloadDB( repo, user, branch )
  
  infoRepo( dir = Temp, paste = FALSE )
  
}




infoRepo <- function( dir, paste ){
    # what classes types are there in the Repository
    classes <- executeSingleQuery( dir = dir , paste = paste,
                  paste0( "SELECT DISTINCT tag FROM tag WHERE tag LIKE 'class%'" ) )
    classes <- as.character( apply( classes, 1, function(y) sub( x = y, pattern = "class:", replacement="") ) )
  
info <- list( artifactsNumber = NULL, dataSetsNumber = NULL, classesNumber = NULL, 
              savesPerDay = NULL, classesTypes = classes )
    
    # how many different objects are there in the Repository
    info$artifactsNumber <- length( searchInLocalRepo( pattern = "name", fixed = FALSE, 
                                                   paste = paste, repoDir = dir ) )
    
    # how many datasets are there in the Repository
    info$dataSetsNumber <- length( searchInLocalRepo( pattern = "relationWith", fixed = FALSE, 
                                                   paste = paste, repoDir = dir ) )


    # how many different objects classes are there in the Repository
    info$classesNumber <- sapply( classes, function(x){
                          length( searchInLocalRepo( pattern = paste0("class:", x), 
                                                  fixed = TRUE, paste = paste, repoDir = dir ) ) })
    # how many different objects were saved in different days
    days <- unique( as.Date( unlist( executeSingleQuery( dir = dir , paste = paste,
                                paste0( "SELECT createdDate FROM tag" ) ) ) ) )
    info$savesPerDay <- sapply( days, function(x){
                                length( searchInLocalRepo( pattern = list( dateFrom = x, dateTo = x),
                                                   repoDir = dir, paste = paste ) ) } )
    names( info$savesPerDay ) <- days
    
  class( info ) <- "repository"
  
  return( info )
}

# default print for lists looks better
# print.repository <- function( x ){
#   cat("Number of archived artifacts in the Repository: ", x$artifactsNumber ,"\n")
#   
#   cat("Number of various classes archived in the Repository: ", x[[2]], "\n" )
#   
#   cat("Saves per day in the Repository: ", x[[3]], "\n" )
#   invisible( x )
# }

#' @export
plot.repository <- function( x, ... ){
  barplot( x$savesPerDay, ... )
  # invisible( x )
}

