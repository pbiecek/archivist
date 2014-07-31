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
#' objects created from date \code{dataFrom} to data \code{dataTo} are returned. The date 
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
#' # not work
#' searchInLocalRepo( "class:ggplot", dir = getwd() )
#' searchInLocalRepo( "name:prettyPlot", dir = "/home/folder/here" )
#' searchInGithubRepo( "name:myLMmodel", user="USERNAME", repo="REPO" )
#' searchInGithubRepo( "myLMmodel:call", user="USERNAME", repo="REPO" )
#' searchInLocalRepo( tag = list( dataFrom = "2005-05-27", dataTo = "2005-07-07"), 
#' dir = demoDir)
#' @family archivist
#' @rdname searchInRepo
#' @export
searchInLocalRepo <- function( tag, dir ){
  stopifnot( is.character( c( tag, dir ) ) )
  
  # check if dir has "/" at the end and add it if not
  if ( regexpr( pattern = ".$", text = dir ) != "/" ){
    dir <- paste0(  dir, "/"  )
  }
  
  # creates connection and driver
  dirBase <- paste0( dir, "backpack.db")
  sqlite <- dbDriver( "SQLite" )
  conn <- dbConnect( sqlite, dirBase )
  
  #if ( regexpr( pattern = ".{4}" , text = tag) == "date" ){
  #  
  #}       #NOT WORKS FOR DATES YET
  
  # extracts md5hash
  if ( length( tag ) == 1 ){
    md5hash <- dbGetQuery( conn,
                         paste0( "SELECT artifact FROM tag WHERE tag = ",
                                "'", tag, "'" ) )
  }
  if ( length( tag ) == 2 ){
    #### TO BE DONE : CREATE VECTOR WITH DATES (FROM, FROM+1,..., TO-1, TO)
    #dates <- 
    md5hash <- sapply(dates, function(x){
      dbGetQuery(conn, paste0( "SELECT artifact FROM tag WHERE createdDate = ",
                                   "'", x, "'" ) )} )
  }
  #}       #NOT WORKS FOR DATES YET
      
      
  # deletes connection and driver
  dbDisconnect( conn )
  dbUnloadDriver( sqlite ) 
  
  return( md5hash )
  
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