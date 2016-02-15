##    archivist package for R
##
#' @title Remove an Artifact Given as a md5hash from the Repository
#'
#' @description
#' \code{rmFromLocalRepo} removes an artifact given as a \code{md5hash} from the \link{Repository}.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#'  
#' @details
#' \code{rmFromLocalRepo} removes an artifact given as a \link{md5hash} from the \link{Repository}.
#' To be more precise, an artifact is removed 
#' both from \code{backpack.db} file(the SQLite database)and \code{gallery} subdirectory,
#' where the artifacts are stored as \code{md5hash.rda} files.
#'   
#' Important: instead of giving the whole \code{md5hash} character, a user
#' can simply give its first few characters. For example, \code{"a09dd"} 
#' instead of \code{"a09ddjdkf9kj33dcjdnfjgos9jd9jkcv"}.
#' All artifacts with the same \code{md5hash} abbreviation  will be removed 
#' from the \code{Repository}.
#' 
#' \code{rmFromLocalRepo} provides functionality that enables us to delete miniatures
#' of the artifacts (.txt or .png files) while removing .rda files.
#' To delete miniature of the artifact use \code{removeMiniature = TRUE} argument.
#' Moreover, if the data from the artifact is archived then there is a possibility 
#' to delete this data while removing the artifact. Simply use \code{removeData = TRUE} argument.
#'   
#' If one wants to remove all artifacts created between two dates, it is suggested to
#' perform:
#' \itemize{
#'    \item \code{obj2rm <- searchInLocalRepo( tag = list(dateFrom, dateTo), repoDir = )}
#'    \item \code{sapply(obj2rm, rmFromLocalRepo, repoDir = )}
#' }
#' 
#' @note 
#' \code{md5hash} can be a result of the \link{searchInLocalRepo} function called
#' by \code{tag = NAME} argument, where \code{NAME} is a Tag that describes
#' the property of the artifacts to be deleted. 
#' 
#' It is not possible to use a vector of artifacts' \code{md5hashes} abbreviations
#' while using \code{many = TRUE} argument. This assumption was made 
#' to protect a user from removing, by accident, too many artifacts from the Repository.
#' 
#' For more information about \code{Tags} check \link{Tags}.
#' 
#' @param md5hash A character assigned to the artifact through the use of a
#' cryptographical hash function with MD5 algorithm, or it's abbreviation.
#' This object will be removed. If \code{many} parameter is set to TRUE then
#' md5hash will be a character vector.
#' 
#' @param repoDir A character denoting an existing directory from which an 
#' artifact will be removed. 
#' 
#' @param removeData A logical value denoting whether to remove data along with
#' the \code{artifact} specified by the \code{md5hash}. Defualt \code{FALSE}.
#' 
#' @param removeMiniature A logical value denoting whether to remove a miniature
#' along with the \code{artifact} specified by the \code{md5hash}. Defualt \code{FALSE}.
#' 
#' @param force A logical value denoting whether to remove data related to more than one artifact.
#' Defualt \code{FALSE}.
#' 
#' @param many A logical value. To accelerate the speed of removing many objects,
#' you can set this parameter to \code{TRUE} and pass a vector of artifacts' \code{md5hashes}
#' to a \code{md5hash} parameter. It is not possible to use a vector of artifacts' 
#' \code{md5hashes} abbreviations - see \code{Note}. By default, set to \code{FALSE}.
#' 
#' @param ... All arguments are being passed to \code{rmFromLocalRepo}.
#' 
#' @author
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#' Witold Chodor , \email{witoldchodor@@gmail.com}
#'
#' @examples
#' \dontrun{
#' # objects preparation
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
#' # creating example Repository - on which examples will work
#' 
#' exampleRepoDir <- tempfile()
#' createLocalRepo(repoDir = exampleRepoDir)
#' myplot123Md5hash <- saveToLocalRepo(myplot123, repoDir=exampleRepoDir)
#' irisMd5hash <- saveToLocalRepo(iris, repoDir=exampleRepoDir)
#' modelMd5hash  <- saveToLocalRepo(model, repoDir=exampleRepoDir)
#' agn1Md5hash <- saveToLocalRepo(agn1, repoDir=exampleRepoDir)
#' fannyxMd5hash <- saveToLocalRepo(fannyx, repoDir=exampleRepoDir)
#' 
#' # let's see how the Repository looks like: show
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # let's see how the Repository looks like: summary
#' summaryLocalRepo( exampleRepoDir )
#' 
#' # remove examples
#' 
#' rmFromLocalRepo(fannyxMd5hash, repoDir = exampleRepoDir)
#' # removeData = FALSE default argument provides from removing archived
#' # fannyxMd5hash object's data from the Repository and the gallery
#' rmFromLocalRepo(irisMd5hash, repoDir = exampleRepoDir)
#'  
#' # let's see how the Repository looks like: show
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # let's see how the Repository looks like: summary
#' summaryLocalRepo( exampleRepoDir )
#' 
#' 
#' # one can have the same object archived three different times,
#' # there will appear a warning message
#' agn1Md5hash2 <- saveToLocalRepo(agn1, repoDir=exampleRepoDir)
#' agn1Md5hash3 <- saveToLocalRepo(agn1, repoDir=exampleRepoDir)
#' 
#' # md5hashes are the same for the same object (agn1)
#' agn1Md5hash == agn1Md5hash2
#' agn1Md5hash2 == agn1Md5hash3
#' 
#' # but in the Repository database (backpack.db)
#' # there are three identical rows describing the object
#' # as well as three identical rows describing object's data.
#' 
#' # let's see how the Repository looks like: show
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # let's see how the Repository looks like: summary
#' summaryLocalRepo( exampleRepoDir )
#' # in spite of multiplying object's appearance in database it is
#  # still considered as one object - the number of saves hasn't changed
#' 
#' # one easy call removes them all but this call will result in error
#' rmFromLocalRepo(agn1Md5hash, repoDir = exampleRepoDir, removeData = TRUE, 
#'             removeMiniature = TRUE)
#' 
#' # soultion to that is
#' rmFromLocalRepo(agn1Md5hash, repoDir = exampleRepoDir, removeData = TRUE, 
#'             removeMiniature = TRUE, force = TRUE)
#' # removeMiniature = TRUE removes miniatures from the gallery folder
#' 
#' # rest of the artifacts can be removed for example by
#' # looking for dates of creation and then removing all objects
#' # created in a specific period of time
#' 
#' obj2rm <- searchInLocalRepo( pattern = list(dateFrom = Sys.Date(), dateTo = Sys.Date()),
#'                              repoDir = exampleRepoDir )
#' sapply(obj2rm, rmFromLocalRepo, repoDir = exampleRepoDir)
#' # above function call removed all objects which were created in these examples.
#' # Note that in the gallery folder there may be still some miniatures as
#' # removeMiniature parameter is set to FALSE
#' 
#' # let's see how the Repository looks like: show
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # one can also delete objects of a specific class
#' modelMd5hash  <- saveToLocalRepo(model, repoDir=exampleRepoDir)
#' model2Md5hash  <- saveToLocalRepo(model2, repoDir=exampleRepoDir)
#' model3Md5hash  <- saveToLocalRepo(model3, repoDir=exampleRepoDir)
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' 
#' objMd5hash <- searchInLocalRepo("class:lm", repoDir = exampleRepoDir)
#' sapply(objMd5hash, rmFromLocalRepo, repoDir = exampleRepoDir, removeData = TRUE, force = TRUE)
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' summaryLocalRepo( exampleRepoDir )
#' 
#' 
#' # one can remove object specifying only its md5hash abbreviation
#' (myplo123Md5hash <- saveToLocalRepo(myplot123, repoDir=exampleRepoDir))
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' 
#' # If md5hash is "db50a4e667581f8c531acd78ad24bfee" then
#' # model abbreviation might be : "db50a"
#' # Note that with each evaluation of createEmptyRepo function new md5hashes
#' # are created. This is why, in your evaluation of the code, artifact 
#' # myplo123Md5hash will have a different md5hash and the following
#' # instruction will result in an error.
#' rmFromLocalRepo("db40a", repoDir = exampleRepoDir, removeData = TRUE)
#' summaryLocalRepo( repoDir = exampleRepoDir )
#' 
#' 
#' # removing an example Repository
#' 
#' deleteLocalRepo( exampleRepoDir, TRUE)
#' 
#' 
#' ######
#' ######
#' REMOVING MANY ARTIFACTS
#' ######
#' ######
#' 
#' data(iris)
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
#'            cbind(rnorm(15, 5, 0.5), rnorm(15, 5, 0.5)),
#'            cbind(rnorm( 3,3.2,0.5), rnorm( 3,3.2,0.5)))
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
#' # Creating example Repository so that we may see it on our computer
#'
#' exampleRepoDir <- tempfile()
#' createLocalRepo( repoDir = exampleRepoDir, force = TRUE)
#' saveToLocalRepo( iris, repoDir=exampleRepoDir)
#' saveToLocalRepo( model, repoDir=exampleRepoDir )
#' saveToLocalRepo( agn1, repoDir=exampleRepoDir )
#' saveToLocalRepo( fannyx, repoDir=exampleRepoDir )
#' saveToLocalRepo( lda1, repoDir=exampleRepoDir )
#' saveToLocalRepo( glmnet1, repoDir=exampleRepoDir )
#'
#' ArtifactsAndData <- unique(showLocalRepo(repoDir = exampleRepoDir)[,1])
#' ArtifactsData <- unique(searchInLocalRepo(pattern = "relationWith", fixed = FALSE,
#'                                    repoDir = exampleRepoDir))
#' Artifacts <- setdiff(ArtifactsAndData, ArtifactsData)
#' 
#' 
#' # Removing many artifacts with many = TRUE argument
#' rmFromLocalRepo(Artifacts, repoDir = exampleRepoDir, many = TRUE)
#' 
#' # We may notice, in two ways, that artifacts' data is still in "exampleRepoDir".
#' # Either we may look into gallery folder of "exampleRepoDir" 
#' list.files(file.path(exampleRepoDir, "gallery"))
#' # or show how database.db file looks like.
#' showLocalRepo(repoDir = exampleRepoDir) # artifacts' data is there indeed!
#' 
#' # If we want to remove artifact's data now we simply call rmFromLocalRepo function
#' # with removeData = TRUE additional argument.
#' rmFromLocalRepo(Artifacts, repoDir = exampleRepoDir, removeData = TRUE,  many = TRUE)
#' 
#' # We receive a warning as Artifacts are no longer in the repository. 
#' # However, let's check what happened with Artifact's data.
#' showLocalRepo(repoDir = exampleRepoDir) # They were removed.
#' # Perhaps you may think that "exampleRepoDir" is empty as database indicates. However,
#' # if you look into gallery folder there will be some ".txt" or ".png" files. 
#' list.files(file.path(exampleRepoDir, "gallery"))
#' 
#' # Those are probably, the so called, Miniatures. Let's try to remove them.
#' # In order to do it we call rmFromLocalRepo function with removeMiniature = TRUE argument.
#' rmFromLocalRepo(Artifacts, many = TRUE, repoDir = exampleRepoDir, removeMiniature = TRUE)
#' 
#' # Again we receive a warning as Artifacts are no longer in the repository but ...
#' list.files(file.path(exampleRepoDir, "gallery")) 
#' # gallery folder is empty now! Artifact's miniature's were removed.
#' 
#' 
#' # Of course we may have done all these instructions by one simple function call.
#' # rmFromLocalRepo(Artifacts, many = TRUE, repoDir = exampleRepoDir,
#' #            removeData = TRUE, removeMiniature = TRUE)
#' # Nevertheless, it may be instructive to see how it is done step by step.
#' 
#' # removing an example Repository
#' deleteLocalRepo(repoDir = exampleRepoDir, deleteRoot = TRUE)
#'    
#' rm( exampleRepoDir )
#' }
#' @family archivist
#' @rdname rmFromLocalRepo
#' @export
rmFromLocalRepo <- function( md5hash, repoDir = aoptions('repoDir'), removeData = FALSE, 
                        removeMiniature = FALSE, force = FALSE, many = FALSE ){
  stopifnot( is.character( md5hash  ))
  stopifnot( is.character( repoDir ) & length( repoDir ) == 1 )
  stopifnot( is.logical( c( removeData, removeMiniature, many ) ) )
  if (length( md5hash ) == 0) return(invisible(NULL))
  if (many){
    stopifnot( length( md5hash ) > 0 )
  } else {
    stopifnot( length( md5hash ) == 1 )
  }
    
  repoDir <- checkDirectory( repoDir )
  
  # We will use md5hash list in checking whether md5hash is in the Repository
  md5hashList <- executeSingleQuery( dir = repoDir,
                                     paste0( "SELECT md5hash FROM artifact" ) )
  md5hashList <- as.character( md5hashList[, 1] )
  
  # what if many md5hashes are passed to be deleted?
  if ( many ){
    
    # remove the miniature of an object
    if ( removeMiniature ){
      sapply( md5hash, function( md5hashSingle ) {
        if ( file.exists( file.path( repoDir, "gallery", paste0(md5hashSingle, ".png") ) ) )
          file.remove( file.path( repoDir, "gallery", paste0(md5hashSingle, ".png") ) )
        
        if ( file.exists( file.path( repoDir, "gallery", paste0(md5hashSingle, ".txt") ) ) )
          file.remove( file.path( repoDir, "gallery", paste0(md5hashSingle, ".txt") ) )
      } )
    }
    
    # send deletes for data 
    if ( removeData ){
      dataMd5hash <-  executeSingleQuery( dir = repoDir,
                                          paste0( "SELECT artifact FROM tag WHERE ",
                                                  "tag IN ('", paste0("relationWith:", md5hash, collapse="','"), "')" ) )
      # We want dataMd5hash as a character vector, not a data frame
      dataMd5hash <- unlist(dataMd5hash, use.names = FALSE) 
      
      # remove object's data from backpack.db file
      executeSingleQuery( dir = repoDir,
                          paste0( "DELETE FROM artifact WHERE ",
                                  "md5hash IN ('", paste0( dataMd5hash, collapse = "','" ), "')")
      )
      executeSingleQuery( dir = repoDir,
                          paste0( "DELETE FROM tag WHERE ",
                                  "artifact IN ('", paste0( dataMd5hash, collapse = "','" ), "')")
      )      
      
      # remove object's data files from gallery folder
      sapply( dataMd5hash, function(dataMd5hashSingle){
        if ( file.exists( file.path( repoDir, "gallery", paste0(dataMd5hashSingle, ".rda") ) ) )
          file.remove( file.path( repoDir, "gallery", paste0(dataMd5hashSingle, ".rda") ) )
        if ( file.exists( file.path( repoDir, "gallery", paste0(dataMd5hashSingle, ".txt") ) ) )
          file.remove( file.path( repoDir, "gallery", paste0(dataMd5hashSingle, ".txt") ) )
      })
      
    }
    
    # if we gave the wrong md5hash character, the following error would occur:
    if (!all(is.element(md5hash, md5hashList))){
      warning("Some of the artifacts were not deleted. One or more md5hash is not in the Repository.
If you used artifact's md5hash that was recently deleted from repository then it's data or miniatures were removed.
Otherwise you used md5hash that was not stored in the repository. Try again with different md5hash.") 
    }
    # remove objects from backpack.db file
    executeSingleQuery( dir = repoDir,
                        paste0( "DELETE FROM artifact WHERE ",
                                "md5hash IN ('", paste0( md5hash, collapse = "','" ), "')")
                      )
                        
    executeSingleQuery( dir = repoDir,
                        paste0( "DELETE FROM tag WHERE ",
                                "artifact IN ('", paste0( md5hash, collapse = "','" ), "')")
                      )      
    
    # remove objects' files from gallery folder
    sapply( md5hash, function( md5hashSingle ) {
    if ( file.exists( file.path( repoDir, "gallery", paste0(md5hashSingle, ".rda") ) ) )
      file.remove( file.path( repoDir, "gallery", paste0(md5hashSingle, ".rda" ) ) )
    } )    
                        
  } else {  
  
  # what if abbreviation was given
  if ( nchar( md5hash ) < 32 ){
    
    md5hash <- unique( grep( 
      pattern = paste0( "^", md5hash ), 
      x = md5hashList, 
      value = TRUE ) )
    
    # if we gave the wrong md5hash character, the following error would occur:
    if (length(md5hash) == 0){
      stop( "Given md5hash is not in the Repository. Try again with different md5hash abbreviation.
If you used artifact's md5hash abreviation that was deleted then try to use complete md5hash.")
    }
  }
  
  # remove the miniature of an object
  if ( removeMiniature ){
    if ( file.exists( file.path( repoDir, "gallery", paste0(md5hash, ".png") ) ) )
      file.remove( file.path( repoDir, "gallery", paste0(md5hash, ".png") ) )
    
    if ( file.exists( file.path( repoDir, "gallery", paste0(md5hash, ".txt") ) ) )
      file.remove( file.path( repoDir, "gallery", paste0(md5hash, ".txt") ) )
  }

  # send deletes for data 
  if ( removeData ) {
    # if there are many objects with the same md5hash (copies) all of them will be deleted  

    # find object's data md5hash(es) in backpack.db file
    dataMd5hash <-  executeSingleQuery( dir = repoDir,
                                        paste0( "SELECT artifact FROM tag WHERE ",
                                                "tag IN ('", paste0("relationWith:", md5hash, collapse="','"), "')" ) )
    
    # we want dataMd5hash as a character vector, not a data frame
    dataMd5hash <- unlist(dataMd5hash, use.names = FALSE) 
    
    if ( length( dataMd5hash ) >  1  & !force ){
      stop( "Data related to ", md5hash, " are also in relation with other artifacts. \n",
            "To remove try again with argument removeData = FALSE to remove artifact only or with argument force = TRUE to remove data anyway.")
    }
    if ( length( dataMd5hash ) > 1  & force )
      cat( "Data related to more than 1 artifact was removed from Repository.")
    
    # remove object's (objects') data from backpack.db file
    executeSingleQuery( dir = repoDir,
                        paste0( "DELETE FROM artifact WHERE ",
                                "md5hash IN ('", paste0( dataMd5hash, collapse = "','" ), "')")
    )
    
    executeSingleQuery( dir = repoDir,
                        paste0( "DELETE FROM tag WHERE ",
                                "artifact IN ('", paste0( dataMd5hash, collapse = "','" ), "')")
    )
    
    # remove object's(objects') data files from gallery folder    
    sapply( dataMd5hash, function(dataMd5hashSingle){
      if ( file.exists( file.path( repoDir, "gallery", paste0(dataMd5hashSingle, ".rda") ) ) )
        file.remove( file.path( repoDir, "gallery", paste0(dataMd5hashSingle, ".rda") ) )
      if ( file.exists( file.path( repoDir, "gallery", paste0(dataMd5hashSingle, ".txt") ) ) )
        file.remove( file.path( repoDir, "gallery", paste0(dataMd5hashSingle, ".txt") ) )
    })
  }
  
  
  # if we gave the wrong md5hash character, the following error would occur:
  if (!is.element(md5hash, md5hashList)){
    warning("Given md5hash is not in the Repository.
If you used artifact's md5hash that was recently deleted from repository then it's data or miniatures were removed.
Otherwise you used md5hash that was not stored in the repository. Try again with different md5hash.") 
  }
  
  # remove object from database
  # if there are many objects with the same md5hash (copies) all of them will be deleted
  sapply( md5hash, function(x){
    executeSingleQuery( dir = repoDir,
                paste0( "DELETE FROM artifact WHERE ",
                        "md5hash = '", x, "'" ) )} )
  sapply( md5hash, function(x){
    executeSingleQuery( dir = repoDir,
                paste0( "DELETE FROM tag WHERE ",
                        "artifact = '", x, "'" ) )} )
   
  # remove object's files from gallery folder
  if ( file.exists( file.path( repoDir, "gallery", paste0(md5hash, ".rda") ) ) )
    file.remove( file.path( repoDir, "gallery", paste0(md5hash, ".rda") ) )
  
}
invisible(NULL)
}

#' @family archivist
#' @rdname rmFromLocalRepo
#' @export
rmFromRepo <- function(...) {
  .Deprecated("rmFromRepo is deprecated. Use rmFromLocalRepo() instead.")
  rmFromLocalRepo(...)
}

