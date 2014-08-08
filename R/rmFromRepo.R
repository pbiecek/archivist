##    archivist package for R
##
#' @title Remove an Object Given as \code{md5hash} from a Repository
#'
#' @description
#' \code{rmFromRepo} removes an object given as \code{md5hash} from a \link{Repository}.
#'  
#' @details
#' \code{rmFromRepo} removes an object given as \code{md5hash} from a Repository, 
#' which is a SQLite database named \code{backpack} - created by a \link{createEmptyRepo} call.
#' For every object, \code{md5hash} is a unique string of length 32 that comes out as a result of 
#' \code{digest{digest}} function, which uses a cryptographical MD5 hash algorithm.
#' 
#' 
#' Also this function removes a \code{md5hash.rda} file, where \code{md5hash} is the object's hash as above.
#' 
#' 
#' Important: instead of giving the whole \code{md5hash} character, the user can simply give first few characters of the \code{md5hash}.
#' For example, \code{a09dd} instead of \code{a09ddjdkf9kj33dcjdnfjgos9jd9jkcv}. All objects with the same corresponing \code{md5hash} abbreviation 
#' will be removed from the \link{Repository} and from the \code{gallery} folder.
#' 
#' If one wants to remove all objects created between two dates, it is suggested to
#' perform:
#' \itemize{
#'    \item \code{obj2rm <- searchInLocalRepo( tag = list(dateFrom, dateTo), dir = )}
#'    \item \code{sapply(obj2rm, rmFromRepo, dir = )}
#' }
#' 
#' @note
#' \code{md5hash} can be a result of the \link{searchInRepo} function proceeded with \code{tag = NAME} argument,
#' where \code{NAME} is a tag that describes the property of the objects to be deleted. 
#' 
#' #TODO add functionality that enables not to delete miniature o txt files while removing rda file
#' 
#' For more information about \code{Tags} check \link{Tags}.
#' 
#' @param md5hash A character assigned to the object as a result of a cryptographical hash function with MD5 algorithm, or it's abbreviation. This object will be removed.
#' 
#' @param dir A character denoting an existing directory from which an object will be removed.
#' 
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
#' # let's see how the Repository look like: summary
#' summaryLocalRepo(method = "objects", dir = exampleDir)
#' summaryLocalRepo(method = "tags", dir = exampleDir)
#' 
#' 
#' # remove examples
#' 
#' rmFromRepo(fannyxMd5hash, dir = exampleDir)
#' rmFromRepo(irisMd5hash, dir = exampleDir)
#' # not that also files in gallery folder, created in exampleDir 
#' # directory are being removed
#' 
#' # let's see how the Repository look like: summary
#' summaryLocalRepo(method = "objects", dir = exampleDir)
#' summaryLocalRepo(method = "tags", dir = exampleDir)
#' 
#' # one can have the same object archivised in 3 different times
#' agn1Md5hash2 <- saveToRepo(agn1, dir=exampleDir)
#' agn1Md5hash3 <- saveToRepo(agn1, dir=exampleDir)
#' 
#' # md5hashes are the same for that same object (agn1)
#' agn1Md5hash == agn1Md5hash2
#' agn1Md5hash2 == agn1Md5hash3
#' 
#' # but there are 3 times more rows in Repository database (backpack.db).
#' 
#' # let's see how the Repository look like: summary
#' 
#' summaryLocalRepo(method = "objects", dir = exampleDir)
#' summaryLocalRepo(method = "tags", dir = exampleDir)
#' 
#' # one easy call removes them all
#' 
#' rmFromRepo(agn1Md5hash, dir = exampleDir)
#' 
#' # rest of object can be removed e.g. like this
#' # looking for dates of creation and then removing all objects
#' # from specific date
#' 
#' obj2rm <- searchInLocalRepo( tag = list(dateFrom = Sys.Date(), dateTo = Sys.Date()), 
#'            dir = exampleDir )
#' sapply(obj2rm, rmFromRepo, dir = exampleDir)
#' # aboves example removed all objects from Today
#' 
#' # one can also remove objects from only specific class
#' modelMd5hash  <- saveToRepo(model, dir=exampleDir)
#' model2Md5hash  <- saveToRepo(model2, dir=exampleDir)
#' model3Md5hash  <- saveToRepo(model3, dir=exampleDir)
#' objMd5hash <- searchInLocalRepo("class:lm", dir = exampleDir)
#' sapply(objMd5hash, rmFromRepo, dir = exampleDir)
#' 
#' 
#' # once can remove object specifying only its md5hash abbreviation
#' fannyxMd5hash <- saveToRepo(fannyx, dir=exampleDir)        
#' # "01785982a662038f720aa85e688f2082"
#' # so example abbreviation might be : "0178598"
#' rmFromRepo("0178598", dir = exampleDir)
#' 
#' 
#' # removing all files generated to this function's examples
#' x <- list.files( paste0( exampleDir, "/gallery/" ) )
#' sapply( x , function(x ){
#'      file.remove( paste0( exampleDir, "/gallery/", x ) )
#'    })
#' file.remove( paste0( exampleDir, "/backpack.db" ) )
#' file.remove( paste0( exampleDir, "/gallery" ) )
#' 
#' @family archivist
#' @rdname rmFromRepo
#' @export
rmFromRepo <- function( md5hash, dir ){
  stopifnot( is.character( c( dir, md5hash ) ) )
  # stopifnot( is.logical( c( removeMiniature, removeData ) ) )
  # TODO
  
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
  
  
  # creates connection and driver
  sqlite <- dbDriver( "SQLite" )
  conn <- dbConnect( sqlite, paste0( dir, "backpack.db" ) )
  # not sure if this will work when abbr mode find more than 1 md5hash  
  #   # send deletes
  #   dbGetQuery( conn,
  #               paste0( "DELETE FROM artifact WHERE ",
  #                       "md5hash = '", md5hash, "'" ) )
  #   dbGetQuery( conn,
  #               paste0( "DELETE FROM tag WHERE ",
  #                       "artifact = '", md5hash, "'" ) )
  
  # thinks this will work when abbr mode find more than 1 md5hash
  # send deletes
  sapply( md5hash, function(x){
    dbGetQuery( conn,
                paste0( "DELETE FROM artifact WHERE ",
                        "md5hash = '", x, "'" ) )} )
  sapply( md5hash, function(x){
    dbGetQuery( conn,
                paste0( "DELETE FROM tag WHERE ",
                        "artifact = '", x, "'" ) )} )
  
  # deletes connection and driver
  dbDisconnect( conn )
  dbUnloadDriver( sqlite ) 
  
  # remove files from gallery folder
  if ( file.exists( paste0( dir, "gallery/", md5hash, ".rda" ) ) )
    file.remove( paste0( dir, "gallery/", md5hash, ".rda" ) )
  
  if ( file.exists( paste0( dir, "gallery/", md5hash, ".png" ) ) )
    file.remove( paste0( dir, "gallery/", md5hash, ".png" ) )
  
  if ( file.exists( paste0( dir, "gallery/", md5hash, ".txt" ) ) )
    file.remove( paste0( dir, "gallery/", md5hash, ".txt" ) )
  
}
