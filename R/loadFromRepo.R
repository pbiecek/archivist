##    archivist package for R
##
#' @title Load Object Given as a \code{md5hash} from a Repository
#'
#' @description
#' \code{loadFromLocalRepo} loads an object from a local \link{Repository} into the workspace.
#' \code{loadFromGithubRepo} loads an object from a Github \link{Repository} into the workspace.
#' 
#' 
#' @details
#' Functions \code{loadFromLocalRepo} and \code{loadFromGithubRepo} load objects from archivist repositories stored in a local folder or on Github. Both of them take \code{md5hash} as a
#' parameter. This \code{md5hash} is a string of length 32, which is a result from \link{saveToRepo} function.
#' 
#' Important: instead of giving the whole \code{md5hash} character, the user can simply give first few characters of the \code{md5hash}.
#' For example, \code{a09dd} instead of \code{a09ddjdkf9kj33dcjdnfjgos9jd9jkcv}. All objects with the same corresponing \code{md5hash} abbreviation will be loaded from \link{Repository}.
#' 
#' Note that \code{user} and \code{repo} should be used only when working with a Github repository and should be omitted in the local mode. 
#' \code{repoDir} should only be used when working on a local Repository and should be omitted in the Github mode.
#' 
#' One may notice that \code{loadFromGithubRepo} and \code{loadFromLocalRepo} load objects to the Global
#' Environment with their original names. Alternatively,
#' a parameter \code{value = TRUE} might be specified so that the functions return objects as a result so that they
#' can be attributed to new names. Note that, when an abbreviation of \code{md5hash} was given a list of objects corresponding to this
#' abbreviation will be loaded.
#' 
#' @note
#' You can specify one \code{md5hash} (or its abbreviation) per function call.
#' 
#' @param repoDir A character denoting an existing directory from which an object will be loaded.
#' 
#' @param md5hash A character assigned to the object as a result of a cryptographical hash function with MD5 algorithm, or it's abbreviation.
#' 
#' @param repo Only if working with a Github repository. A character containing a name of a Github repository on which the Repository is archived.
#' 
#' @param user Only if working with a Github repository. A character containing a name of a Github user on whose account the \code{repo} is created.
#' 
#' @param branch Only if working with a Github repository. A character containing a name of 
#' Github Repository's branch on which a Repository is archived. Default \code{branch} is \code{master}.
#' 
#' @param value If \code{FALSE} (default) then artifacts are loaded into the Global Environment with their original names, 
#' if \code{TRUE} then artifacts are returned as a list of values (if there is more than one artifact)
#' or as a single value (if there is only one arfifact that matches md5hash).
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
#' # let's see how the Repository look like: summary
#' 
#' summaryLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' summaryLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' # load examples
#' 
#' # first let's remove object from Global Environment
#' rm(myplot123)
#' rm(iris)
#' rm(agn1)
#' 
#' # it those objects were archivised, they can be loaded
#' # from Repository, when knowing their tags
#' 
#' loadFromLocalRepo(myplo123Md5hash, repoDir = exampleRepoDir)
#' loadFromLocalRepo(irisMd5hash, repoDir = exampleRepoDir)
#' 
#' 
#' # if one can not remembers the object's md5hash but
#' # remembers the object's name this object can still be
#' # loaded.
#' 
#' modelHash <- searchInLocalRepo( "name:model", repoDir = exampleRepoDir)
#' loadFromLocalRepo(modelHash, repoDir = exampleRepoDir)
#' 
#' # one can check that object has his own unique md5hash
#' modelHash == modelMd5hash
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
#' # check the state of database
#' summaryGithubRepo( user="pbiecek", repo="archivist" )
#' 
#' (VARmd5hash <- searchInGithubRepo( "varname:Sepal.Width", user="pbiecek", repo="archivist" ))
#' (NAMEmd5hash <- searchInGithubRepo( "name:model2", user="pbiecek", repo="archivist", branch="master" ))
#' (CLASSmd5hash <- searchInGithubRepo( "class:lm", user="pbiecek", repo="archivist", branch="master" ))
#' (DATEmd5hash <- searchInGithubRepo( "date:2014-08-17 13:44:47", user="pbiecek", repo="archivist" ))
#'  
#' loadFromGithubRepo( VARmd5hash, user="pbiecek", repo="archivist")
#' loadFromGithubRepo( NAMEmd5hash, user="pbiecek", repo="archivist")
#' NewObjects <- loadFromGithubRepo( CLASSmd5hash, user="pbiecek", repo="archivist", value = TRUE )
#' loadFromGithubRepo( DATEmd5hash, user="pbiecek", repo="archivist")
#' 
#' 
#' # removing all files generated to this function's examples
#' x <- list.files( paste0( exampleRepoDir, "/gallery/" ) )
#' sapply( x , function(x ){
#'      file.remove( paste0( exampleRepoDir, "/gallery/", x ) )
#'    })
#' file.remove( paste0( exampleRepoDir, "/backpack.db" ) )
#' 
#' rm( exampleRepoDir )
#' @family archivist
#' @rdname loadFromLocalRepo
#' @export
loadFromLocalRepo <- function( md5hash, repoDir, value = FALSE ){
  stopifnot( is.character( c( md5hash, repoDir ) ) )
  stopifnot( is.logical( value ))
  
  # check if repoDir has "/" at the end and add it if not
  if ( regexpr( pattern = ".$", text = repoDir ) != "/" ) {
    repoDir <- paste0(  repoDir, "/"  )
  }
  
  # what if abbreviation was given
  if ( nchar( md5hash ) < 32 ){
    sqlite <- dbDriver( "SQLite" )
    conn <- dbConnect( sqlite, paste0( repoDir, "backpack.db" ) )
    
    md5hashList <- dbGetQuery( conn,
                               paste0( "SELECT DISTINCT artifact FROM tag WHERE artifact LIKE '",md5hash,"%'" ) )
    md5hash <- as.character( md5hashList[, 1] )
    
    dbDisconnect( conn )
    dbUnloadDriver( sqlite ) 
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
    if (length(name) == 1) {
      return(as.list(.nameEnv)[[1]])
    } else {
      return(as.list(.nameEnv))
    }
  }
}





#' @rdname loadFromLocalRepo
#' @export
loadFromGithubRepo <- function( md5hash, repo, user, branch = "master" , value = FALSE ){
  stopifnot( is.character( c( md5hash, repo, user, branch ) ) )
  stopifnot( is.logical( value ))
  
  # what if abbreviation was given
  if ( nchar( md5hash ) < 32 ){
    # database is needed to be downloaded
    URLdb <- paste0( .GithubURL, user, "/", repo, 
                     "/", branch, "/backpack.db") 
    library( RCurl )
    db <- getBinaryURL( URLdb, ssl.verifypeer = FALSE )
    Temp <- tempfile()
    writeBin( db, Temp)
    
    sqlite <- dbDriver( "SQLite" )
    conn <- dbConnect( sqlite, Temp )
    
    md5hashList <- dbGetQuery( conn,
                               paste0( "SELECT artifact FROM tag" ) )
    md5hashList <- as.character( md5hashList[, 1] )
    md5hash <- unique( grep( 
      pattern = paste0( "^", md5hash ), 
      x = md5hashList, 
      value = TRUE ) )
    
    dbDisconnect( conn )
    dbUnloadDriver( sqlite ) 
    
    # when tags are collected, delete downloaded database
    file.remove( paste0( repoDir, Temp ) )
        
  }
  
  # load objecs from Repository
  if ( !value ){
    library(RCurl)
    options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
    
    # sapply and replicate because of abbreviation mode can find more than 1 md5hash
    tmpobjectS <- lapply( md5hash, function(x){
      getBinaryURL( paste0( "https://raw.githubusercontent.com/", user, "/", repo, 
                            "/", branch, "/gallery/", x, ".rda") ) } )
    tfS <- replicate( length( md5hash ), tempfile() )
    
    for (i in 1:length(tmpobjectS)){
      writeBin( tmpobjectS[[i]], tfS[i] )
    }
    
    
    
    sapply( tfS, function(x){
      load( file = x , envir =.GlobalEnv) } )
    
    sapply( tfS, unlink )
    tmpobjectS <- NULL
  }else{
    # returns objects as value
    library(RCurl)
    options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
    
    # sapply and replicate because of abbreviation mode can find more than 1 md5hash
    tmpobjectS <- lapply( md5hash, function(x){
      getBinaryURL( paste0( "https://raw.githubusercontent.com/", user, "/", repo, 
                            "/master/gallery/", x, ".rda") )  } )
    tfS <- replicate( length( md5hash ), tempfile() )
    
    for (i in 1:length(tmpobjectS)){
      writeBin( tmpobjectS[[i]], tfS[i] )
    }
    # in case there existed an object in GlobalEnv this function will not delete him
#     .nameEnv <- new.env()
#     name <- character( length = length( md5hash ) )
#     for( i in 1:length( md5hash ) ){
#       name[i] <- load( file =  tfS[i] , envir = .nameEnv ) 
#     }    
#     NotDelete <- sapply( name , exists, envir = .GlobalEnv)
#     
#     sapply( tfS, function(x){
#       load( file = x, envir = .GlobalEnv ) } )
#     
#     objects <- sapply( name , function(y){ 
#       get(x= y, envir = .GlobalEnv ) } ) 
#     
#     sapply( tfS, unlink )
#     tmpobjectS <- NULL
#     
#     rm( list = name[!NotDelete], envir = .GlobalEnv)
#     
#     return( objects )
    
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
