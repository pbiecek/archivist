##    archivist package for R
##
#' @title Load Artifact Given as a md5hash from a Repository
#'
#' @description
#' \code{loadFromLocalRepo} loads an artifact from a local \link{Repository} into the workspace.
#' \code{loadFromGithubRepo} loads an artifact from a Github \link{Repository} into the workspace.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' Functions \code{loadFromLocalRepo} and \code{loadFromGithubRepo} load artifacts from the archivist Repositories 
#' stored in a local folder or on Github. Both of them take \code{md5hash} as a
#' parameter, which is a result of \link{saveToRepo} function.
#' For each artifact, \code{md5hash} is a unique string of length 32 that is produced by
#' \link[digest]{digest} function, which uses a cryptographical MD5 hash algorithm. For more information see \link{md5hash}.
#' 
#' Important: instead of giving the whole \code{md5hash} character, the user can simply give first few characters of the \code{md5hash}.
#' For example, \code{a09dd} instead of \code{a09ddjdkf9kj33dcjdnfjgos9jd9jkcv}. All artifacts with the same \code{md5hash} 
#' abbreviation will be loaded from \link{Repository}.
#' 
#' Note that \code{user} and \code{repo} should be used only when working with a Github repository and should be omitted in the local mode. 
#' \code{repoDir} should only be used when working on a local Repository and should be omitted in the Github mode.
#' 
#' One may notice that \code{loadFromGithubRepo} and \code{loadFromLocalRepo} load artifacts to the Global
#' Environment with their original names. Alternatively,
#' a parameter \code{value = TRUE} can be specified so that these functions may return artifacts as a value. As a result loaded artifacts
#' can be attributed to new names. Note that, when an abbreviation of \code{md5hash} was given then a list of artifacts corresponding to this
#' abbreviation will be loaded.
#' 
#' @note
#' You can specify one \code{md5hash} (or its abbreviation) per function call. 
#' 
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in Github mode then global parameters
#' set in \link{setGithubRepo} function are used.
#' 
#' @param repoDir A character denoting an existing directory from which an artifact will be loaded.
#' If set to \code{NULL} (by default), uses the \code{repoDir} specified in \link{setLocalRepo}.
#' 
#' @param md5hash A character assigned to the artifact as a result of a cryptographical hash function with MD5 algorithm, or it's abbreviation.
#' 
#' @param repo While working with a Github repository. A character containing a name of a Github repository on which the Repository is archived.
#' By default set to \code{NULL} - see \code{Note}.
#' @param user While working with a Github repository. A character containing a name of a Github user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}. 
#' @param branch While working with a Github repository. A character containing a name of 
#' Github Repository's branch on which the Repository is archived. Default \code{branch} is \code{master}.
#' 
#' @param repoDirGit While working with a Github repository. A character containing a name of a directory on Github repository 
#' on which the Repository is stored. If the Repository is stored in main folder on Github repository, this should be set 
#' to \code{repoDirGit = FALSE} as default.
#' 
#' @param value If \code{FALSE} (default) then artifacts are loaded into the Global Environment with their original names, 
#' if \code{TRUE} then artifacts are returned as a list of values (if there is more than one artifact)
#' or as a single value (if there is only one arfifact that matches md5hash).
#' 
#' @author 
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#'  
#' @examples
#' 
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
#' exampleRepoDir <- tempdir()
#' createEmptyRepo(repoDir = exampleRepoDir)
#' myplo123Md5hash <- saveToRepo(myplot123, repoDir=exampleRepoDir)
#' irisMd5hash <- saveToRepo(iris, repoDir=exampleRepoDir)
#' modelMd5hash  <- saveToRepo(model, repoDir=exampleRepoDir)
#' agn1Md5hash <- saveToRepo(agn1, repoDir=exampleRepoDir)
#' fannyxMd5hash <- saveToRepo(fannyx, repoDir=exampleRepoDir)
#' 
#' # let's see how the Repository looks like: show
#' 
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # let's see how the Repository looks like: summary
#' 
#' summaryLocalRepo( exampleRepoDir )
#' 
#' # load examples
#' 
#' # first let's remove objects from Global Environment
#' rm(myplot123)
#' rm(iris)
#' rm(agn1)
#' 
#' # if those objects were archivised, they can be loaded
#' # from Repository, when knowing their md5hash
#' 
#' loadFromLocalRepo(myplo123Md5hash, repoDir = exampleRepoDir)
#' loadFromLocalRepo(irisMd5hash, repoDir = exampleRepoDir)
#' 
#' 
#' # if one doesn't remember the object's md5hash but
#' # remembers the object's name, this object can still be
#' # loaded.
#' 
#' agnesHash <- searchInLocalRepo( "name:agn1", repoDir = exampleRepoDir)
#' loadFromLocalRepo(agnesHash, repoDir = exampleRepoDir)
#' 
#' # one can check that object has his own unique md5hash
#' agnesHash == agn1Md5hash
#' 
#' # object can be loadad as a value
#' 
#' newData <- loadFromLocalRepo(irisMd5hash, repoDir = exampleRepoDir, value = TRUE)
#' 
#' # object can be also loaded from it's abbreviation
#' # modelMd5hash <- saveToRepo( model , repoDir=exampleRepoDir)
#' rm( model )
#' # "cd6557c6163a6f9800f308f343e75e72"
#' # so example abbreviation might be : "cd6557c"
#' loadFromLocalRepo("cd6557c", repoDir = exampleRepoDir)
#' 
#' # and can be loaded as a value from it's abbreviation
#' newModel  <- loadFromLocalRepo("cd6557c", repoDir = exampleRepoDir, value = TRUE)
#' # note that "model" was not deleted
#' 
#' #
#' #GitHub Version
#' #
#' 
#' # check the state of the Repository
#' summaryGithubRepo( user="pbiecek", repo="archivist" )
#' showGithubRepo( user="pbiecek", repo="archivist" )
#' showGithubRepo( user="pbiecek", repo="archivist", method = "tags" )
#' 
#' rm( model )
#' rm( myplot123 )
#' rm( qda1 )
#' (VARmd5hash <- searchInGithubRepo( "varname:Sepal.Width", 
#'                    user="pbiecek", repo="archivist" ))
#' (NAMEmd5hash <- searchInGithubRepo( "name:qda1", 
#'                    user="pbiecek", repo="archivist", branch="master" ))
#' (CLASSmd5hash <- searchInGithubRepo( "class:ggplot", 
#'                    user="pbiecek", repo="archivist", branch="master" ))
#' 
#' 
#' loadFromGithubRepo( "ff575c261c", user="pbiecek", repo="archivist")
#' NewObjects <- loadFromGithubRepo( NAMEmd5hash, user="pbiecek", repo="archivist", value = TRUE )
#' loadFromGithubRepo( CLASSmd5hash, user="pbiecek", repo="archivist")
#' 
#' 
#' ## Loading artifacts from the repository which is built in the archivist package 
#' ## and saving them on the example repository
#' 
#' # Creating an example Repository - on which artifacts loaded from the archivist package repository
#' # will be saved
#' exampleRepoDir <- tempdir()
#' createEmptyRepo(repoDir = exampleRepoDir)
#' 
#' # Directory of the archivist package repository
#' repo_archivist <- system.file("graphGallery", package = "archivist") 
#' # We are checking what kind of objects are stored in the archivist package repository
#' summaryLocalRepo(repoDir = repo_archivist)
#' # Let's say that we are interested in an artifact of class ggplot.
#' GGPLOTmd5hash <- searchInLocalRepo(pattern = "class:ggplot", repoDir = repo_archivist) # There are eight of them
#' # We load the first one by its value (parameter value = TRUE) and assign it to the plot variable.
#' plot <- loadFromLocalRepo(GGPLOTmd5hash[1], repoDir = repo_archivist, value = TRUE)
#' 
#' # Finally, we may save the artifact on the example Repository.
#' # Note that md5hash is different from the one which is stored in the archivist package repository.
#' saveToRepo(plot, repoDir = exampleRepoDir) 
#' # Making sure that the artifact is stored on the example repository
#' showLocalRepo(repoDir = exampleRepoDir, method = "tags")
#' 
#' # removing an example Repository
#' 
#' deleteRepo( exampleRepoDir, TRUE)
#' 
#' rm( exampleRepoDir )
#' 
#' # many archivist-like Repositories on one Github repository
#' 
#' loadFromGithubRepo( "ff575c261c949d073b2895b05d1097c3", 
#' user="MarcinKosinski", repo="Museum", branch="master", repoDirGit="ex2")
#' 
#' 
#' loadFromGithubRepo( "ff575c261c949d073b2895b05d1097c3", 
#'                     user="MarcinKosinski", repo="Museum", branch="master",
#'                     repoDirGit="ex1")
#' }
#' @family archivist
#' @rdname loadFromRepo
#' @export
loadFromLocalRepo <- function( md5hash, repoDir = NULL, value = FALSE ){
  stopifnot( is.character( md5hash ) )
  stopifnot( is.character( repoDir ) | is.null( repoDir ) )
  stopifnot( is.logical( value ) )
  
  repoDir <- checkDirectory( repoDir )
  
  # what if abbreviation was given
  if ( nchar( md5hash ) < 32 ){
        
    md5hashList <- executeSingleQuery( dir = repoDir , 
                               paste0( "SELECT DISTINCT artifact FROM tag WHERE artifact LIKE '",md5hash,"%'" ) )
    md5hash <- as.character( md5hashList[, 1] )
  }
  
  # using sapply in case abbreviation mode found more than 1 md5hash
  if ( !value ) {
    sapply( md5hash, function(x) {
      load( file = paste0( repoDir, "gallery/", x, ".rda" ), envir = .GlobalEnv )
    } )
  }else{
    .nameEnv <- new.env()
    name <- character( length = length( md5hash ) )
    for( i in seq_along( md5hash ) ) {
      name[i] <- load( file = paste0( repoDir, "gallery/", md5hash[i], ".rda" ), 
                       envir = .nameEnv ) 
      }
    if ( length( name ) == 1) {
      return( as.list(.nameEnv)[[1]] )
    } else {
      return( as.list(.nameEnv) )
    }
  }
}

#' @rdname loadFromRepo
#' @export
loadFromGithubRepo <- function( md5hash, repo = NULL, user = NULL, branch = "master", repoDirGit = FALSE, value = FALSE ){
  stopifnot( is.character( c( md5hash, branch ) ) )
  stopifnot( is.logical( value ) )
  
  GithubCheck( repo, user, repoDirGit ) # implemented in setRepo.R
  
  
  # what if abbreviation was given
  if ( nchar( md5hash ) < 32 ){
    # database is needed to be downloaded
    Temp <- downloadDB( repo, user, branch, repoDirGit )
    
    md5hashList <- executeSingleQuery( dir = Temp, realDBname = FALSE,
                                       paste0( "SELECT DISTINCT artifact FROM tag WHERE artifact LIKE '",md5hash,"%'" ) )
    md5hash <- as.character( md5hashList[, 1] )
    
    file.remove( Temp )
  }
      
  # load artifacts from Repository
  if ( !value ){
    
    # sapply and replicate because of abbreviation mode can find more than 1 md5hash
    if( is.character( repoDirGit )){
    tmpobjectS <- lapply( md5hash, function(x){
      getBinaryURL( paste0( get( x = ".GithubURL", envir = .ArchivistEnv), user, "/", repo, "/",
                            branch, "/", repoDirGit, "/gallery/", x, ".rda") )  } )
    }
    if( is.logical( repoDirGit )){
      tmpobjectS <- lapply( md5hash, function(x){
        getBinaryURL( paste0( get( x = ".GithubURL", envir = .ArchivistEnv), user, "/", repo, "/",
                              branch, "/gallery/", x, ".rda") )  } )  
    }
    tfS <- replicate( length( md5hash ), tempfile() )
        
    for (i in seq_along( tfS )){
      writeBin( tmpobjectS[[i]], tfS[i] )
      load( file = tfS[i] , envir =.GlobalEnv)
    } 
    

  }else{
    # returns objects as value

    # sapply and replicate because of abbreviation mode can find more than 1 md5hash
    if( is.character( repoDirGit )){
      tmpobjectS <- lapply( md5hash, function(x){
        getBinaryURL( paste0( get( x = ".GithubURL", envir = .ArchivistEnv), user, "/", repo, "/",
                              branch, "/", repoDirGit, "/gallery/", x, ".rda") )  } )
    }
    if( is.logical( repoDirGit )){
      tmpobjectS <- lapply( md5hash, function(x){
        getBinaryURL( paste0( get( x = ".GithubURL", envir = .ArchivistEnv), user, "/", repo, "/",
                              branch, "/gallery/", x, ".rda") )  } )  
    }
    tfS <- replicate( length( md5hash ), tempfile() )
    
    for (i in seq_along(tmpobjectS)){
      writeBin( tmpobjectS[[i]], tfS[i] )
    }
    # in case there existed an object in GlobalEnv this function will not delete him
    .nameEnv <- new.env()
    name <- character( length = length( md5hash ) )
    for( i in seq_along( md5hash ) ) {
      name[i] <- load( file =  tfS[i] , 
                       envir = .nameEnv ) 
    }
    if (length(name) == 1) {
      return(as.list(.nameEnv)[[1]])
    } else {
      return(as.list(.nameEnv))
  }
}
}
