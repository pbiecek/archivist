##    archivist package for R
##
#' @title Load Object Given as md5hash from Repository
#'
#' @description
#' \code{loadFromLocalRepo} loads an object from a local \link{Repository} into the workspace.
#' \code{loadFromGithubRepo} loads an object from a Github \link{Repository} into the workspace.
#' 
#' 
#' @details
#' Functions \code{loadFromLocalRepo} and \code{loadFromGithubRepo} load objects from archivist repositories stored in local folder or on Github. Both of them take \code{md5hash} as a
#' parameter. This \code{md5hash} is a string of length 32 that comes out as a result from \link{saveToRepo} function, which uses a cryptographical hash function with MD5 algorithm.
#' 
#' Important: instead of giving whole \code{md5hash} name, user can simply give first few signs of desired \code{md5hash} - an abbreviation.
#' For example \code{a09dd} instead of \code{a09ddjdkf9kj33dcjdnfjgos9jd9jkcv}. But if several \code{md5hashes} 
#' start with the same pattern, all objects with this \code{md5hash} abbreviation will be loaded from \link{Repository}.
#' 
#' Note that \code{user} and \code{repo} should be used only when working on Github Repository and ought to be omitted in a local working mode, 
#' when \code{dir} should only be used when working on a local Repository and ought to be omitted in a Github working mode.
#' 
#' One may notice that loadFromGithubRepo and loadFromLocalRepo load objects to the Global
#' Environment with it's original name. If one is not satisfied with that solution,
#' a parameter returns = TRUE might be specified so that functions return object as a result that
#' can be attributed to a new name.
#' 
#' Remember that when abbreviation of \code{md5hash} was given a couple of different objects
#' suiting that abbreviation will be loadad as a list.
#' 
#' @note
#' You can load one object at one call.
#' 
#' @param dir A character denoting an existing directory from which an object will be loaded.
#' 
#' @param md5hash A hash of an object. A character string being a result of a cryptographical hash function with MD5 algorithm or it's abbreviation.
#' 
#' @param repo Only if working on Github Repository. A character containing a name of Github Repository.
#' 
#' @param user Only if working on Github Repository. A character containing a name of Github User.
#' 
#' @param returns A logical value denoting whether to load an object into the Global Environment 
#' (that is set by default \code{FALSE}) or whether to return an object as a function's result (\code{TRUE}).
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
#' model2 <- lm(Sepal.Length~ Sepal.Width + Petal.Width, data= iris)
#' model3 <- lm(Sepal.Length~ Sepal.Width, data= iris)
#' 
#' # agnes (twins) object 
#' data(votes.repub)
#' library(cluster)
#' agn1 <- agnes(votes.repub, metric = "manhattan", stand = TRUE)
#' 
#' # fanny (partition) object
#' x <- rbind(cbind(rnorm(10, 0, 0.5), rnorm(10, 0, 0.5)),
#'          cbind(rnorm(15, 5, 0.5), rnorm(15, 5, 0.5)),
#'           cbind(rnorm( 3,3.2,0.5), rnorm( 3,3.2,0.5)))
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
#' 
#' # load examples
#' 
#' # first let's remove object from Global Environment
#' rm(myplo123)
#' rm(iris)
#' rm(model)
#' rm(agn1)
#' rm(fannyx)
#' 
#' # it those objects were archivised, they can be loaded
#' # from Repository, when knowing their tags
#' 
#' loadFromLocalRepo(myplo123Md5hash, dir = exmapleDir)
#' loadFromLocalRepo(irisMd5hash, dir = exmapleDir)
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
#' # fannyxMd5hash <- saveToRepo(fannyx, dir=exampleDir)        
#' # "01785982a662038f720aa85e688f2082"
#' # so example abbreviation might be : "0178598"
#' loadFromLocalRepo("0178598", dir = exampleDir)
#' 
#' # and can be lodad as a value from it's abbreviation
#' newFanny  <- loadFromLocalRepo("0178598", dir = exampleDir, returns = TRUE)
#' 
#' # removing all files generated to this function's examples
#' x <- list.files( paste0(exampleDir, "/gallery/" ) )
#' sapply( x , function(x ){
#'      file.remove( paste0(exampleDir, "/gallery/", x ) )
#'    })
#' file.remove( paste0(exampleDir, "/backpack.db" ) )
#'
#' 
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
    sapply( md5hash, function(x){
            load( file = paste0( dir, "gallery/", x, ".rda" ), envir = .GlobalEnv ) } )
      
    name <- sapply( md5hash, function(x){
            load( file = paste0( dir, "gallery/", x, ".rda" ), envir = .GlobalEnv ) } )
      
    objects <- sapply( name , function(y){ 
               get(x= y, envir = .GlobalEnv ) } )      
    
    return( objects )
  }
}



#' @rdname loadFromLocalRepo
#' @export
loadFromGithubRepo <- function( md5hash, repo, user, returns = FALSE ){
  stopifnot( is.character( c( md5hash, repo, user ) ) )
  stopifnot( is.logical( returns ))
  
  # what if abbreviation was given
  
  # need to check whole database
  
  # willlll not work if abbreviation is given YET
  
  #

  # load plot from archive
  if ( !returns ){
    library(RCurl)
    # sapply and replicate because of abbreviation mode can find more than 1 md5hash
    tmpobjectS <- sapply( md5hash, function(x){
                          getBinaryURL( paste0( "https://raw.githubusercontent.com", user, "/", repo, 
                                                 "/master/gallery/", x, ".rda") ) } )
    tfS <- replicate( length( md5hash ), tempfile() )
    
    writeBin( tmpobjectS, tfS ) # not sure it fhis functions knows how to work on 
                                # arguments that are vectors. if problems - let's make a loop
    # for (i in 1:length(tmpobjectS)){
    # writeBin( tmpobjectS[i], tfS[i] )
    # }
    
    sapply( tfS, function(x){
          load( file = x, envir = .GlobalEnv ) } )
    
    sapply( tfS, unlink )
    tmpobjectS <- NULL
  }else{
    library(RCurl)
    # sapply and replicate because of abbreviation mode can find more than 1 md5hash
      tmpobjectS <- sapply( md5hash, function(x){
      getBinaryURL( paste0( "https://raw.github/", user, "/", repo, 
                            "/gallery/", x, ".rda") )  } )
      tfS <- replicate( length( md5hash ), tempfile() )
      
      writeBin( tmpobjectS, tfS )
      
      sapply( tfS, function(x){
        load( file = x, envir = .GlobalEnv ) } )
      
      name <- sapply( tfS, function(x){
        load( file = x, envir = .GlobalEnv ) } )
      
      objects <- sapply( name , function(y){ 
        get(x= y, envir = .GlobalEnv ) } ) 
      
      sapply( tfS, unlink )
      tmpobjectS <- NULL
      
      return( objects )
      
  }
}

