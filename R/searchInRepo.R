##    archivist package for R
##
#' @title Search for an Object in a Repository using Tags
#'
#' @description
#' \code{searchInRepo} searches for an object in a \link{Repository} using it's \code{Tag}.
#' 
#' 
#' @details
#' \code{searchInRepo} searches for an object in a repository using it's \code{Tag}.
#' \code{Tags} can be an object's \code{name}, \code{class} or \code{archivisation date}. 
#' Furthermore, for various object's classes more different \code{Tags} can be searched. 
#' See \link{Tags}. If a \code{Tag} is a list of length 2, \code{md5hashes} of all 
#' objects created from date \code{dateFrom} to data \code{dateTo} are returned. The date 
#' should be formated e.g. \code{"2014-07-31"}.
#' 
#'   
#' @return
#' \code{searchInRepo} returns as value a \code{md5hash} which is an object's hash that was generated while
#' saving an object to the Repository in a moment a \link{saveToRepo} function was called. If the desired object
#' is not in a Repository a logical value \code{FALSE} is returned.
#' 
#' @param tag A character denoting a Tag to seek for or a list of length 2 with \code{dataFrom} and \code{dataTo} arguments. See details.
#' 
#' @param dir A character denoting an existing directory from which objects will be searched.
#' 
#' @param repo Only if working on Github Repository. A character string containing a name of Github Repository.
#' 
#' @param user Only if working on Github Repository. A character string containing a name of Github User.
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
#' saveToRepo(myplot123, dir=exampleDir)
#' saveToRepo(iris, dir=exampleDir)
#' saveToRepo(model, dir=exampleDir)
#' saveToRepo(agn1, dir=exampleDir)
#' saveToRepo(fannyx, dir=exampleDir)
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
#' searchInLocalRepo( paste0("diss:", agn1$diss), dir = exampleDir)
#' 
#' searchInGithubRepo( "varname:Sepal.Width", user="USERNAME", repo="REPO" )
#' searchInGithubRepo( "myLMmodel:call", user="USERNAME", repo="REPO" )
#' searchInGithubRepo( "date:2014-07-31 23:43:34", user="USERNAME", repo="REPO" )
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
#' file.remove( paste0( exampleDir, "/gallery" ) ) 
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
searchInGithubRepo <- function( tag, repo, user ){
  stopifnot( is.character( c( tag, repo, user ) ) )
  
  
  ## TO BE DONE - NOT FINISHED
  
  # not sure if it works
  # creates connection and driver
  urlBase <- paste0( "https://github.com/", user, repo, "/backpack.db")
  sqlite <- dbDriver( "SQLite" )
  conn <- dbConnect( sqlite, urlBase )
  
  # extracts md5hash
  md5hash <- dbGetQuery( conn,
              paste0( "SELECT artifact FROM tag WHERE tag = ",
                   "'", tag, "'" ) )
  # deletes connection and driver
  dbDisconnect( conn )
  dbUnloadDriver( sqlite ) 
  
  return( md5hash )
}