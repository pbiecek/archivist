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
#' \code{dir} should only be used when working on a local Repository and should be omitted in the Github mode.
#' 
#' One may notice that \code{loadFromGithubRepo} and \code{loadFromLocalRepo} load objects to the Global
#' Environment with their original names. Alternatively,
#' a parameter \code{returns = TRUE} might be specified so that the functions return objects as a result so that they
#' can be attributed to new names. Note that, when an abbreviation of \code{md5hash} was given a list of objects corresponding to this
#' abbreviation will be loaded.
#' 
#' @note
#' You can specify one \code{md5hash} (or its abbreviation) per function call.
#' 
#' @param dir A character denoting an existing directory from which an object will be loaded.
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
#' @param returns A logical value denoting whether to load an object into the Global Environment 
#' (that is set by default to \code{FALSE}) or whether to return an object as the result of the function (\code{TRUE}).
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
#' exampleDir <- tempdir()
#' createEmptyRepo(dir = exampleDir)
#' myplo123Md5hash <- saveToRepo(myplot123, dir=exampleDir)
#' irisMd5hash <- saveToRepo(iris, dir=exampleDir)
#' modelMd5hash  <- saveToRepo(model, dir=exampleDir)
#' agn1Md5hash <- saveToRepo(agn1, dir=exampleDir)
#' fannyxMd5hash <- saveToRepo(fannyx, dir=exampleDir)
#' 
#' # let's see how the Repository look like: summary
#' 
#' summaryLocalRepo(method = "md5hashes", dir = exampleDir)
#' summaryLocalRepo(method = "tags", dir = exampleDir)
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
#' loadFromLocalRepo(myplo123Md5hash, dir = exampleDir)
#' loadFromLocalRepo(irisMd5hash, dir = exampleDir)
#' 
#' 
#' # if one can not remembers the object's md5hash but
#' # remembers the object's name this object can still be
#' # loaded.
#' 
#' modelHash <- searchInLocalRepo( "name:model", dir = exampleDir)
#' loadFromLocalRepo(modelHash, dir = exampleDir)
#' 
#' # one can check that object has his own unique md5hash
#' modelHash == modelMd5hash
#' 
#' # object can be loadad as a value
#' 
#' newData <- loadFromLocalRepo(irisMd5hash, dir = exampleDir, returns = TRUE)
#' 
#' # object can be also loaded from it's abbreviation
#' # modelMd5hash <- saveToRepo( model , dir=exampleDir)
#' rm( model )
#' # "cd6557c6163a6f9800f308f343e75e72"
#' # so example abbreviation might be : "cd6557c"
#' loadFromLocalRepo("cd6557c", dir = exampleDir)
#' 
#' # and can be loaded as a value from it's abbreviation
#' newModel  <- loadFromLocalRepo("cd6557c", dir = exampleDir, returns = TRUE)
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
#' NewObjects <- loadFromGithubRepo( CLASSmd5hash, user="pbiecek", repo="archivist", returns = TRUE )
#' loadFromGithubRepo( DATEmd5hash, user="pbiecek", repo="archivist")
#' 
#' 
#' # removing all files generated to this function's examples
#' x <- list.files( paste0( exampleDir, "/gallery/" ) )
#' sapply( x , function(x ){
#'      file.remove( paste0( exampleDir, "/gallery/", x ) )
#'    })
#' file.remove( paste0( exampleDir, "/backpack.db" ) )
#' 
#' rm( exampleDir )
#' @family archivist
#' @rdname loadFromLocalRepo
#' @export
loadFromLocalRepo <- function( md5hash, dir, returns = FALSE ){
  stopifnot( is.character( c( md5hash, dir ) ) )
  stopifnot( is.logical( returns ))
  
  # check if dir has "/" at the end and add it if not
  if ( regexpr( pattern = ".$", text = dir ) != "/" ){
    dir <- paste0(  dir, "/"  )
  }
  
  # what if abbreviation was given
  if ( nchar( md5hash ) < 32 ){
    sqlite <- dbDriver( "SQLite" )
    conn <- dbConnect( sqlite, paste0( dir, "backpack.db" ) )
    
    md5hashList <- dbGetQuery( conn,
                               paste0( "SELECT artifact FROM tag" ) )
    md5hashList <- as.character( md5hashList[, 1] )
    md5hash <- unique( grep( 
      pattern = paste0( "^", md5hash ), 
      x = md5hashList, 
      value = TRUE ) )
    
    dbDisconnect( conn )
    dbUnloadDriver( sqlite ) 
    
  }
  
  # using sapply in case abbreviation mode found more than 1 md5hash
  if ( !returns ){
    sapply( md5hash, function(x){
      load( file = paste0( dir, "gallery/", x, ".rda" ), envir = .GlobalEnv )
    } )
  }else{
    .nameEnv <- new.env()
    name <- character( length = length( md5hash ) )
    for( i in 1:length( md5hash ) ){
      name[i] <- load( file = paste0( dir, "gallery/", md5hash[i], ".rda" ), 
                       envir = .nameEnv ) 
      }
    # in case there existed an object in GlobalEnv this function will not delete him
    NotDelete <- as.logical(sapply( name , exists, envir = .GlobalEnv))
    
    sapply( md5hash, function(x){
      load( file = paste0( dir, "gallery/", x, ".rda" ), envir = .GlobalEnv ) } )
    
    objects <- sapply( name , function(y){ 
      get(x= y, envir = .GlobalEnv ) } ) 
    
    rm( list = name[!NotDelete], envir = .GlobalEnv)
    
    return( objects )
  }
}





#' @rdname loadFromLocalRepo
#' @export
loadFromGithubRepo <- function( md5hash, repo, user, branch = "master" , returns = FALSE ){
  stopifnot( is.character( c( md5hash, repo, user, branch ) ) )
  stopifnot( is.logical( returns ))
  
  # what if abbreviation was given
  if ( nchar( md5hash ) < 32 ){
    # database is needed to be downloaded
    URLdb <- paste0( "https://raw.githubusercontent.com/", user, "/", repo, 
                     "/", branch, "/backpack.db") 
    library( RCurl )
    db <- getBinaryURL( URLdb, ssl.verifypeer = FALSE )
    writeBin( db, "load.db")
    
    sqlite <- dbDriver( "SQLite" )
    conn <- dbConnect( sqlite, "load.db" )
    
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
    file.remove( paste0( dir, "backpack.db" ) )
    dir <- NULL
    
  }
  
  # load objecs from Repository
  if ( !returns ){
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
    .nameEnv <- new.env()
    name <- character( length = length( md5hash ) )
    for( i in 1:length( md5hash ) ){
      name[i] <- load( file =  tfS[i] , envir = .nameEnv ) 
    }    
    NotDelete <- sapply( name , exists, envir = .GlobalEnv)
    
    sapply( tfS, function(x){
      load( file = x, envir = .GlobalEnv ) } )
    
    objects <- sapply( name , function(y){ 
      get(x= y, envir = .GlobalEnv ) } ) 
    
    sapply( tfS, unlink )
    tmpobjectS <- NULL
    
    rm( list = name[!NotDelete], envir = .GlobalEnv)
    
    return( objects )
    
  }
}
