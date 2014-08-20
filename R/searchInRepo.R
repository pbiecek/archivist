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
#' (e.g., \code{name}, \code{class} or \code{archiving date}). \code{Tags} are submitted in a \code{pattern}
#' argument. For various object classes different \code{Tags} can be searched for. 
#' See \link{Tags}. If a \code{pattern} is a list of length 2, \code{md5hashes} of all 
#' objects created from date \code{dateFrom} to data \code{dateTo} are returned. The date 
#' should be formatted according to the YYYY-MM-DD format, e.g., \code{"2014-07-31"}.
#' 
#' \code{Tags}, submitted in a \code{pattern} argument, should be given according to the format: \code{"TagType:TagTypeValue"} - see examples.
#'   
#' @return
#' \code{searchInRepo} returns a \code{md5hash} character, which is a hash assigned to the object when
#' saving it to the Repository by using the \link{saveToRepo} function. If the object
#' is not in the Repository a logical value \code{FALSE} is returned.
#' 
#' @param pattern If \code{fixed = TRUE}: a character denoting a Tag to be searched for in the Repository. It is also possible to specify \code{pattern} as a list of 
#' length 2 with \code{dataFrom} and \code{dataTo}; see details. If \code{fixed = FALSE}: A regular expression specifying the beginning of a tag, 
#' which will be used to search objects for.
#' 
#' @param repoDir A character denoting an existing directory in which objects will be searched.
#' 
#' @param repo Only if working with a Github repository. A character containing a name of a Github repository on which the Repository is archived.
#' 
#' @param user Only if working with a Github repository. A character containing a name of a Github user on whose account the \code{repo} is created.
#' 
#' @param branch Only if working with a Github repository. A character containing a name of 
#' Github repository's branch in which Repository is archived. Default \code{branch} is \code{master}.
#' 
#' @param fixed A logical value specifying how \code{objects} should be searched for.
#' If \code{fixed = TRUE} (default) then objects are searched exactly to the corresponding \code{pattern} parameter. If
#' \code{fixed = FALSE} then objects are searched using \code{pattern} paremeter as a regular expression - that method is wider and more flexible 
#' and, i.e., enables to search for all objects in the \code{Repository}, using \code{pattern = "name", fixed = FALSE}.
#' 
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
#' # creating example Repository - that examples will work
#' 
#' exampleRepoDir <- tempdir()
#' createEmptyRepo(repoDir = exampleRepoDir)
#' saveToRepo(myplot123, repoDir=exampleRepoDir)
#' saveToRepo(iris, repoDir=exampleRepoDir)
#' saveToRepo(model, repoDir=exampleRepoDir)
#' saveToRepo(agn1, repoDir=exampleRepoDir)
#' saveToRepo(fannyx, repoDir=exampleRepoDir)
#' 
#' # let's see how the Repository look like: summary
#' 
#' summaryLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' summaryLocalRepo(method = "tags", repoDir = exampleRepoDir)
#'  
#' # search examples
#' 
#' # tag search
#' searchInLocalRepo( "class:ggplot", repoDir = exampleRepoDir )
#' searchInLocalRepo( "name:myplot123", repoDir = exampleRepoDir )
#' searchInLocalRepo( "varname:Sepal.Width", repoDir = exampleRepoDir )
#' searchInLocalRepo( "class:lm", repoDir = exampleRepoDir )
#' searchInLocalRepo( "coefname:Petal.Length", repoDir = exampleRepoDir )
#' searchInLocalRepo( "ac:07977555", repoDir = exampleRepoDir )
#' 
#' # Github version
#' summaryGithubRepo( user="pbiecek", repo="archivist" )
#' searchInGithubRepo( "varname:Sepal.Width", user="pbiecek", repo="archivist" )
#' searchInGithubRepo( "class:lm", user="pbiecek", repo="archivist", branch="master" )
#' searchInGithubRepo( "date:2014-08-17 13:44:47", user="pbiecek", repo="archivist" )
#'
#' # date search
#' 
#' # objects archivised between 2 different days
#' searchInLocalRepo( pattern = list( dateFrom = Sys.Date()-1, dateTo = Sys.Date()+1), 
#' repoDir = exampleRepoDir )
#' 
#' # also on Github
#' 
#' searchInGithubRepo( pattern = list( dateFrom = "2014-08-16", dateTo = "2014-08-18" ), 
#' user="pbiecek", repo="archivist", branch="master" )
#' 
#' 
#' # objects from Today
#' searchInLocalRepo( pattern = list( dateFrom=Sys.Date(), dateTo=Sys.Date() ), 
#' repoDir = exampleRepoDir )
#' 
#' # removing all files generated to this function's examples
#' x <- list.files( paste0( exampleRepoDir, "/gallery/" ) )
#' sapply( x , function(x ){
#'      file.remove( paste0( exampleRepoDir, "/gallery/", x ) )
#'    })
#' file.remove( paste0( exampleRepoDir, "/backpack.db" ) )
#' 
#' rm( exampleRepoDir )
#' }
#' @family archivist
#' @rdname searchInRepo
#' @export
searchInLocalRepo <- function( pattern, repoDir, fixed = TRUE ){
  stopifnot( is.character( repoDir ), is.logical( fixed ) )
  stopifnot( is.character( pattern ) | is.list( pattern ) ) 
  stopifnot( length( pattern ) == 1 | length( pattern ) == 2 )
  
  repoDir <- checkDirectory( repoDir )  
  
  # extracts md5hash
  if ( fixed ){
   if ( length( pattern ) == 1 ){
     md5hashES <- unique( executeSingleQuery( dir = repoDir,
                              paste0( "SELECT DISTINCT artifact FROM tag WHERE tag = ",
                                      "'", pattern, "'" ) ) )
   }else{
     ## length pattern == 2
     md5hashES <- unique( executeSingleQuery( dir = repoDir,
                              paste0( "SELECT DISTINCT artifact FROM tag WHERE createdDate >",
                                      "'", as.Date(pattern[[1]])-1, "'", " AND createdDate <",
                                      "'", as.Date(pattern[[2]])+1, "'") ) ) }
  }else{
    # fixed = FALSE
    md5hashES <- unique( executeSingleQuery( dir = repoDir,
                                             paste0( "SELECT DISTINCT artifact FROM tag WHERE tag LIKE ",
                                                     "'", pattern, "%'" ) ) )
  }
  return( as.character( md5hashES[, 1] ) ) 
}

#' @rdname searchInRepo
#' @export
searchInGithubRepo <- function( pattern, repo, user, branch = "master", fixed = TRUE ){

  stopifnot( is.character( c( repo, user, branch ) ), is.logical( fixed ) )
  stopifnot( is.character( pattern ) | is.list( pattern ) )
  stopifnot( length( pattern ) == 1 | length( pattern ) == 2 )
  
  
  # first download database
  Temp <- downloadDB( repo, user, branch )

  # extracts md5hash
  if ( fixed ){
   if ( length( pattern ) == 1 ){
     md5hashES <- unique( executeSingleQuery( dir = Temp, paste = FALSE,
                              paste0( "SELECT artifact FROM tag WHERE tag = ",
                                      "'", pattern, "'" ) ) )
   }else{
     # length pattern == 2
     md5hashES <- unique( executeSingleQuery( dir = Temp, paste = FALSE,
                              paste0( "SELECT artifact FROM tag WHERE createdDate >",
                                      "'", as.Date(pattern[[1]])-1, "'", " AND createdDate <",
                                      "'", as.Date(pattern[[2]])+1, "'") ) ) }
  }else{
    # fixed FALSE
    md5hashES <- unique( executeSingleQuery( dir = Temp, paste = FALSE,
                                             paste0( "SELECT DISTINCT artifact FROM tag WHERE tag LIKE ",
                                                     "'", pattern, "%'" ) ) )
  }

  return( as.character( md5hashES[, 1] ) ) 
}
