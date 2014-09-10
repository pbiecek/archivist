##    archivist package for R
##
#' @title Delete an Existing Repository from Given Directory
#'
#' @description
#' \code{deleteRepo} deletes an existing \link{Repository} from a given directory, so all artifacts from \code{gallery} folder are
#' removed and database \code{backpack.db} is deleted.
#' 
#' 
#' @details
#' \code{deleteRepo} deletes an existing \link{Repository} from a given directory, so all artifacts from \code{gallery} folder are
#' removed and database \code{backpack.db} is deleted. 
#'
#' @param repoDir A character that specifies the directory for the Repository to be deleted.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
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
#' # creating example Repository - that examples will work
#' 
#' # save examples
#' 
#' exampleRepoDir <- tempdir()
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
#' # let's see how the Repository look like: show
#' 
#' showLocalRepo( method = "md5hashes", repoDir = exampleRepoDir )
#' showLocalRepo( method = "tags", repoDir = exampleRepoDir )
#' 
#' # let's get information about that Repository
#' 
#' summaryLocalRepo( repodir = exampleRepoDir )
#' 
#' # now let's delete the Repository
#' 
#' delete( repoDir = exampleRepoDir )
#' 
#' rm( exampleRepoDir )
#' }
#' 
#' @family archivist
#' @rdname deleteRepo
#' @export
deleteRepo <- function( repoDir ){
  stopifnot( is.character( repoDir ) )
  
  repoDir <- checkDirectory( repoDir )
  
  x <- list.files( paste0( repoDir , "gallery/" ) )
  sapply( x , function(x ){
       file.remove( paste0( repoDir, "gallery/", x ) )
     })
  
  
  file.remove( paste0( repoDir, "backpack.db" ) )
  unlink( paste0( repoDir, "gallery" ), recursive = TRUE )    
  
}