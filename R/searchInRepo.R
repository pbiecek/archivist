##    archivist package for R
##
#' @title Search for an Object in a Repository Using \code{Tags}
#'
#' @description
#' \code{searchInRepo} searches for an object in a \link{Repository} using it's \link{Tags}.
#' 
#' 
#' @details
#' \code{searchInRepo} searches for an object in a Repository using it's \code{Tag} 
#' (e.g., \code{name}, \code{class} or \code{archiving date}).
#' For various object classes different \code{Tags} can be searched for. 
#' See \link{Tags}. If a \code{Tag} is a list of length 2, \code{md5hashes} of all 
#' objects created from date \code{dateFrom} to data \code{dateTo} are returned. The date 
#' should be formatted according to the YYYY-MM-DD format, e.g., \code{"2014-07-31"}.
#' 
#' \code{Tags} should be given according to the format: \code{"TagType:TagTypeValue"} - see examples.
#'   
#' @return
#' \code{searchInRepo} returns a \code{md5hash} character, which is a hash assigned to the object when
#' saving it to the Repository by using the \link{saveToRepo} function. If the object
#' is not in the Repository a logical value \code{FALSE} is returned.
#' 
#' @param tag A character denoting a Tag to be searched for in the Repository. It is also possible to specify \code{tag} as a list of length 2 with \code{dataFrom} and \code{dataTo}; see details.
#' 
#' @param dir A character denoting an existing directory in which objects will be searched.
#' 
#' @param repo Only if working with a Github repository. A character containing a name of a Github repository on which the Repository is archived.
#' 
#' @param user Only if working with a Github repository. A character containing a name of a Github user on whose account the \code{repo} is created.
#' 
#' @param branch Only if working with a Github repository. A character containing a name of 
#' Github repository's branch in which Repository is archived. Default \code{branch} is \code{master}.
#'
#' @author
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
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
#' # creating example Repository - that examples will work
#' 
#' exampleDir <- tempdir()
#' createEmptyRepo(dir = exampleDir)
#' saveToRepo(myplot123, dir=exampleDir)
#' saveToRepo(iris, dir=exampleDir)
#' saveToRepo(model, dir=exampleDir)
#' saveToRepo(agn1, dir=exampleDir)
#' saveToRepo(fannyx, dir=exampleDir)
#' 
#' # let's see how the Repository look like: summary
#' 
#' summaryLocalRepo(method = "md5hashes", dir = exampleDir)
#' summaryLocalRepo(method = "tags", dir = exampleDir)
#'  
#' # search examples
#' 
#' # tag search
#' searchInLocalRepo( "class:ggplot", dir = exampleDir )
#' searchInLocalRepo( "name:myplot123", dir = exampleDir )
#' searchInLocalRepo( "varname:Sepal.Width", dir = exampleDir )
#' searchInLocalRepo( "class:lm", dir = exampleDir )
#' searchInLocalRepo( "coefname:Petal.Length", dir = exampleDir )
#' searchInLocalRepo( "ac:07977555", dir = exampleDir )
#' 
#' searchInGithubRepo( "varname:Sepal.Width", user="pbiecek", repo="archivist" )
#' searchInGithubRepo( "myLMmodel:call", user="pbiecek", repo="archivist", branch="master" )
#' searchInGithubRepo( "date:2014-07-31 23:43:34", user="pbiecek", repo="archivist" )
#' 
#' # date search
#' 
#' # objects archivised between 2 different days
#' searchInLocalRepo( tag = list( dateFrom = Sys.Date()-1, dateTo = Sys.Date()+1), 
#' dir = exampleDir)
#' 
#' # objects from Today
#' searchInLocalRepo( tag = list(dateFrom=Sys.Date(), dateTo=Sys.Date()), 
#' dir = exampleDir)
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
#' @rdname searchInRepo
#' @export
searchInLocalRepo <- function( tag, dir ){
  stopifnot( is.character( dir ) )
  stopifnot( is.character( tag ) | is.list( tag ) )
  
  # check if dir has "/" at the end and add it if not
  if ( regexpr( pattern = ".$", text = dir ) != "/" ){
    dir <- paste0(  dir, "/"  )
  }
  
  # creates connection and driver
  dirBase <- paste0( dir, "backpack.db")
  sqlite <- dbDriver( "SQLite" )
  conn <- dbConnect( sqlite, dirBase )
  
  # extracts md5hash
  if ( length( tag ) == 1 ){
    md5hashES <- dbGetQuery( conn,
                             paste0( "SELECT artifact FROM tag WHERE tag = ",
                                     "'", tag, "'" ) )
  }
  if ( length( tag ) == 2 ){
    md5hashES <- dbGetQuery( conn,
                             paste0( "SELECT artifact FROM tag WHERE createdDate >",
                                     "'", as.Date(tag[[1]])-1, "'", " AND createdDate <",
                                     "'", as.Date(tag[[2]])+1, "'"))
  }
  
  
  # deletes connection and driver
  dbDisconnect( conn )
  dbUnloadDriver( sqlite ) 
  
  return( as.character( md5hashES[, 1] ) ) 
  
}

#' @rdname searchInRepo
#' @export
searchInGithubRepo <- function( tag, repo, user, branch = "master" ){
  stopifnot( is.character( c( tag, repo, user, branch ) ) )
  
#   # download database
#   library(RCurl)
#   options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
#   tmpDB <- getBinaryURL( paste0( "https://raw.githubusercontent.com/", user, "/", repo, 
#                         "/", branch, "/backpack.db") )
#   tfS <- tempfile()
#   writeBin( tmpDB, tfS )
#   file.rename(from = tfS , to= "backpack.db")
#   tfS <- sub( x = tfS, pattern ="\\\\file.+", replacement="")
#   
#   # perform local search on downloaded database
#   md5hash <- searchInLocalRepo( tag = tag, dir = tfS )
#   
#     # when tags are collected, delete downloaded database
#   file.remove( paste0( tfS, "\\backpack.db" ) )
#   tfS <- NULL  
  return( md5hash )
}