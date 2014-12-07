##    archivist package for R
##
#' @title Remove an Artifact Given as md5hash from a Repository
#'
#' @description
#' \code{rmFromRepo} removes an artifact given as \code{md5hash} from a \link{Repository}.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#'  
#' @details
#' \code{rmFromRepo} removes an artifact given as \code{md5hash} from a Repository, 
#' which is a SQLite database named \code{backpack} - created by a \link{createEmptyRepo} call.
#' For every artifact, \code{md5hash} is a unique string of length 32 that comes out as a result of 
#' \link[digest]{digest} function, which uses a cryptographical MD5 hash algorithm.
#' 
#' 
#' Also this function removes a \code{md5hash.rda} file, where \code{md5hash} is the artifact's hash as above.
#' 
#'  
#' Important: instead of giving the whole \code{md5hash} character, the user can simply give first few characters of the \code{md5hash}.
#' For example, \code{a09dd} instead of \code{a09ddjdkf9kj33dcjdnfjgos9jd9jkcv}. All artifacts with the same corresponing \code{md5hash} abbreviation 
#' will be removed from the \link{Repository} and from the \code{gallery} folder.
#' 
#' \code{rmFromRepo} provides functionality that enables to delete miniatures of the artifacts (.txt or .png files) 
#' while removing .rda files. To disable this functionality use \code{removeMiniature = FALSE}. Also, if the
#'  data from the artifact were archived, the data will be removed by default but there is a possibility not to 
#'  delete this data while performing \code{rmFromRepo} - simply use \code{removeData = TRUE}.
#' 
#' 
#' \code{rmFromRepo} provides functionality that enables to delete miniatures of the artifacts (.txt or .png files) while removing .rda files.
#' To delete miniature use \code{removeMiniature = TRUE}. Also if the data from the artifact was archived, there is a possibility to delete this 
#' data while removing artifact that uses this data. Simply use \code{removeData = TRUE}.
#' 
#' If one wants to remove all artifact created between two dates, it is suggested to
#' perform:
#' \itemize{
#'    \item \code{obj2rm <- searchInLocalRepo( tag = list(dateFrom, dateTo), repoDir = )}
#'    \item \code{sapply(obj2rm, rmFromRepo, repoDir = )}
#' }
#' 
#' @note
#' \code{md5hash} can be a result of the \link{searchInLocalRepo} function proceeded with \code{tag = NAME} argument,
#' where \code{NAME} is a tag that describes the property of the objects to be deleted. 
#' 
#' 
#' For more information about \code{Tags} check \link{Tags}.
#' 
#' @param md5hash A character assigned to the artifact as a result of a cryptographical hash function with MD5 algorithm, or it's abbreviation. This object will be removed.
#' 
#' @param repoDir A character denoting an existing directory from which an artifact will be removed.
#' If set to \code{NULL} (by default), uses the \code{repoDir} specified in \link{setLocalRepo}.
#' 
#' @param removeData A logical value denoting whether to remove a data with the \code{artifact} specified by the \code{md5hash}.
#' Defualt \code{FALSE}.
#' 
#' @param removeMiniature A logical value denoting whether to remove a miniature with the \code{artifact} specified by the \code{md5hash}.
#' Defualt \code{FALSE}.
#' 
#' @param force A logical value denoting whether to remove data if it is related to more than 1 artifact.
#' Defualt \code{FALSE}.
#' 
#' @author
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' # objects preparation
#' \dontrun{
#' data.frame object
#' data(iris)
#' 
#' # ggplot/gg object
#' library(ggplot2)
#' df <- data.frame(gp = factor(rep(letters[1:3], each = 10)),y = rnorm(30))
#' library(plyr)
#' ds <- ddply(df, .(gp), summarise, mean = mean(y), sd = sd(y))
#' myplot123 <- ggplot(df, aes(x = gp, y = y)) +
#'   geom_point() +  geom_point(data = ds, aes(y = mean),
#'                              colour = 'red', size = 3)
#' 
#' # lm object
#' model <- lm(Sepal.Length~ Sepal.Width + Petal.Length + Petal.Width, data= iris)
#' model2 <- lm(Sepal.Length~ Sepal.Width + Petal.Width, data= iris)
#' model3 <- lm(Sepal.Length~ Sepal.Width, data= iris)
#' 
#' # agnes (twins) object
#' library(cluster)
#' data(votes.repub)
#' agn1 <- agnes(votes.repub, metric = "manhattan", stand = TRUE)
#' 
#' # fanny (partition) object
#' x <- rbind(cbind(rnorm(10, 0, 0.5), rnorm(10, 0, 0.5)),
#'            cbind(rnorm(15, 5, 0.5), rnorm(15, 5, 0.5)),
#'            cbind(rnorm( 3,3.2,0.5), rnorm( 3,3.2,0.5)))
#' fannyx <- fanny(x, 2)
#' 
#' # creating example Repository - that examples will work
#' 
#' exampleRepoDir <- tempdir()
#' createEmptyRepo(repoDir = exampleRepoDir)
#' myplo123Md5hash <- saveToRepo(myplot123, repoDir=exampleRepoDir)
#' irisMd5hash <- saveToRepo(iris, repoDir=exampleRepoDir)
#' modelMd5hash  <- saveToRepo(model, repoDir=exampleRepoDir)
#' agn1Md5hash <- saveToRepo(agn1, repoDir=exampleRepoDir)
#' fannyxMd5hash <- saveToRepo(fannyx, repoDir=exampleRepoDir)
#' 
#' # let's see how the Repository look like: show
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # let's see how the Repository look like: summary
#' summaryLocalRepo( exampleRepoDir )
#' 
#' # remove examples
#' 
#' rmFromRepo(fannyxMd5hash, repoDir = exampleRepoDir, removeData= FALSE)
#' # removeData = FALSE provides from removing archived "fannyxMd5hash object"-data from 
#' # a Repository and gallery
#' 
#' rmFromRepo(irisMd5hash, repoDir = exampleRepoDir)
#' # note that also files in gallery folder, created in exampleRepoDir
#' # directory will be removed
#' 
#' # let's see how the Repository look like: show
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # let's see how the Repository look like: summary
#' summaryLocalRepo( exampleRepoDir )
#' 
#' 
#' # one can have the same object archived 3 different times
#' # there will appear a warning message
#' agn1Md5hash2 <- saveToRepo(agn1, repoDir=exampleRepoDir)
#' agn1Md5hash3 <- saveToRepo(agn1, repoDir=exampleRepoDir)
#' 
#' # md5hashes are the same for that same object (agn1)
#' agn1Md5hash == agn1Md5hash2
#' agn1Md5hash2 == agn1Md5hash3
#' 
#' 
#' 
#' # but there are 3 times more rows in Repository database (backpack.db).
#' 
#' # let's see how the Repository look like: show
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # let's see how the Repository look like: summary
#' summaryLocalRepo( exampleRepoDir )
#' 
#' # one easy call removes them all but this call will result in error
#' rmFromRepo(agn1Md5hash, repoDir = exampleRepoDir, removeData = TRUE, 
#'             removeMiniature = TRUE)
#' 
#' # soultion to that is
#' rmFromRepo(agn1Md5hash, repoDir = exampleRepoDir, removeData = TRUE, 
#'             removeMiniature = TRUE, force = TRUE)
#' # removeMiniature = TRUE removes miniatures from gallery folder
#' 
#' # rest of artifacts can be removed e.g. like this
#' # looking for dates of creation and then removing all objects
#' # from specific date
#' 
#' obj2rm <- searchInLocalRepo( pattern = list(dateFrom = Sys.Date(), dateTo = Sys.Date()),
#'                              repoDir = exampleRepoDir )
#' sapply(obj2rm, rmFromRepo, repoDir = exampleRepoDir)
#' # above example removed all objects from this example
#' 
#' # let's see how the Repository look like: show
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # one can also remove objects from only specific class
#' modelMd5hash  <- saveToRepo(model, repoDir=exampleRepoDir)
#' model2Md5hash  <- saveToRepo(model2, repoDir=exampleRepoDir)
#' model3Md5hash  <- saveToRepo(model3, repoDir=exampleRepoDir)
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' 
#' objMd5hash <- searchInLocalRepo("class:lm", repoDir = exampleRepoDir)
#' sapply(objMd5hash, rmFromRepo, repoDir = exampleRepoDir, removeData = TRUE, force = TRUE)
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' summaryLocalRepo( exampleRepoDir )
#' 
#' 
#' # once can remove object specifying only its md5hash abbreviation
#' (myplo123Md5hash <- saveToRepo(myplot123, repoDir=exampleRepoDir))
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' # "ff751bb5ba34bbb8a7851958b15f2ef7"
#' # so example abbreviation might be : "ff751"
#' rmFromRepo("ff751", repoDir = exampleRepoDir)
#' summaryLocalRepo( repoDir = exampleRepoDir )
#' 
#' 
#' # removing an example Repository
#' 
#' deleteRepo( exampleRepoDir )
#' 
#' rm( exampleRepoDir )
#' }
#' @family archivist
#' @rdname rmFromRepo
#' @export
rmFromRepo <- function( md5hash, repoDir = NULL, removeData = FALSE, 
                        removeMiniature = FALSE, force = FALSE ){
  stopifnot( is.character( md5hash  ) )
  stopifnot( is.character( repoDir ) | is.null( repoDir ) )
  stopifnot( is.logical( c( removeData, removeMiniature ) ) )
    
  repoDir <- checkDirectory( repoDir )
  
  # what if abbreviation was given
  if ( nchar( md5hash ) < 32 ){
    
    md5hashList <- executeSingleQuery( dir = repoDir,
                               paste0( "SELECT artifact FROM tag" ) )
    md5hashList <- as.character( md5hashList[, 1] )
    md5hash <- unique( grep( 
      pattern = paste0( "^", md5hash ), 
      x = md5hashList, 
      value = TRUE ) )
  }

  # send deletes for data 
  if ( removeData ){
    # if there are many objects with the same m5hash (copies) all of them will be deleted
    dataMd5hash <-  executeSingleQuery( dir = repoDir,
                     paste0( "SELECT artifact FROM tag WHERE ",
                             "tag = '", paste0("relationWith:", md5hash), "'" ) ) 
    
    if ( length( dataMd5hash != 1 ) & !force ){
      stop( "Data related to ", md5hash, " are also in relation with other artifacts. \n",
            "To remove try again with argument removeData = FALSE to remove artifact only or with argument force = TRUE to remove data anyway.")
    }
    if ( length( dataMd5hash != 1 ) & force )
      cat( "Data related to more than 1 artifact was removed from Repository.")
    
    
    sapply( dataMd5hash, function(x){
      executeSingleQuery( dir = repoDir,
                  paste0( "DELETE FROM artifact WHERE ",
                          "md5hash = '", x, "'" ) )} )
    sapply( dataMd5hash, function(x){
      executeSingleQuery( dir = repoDir,
                  paste0( "DELETE FROM tag WHERE ",
                          "artifact = '", x, "'" ) )} )
    
    # remove data files from gallery folder
    if ( file.exists( paste0( repoDir, "gallery/", dataMd5hash, ".rda" ) ) )
      file.remove( paste0( repoDir, "gallery/", dataMd5hash, ".rda" ) )
    
  }
  
  # remove object from database
  # if there are many objects with the same m5hash (copies) all of them will be deleted
  sapply( md5hash, function(x){
    executeSingleQuery( dir = repoDir,
                paste0( "DELETE FROM artifact WHERE ",
                        "md5hash = '", x, "'" ) )} )
  sapply( md5hash, function(x){
    executeSingleQuery( dir = repoDir,
                paste0( "DELETE FROM tag WHERE ",
                        "artifact = '", x, "'" ) )} )
   
  # remove files from gallery folder
  if ( file.exists( paste0( repoDir, "gallery/", md5hash, ".rda" ) ) )
    file.remove( paste0( repoDir, "gallery/", md5hash, ".rda" ) )
  
  # remove the miniature of an object
  if ( removeMiniature ){
  if ( file.exists( paste0( repoDir, "gallery/", md5hash, ".png" ) ) )
    file.remove( paste0( repoDir, "gallery/", md5hash, ".png" ) )
    
  if ( file.exists( paste0( repoDir, "gallery/", md5hash, ".txt" ) ) )
    file.remove( paste0( repoDir, "gallery/", md5hash, ".txt" ) )
  }
  
}
