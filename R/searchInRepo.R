##    archivist package for R
##
#' @title Search for an Artifact in a Repository Using Tags
#'
#' @description
#' \code{searchInRepo} searches for an artifact in a \link{Repository} using it's \link{Tags}.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' 
#' @details
#' \code{searchInRepo} searches for an artifact in a Repository using it's \code{Tag} 
#' (e.g., \code{name}, \code{class} or \code{archiving date}). \code{Tags} are submitted in a \code{pattern}
#' argument. For various artifact classes different \code{Tags} can be searched for. 
#' See \link{Tags}. If a \code{pattern} is a list of length 2, \code{md5hashes} of all 
#' artifacts created from date \code{dateFrom} to data \code{dateTo} are returned. The date 
#' should be formatted according to the YYYY-MM-DD format, e.g., \code{"2014-07-31"}.
#' 
#' \code{Tags}, submitted in a \code{pattern} argument, should be given according to the 
#' format: \code{"TagType:TagTypeValue"} - see examples.
#'   
#' @return
#' \code{searchInRepo} returns a \code{md5hash} character, which is a hash assigned to the artifact when
#' saving it to the Repository by using the \link{saveToRepo} function. If the artifact
#' is not in the Repository a logical value \code{FALSE} is returned.
#' 
#' @param pattern If \code{fixed = TRUE}: a character denoting a \link{Tags} to be searched for in the Repository. 
#' It is also possible to specify \code{pattern} as a list of 
#' length 2 with \code{dataFrom} and \code{dataTo}; see details. If \code{fixed = FALSE}: A regular expression 
#' specifying the beginning of a \link{Tags}, which will be used to search artifacts for.
#' 
#' @param patterns A vector of queries to repository. If \code{intersect = TRUE} only artifacts that 
#' match all conditions are returned. If \code{intersect = FALSE} then artifacts that match any contition
#' are returned.
#' 
#' @param intersect A logical value. See \code{patterns} for more details.
#' 
#' @param repoDir A character denoting an existing directory in which artifacts will be searched.
#' If set to \code{NULL} (by default), uses the \code{repoDir} specified in \link{setLocalRepo}.
#' 
#' @param repo Only if working with a Github repository. A character containing a name of a Github repository on which the Repository is archived.
#' By default set to \code{NULL} - see \code{Note}.
#' @param user Only if working with a Github repository. A character containing a name of a Github user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}.
#' @param branch Only if working with a Github repository. A character containing a name of 
#' Github repository's branch in which Repository is archived. Default \code{branch} is \code{master}.
#' 
#' @param fixed A logical value specifying how \code{artifacts} should be searched for.
#' If \code{fixed = TRUE} (default) then artifacts are searched exactly to the corresponding \code{pattern} parameter. If
#' \code{fixed = FALSE} then artifacts are searched using \code{pattern} paremeter as a regular expression - that method is wider and more flexible 
#' and, i.e., enables to search for all artifacts in the \code{Repository}, using \code{pattern = "name", fixed = FALSE}.
#' 
#' @param repoDirGit Only if working with a Github repository. A character containing a name of a directory on Github repository 
#' on which the Repository is stored. If the Repository is stored in main folder on Github repository, this should be set 
#' to \code{repoDirGit = FALSE} as default.
#' 
#' @param realDBname A logical value. Should not be changed by user. It is a technical parameter.
#'
#' @note
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in Github mode then global parameters
#' set in \link{setGithubRepo} function are used.
#' 
#' @author
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' # objects preparation
#' \dontrun{
#'   # data.frame object
#'   data(iris)
#'   
#'  # ggplot/gg object
#'   library(ggplot2)
#'   df <- data.frame(gp = factor(rep(letters[1:3], each = 10)),y = rnorm(30))
#'   library(plyr)
#'   ds <- ddply(df, .(gp), summarise, mean = mean(y), sd = sd(y))
#'   myplot123 <- ggplot(df, aes(x = gp, y = y)) +
#'     geom_point() +  geom_point(data = ds, aes(y = mean),
#'                                colour = 'red', size = 3)
#'   
#'   # lm object                
#'   model <- lm(Sepal.Length~ Sepal.Width + Petal.Length + Petal.Width, data= iris)
#'   
#'   # agnes (twins) object 
#'   library(cluster)
#'   data(votes.repub)
#'   agn1 <- agnes(votes.repub, metric = "manhattan", stand = TRUE)
#'   
#'   # fanny (partition) object
#'   x <- rbind(cbind(rnorm(10, 0, 0.5), rnorm(10, 0, 0.5)),
#'              cbind(rnorm(15, 5, 0.5), rnorm(15, 5, 0.5)),
#'              cbind(rnorm( 3,3.2,0.5), rnorm( 3,3.2,0.5)))
#'   fannyx <- fanny(x, 2)
#'   
#'   # creating example Repository - that examples will work
#'   
#'   exampleRepoDir <- tempdir()
#'   createEmptyRepo(repoDir = exampleRepoDir)
#'   saveToRepo(myplot123, repoDir=exampleRepoDir)
#'   saveToRepo(iris, repoDir=exampleRepoDir)
#'   saveToRepo(model, repoDir=exampleRepoDir)
#'   saveToRepo(agn1, repoDir=exampleRepoDir)
#'   saveToRepo(fannyx, repoDir=exampleRepoDir)
#'   
#'   # let's see how the Repository look like: show
#'   
#'   showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#'   showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#'   
#'   # let's see how the Repository look like: summary
#'   
#'   summaryLocalRepo( exampleRepoDir )
#'   
#'   
#'   # search examples
#'   
#'   # tag search, fixed version
#'   searchInLocalRepo( "class:ggplot", repoDir = exampleRepoDir )
#'   searchInLocalRepo( "name:myplot123", repoDir = exampleRepoDir )
#'   searchInLocalRepo( "varname:Sepal.Width", repoDir = exampleRepoDir )
#'   searchInLocalRepo( "class:lm", repoDir = exampleRepoDir )
#'   searchInLocalRepo( "coefname:Petal.Length", repoDir = exampleRepoDir )
#'   searchInLocalRepo( "ac:0.797755535467609", repoDir = exampleRepoDir )
#'   
#'   # tag search, regex version
#'   
#'   searchInLocalRepo( "class", repoDir = exampleRepoDir, fixed = FALSE )
#'   searchInLocalRepo( "name", repoDir = exampleRepoDir, fixed = FALSE )
#'   
#'   # Github version
#'   # check the state of the Repository
#'   summaryGithubRepo( user="pbiecek", repo="archivist" )
#'   showGithubRepo( user="pbiecek", repo="archivist" )
#'   showGithubRepo( user="pbiecek", repo="archivist", method = "tags" )
#'   
#'   # tag search, fixed version
#'   searchInGithubRepo( "varname:Sepal.Width", user="pbiecek", repo="archivist" )
#'   searchInGithubRepo( "class:lm", user="pbiecek", repo="archivist", branch="master" )
#'   searchInGithubRepo( "name:myplot123", user="pbiecek", repo="archivist" )
#'   
#'   # tag search, regex version
#'   searchInGithubRepo( "class", user="pbiecek", repo="archivist",  fixed = FALSE )
#'   searchInGithubRepo( "name", user="pbiecek", repo="archivist", fixed = FALSE )
#'   
#'  
#'   # date search
#'   
#'   # objects archivised between 2 different days
#'   searchInLocalRepo( pattern = list( dateFrom = Sys.Date()-1, dateTo = Sys.Date()+1), 
#'                      repoDir = exampleRepoDir )
#'   
#'   # also on Github
#'   
#'   searchInGithubRepo( pattern = list( dateFrom = "2014-09-01", dateTo = "2014-09-30" ), 
#'                       user="pbiecek", repo="archivist", branch="master" )
#'   
#'   
#'   # objects from Today
#'   searchInLocalRepo( pattern = list( dateFrom=Sys.Date(), dateTo=Sys.Date() ), 
#'                      repoDir = exampleRepoDir )
#'   
#'   # removing an example Repository
#'   
#'   deleteRepo( exampleRepoDir )
#'   
#'   rm( exampleRepoDir )
#'   
#'   # many archivist-like Repositories on one Github repository
#'   
#'   searchInGithubRepo( pattern = "name", user="MarcinKosinski", repo="Museum", 
#'   branch="master", repoDirGit="ex1", fixed = FALSE )
#'
#'   searchInGithubRepo( pattern = "name", user="MarcinKosinski", repo="Museum", 
#'                    branch="master", repoDirGit="ex2", fixed = FALSE )
#'  
#'  # multi versions
#'  multiSearchInGithubRepo( patterns=c("varname:Sepal.Width", "class:lm", "name:myplot123"), 
#'                          user="pbiecek", repo="archivist", intersect = FALSE )                                    
#'   
#' }
#' @family archivist
#' @rdname searchInRepo
#' @export
searchInLocalRepo <- function( pattern, repoDir = NULL, fixed = TRUE, realDBname = TRUE ){
  stopifnot( is.character( repoDir ) | is.null( repoDir ) )
  stopifnot( is.logical( fixed ) )
  stopifnot( is.character( pattern ) | is.list( pattern ) ) 
  stopifnot( length( pattern ) == 1 | length( pattern ) == 2 )
  
  # when infoRepo uses searchLocal, it come with realDBname = FALSE
  if ( realDBname ){ 
    repoDir <- checkDirectory( repoDir )}  
  
  # extracts md5hash
  if ( fixed ){
   if ( length( pattern ) == 1 ){
     md5hashES <- unique( executeSingleQuery( dir = repoDir, realDBname = realDBname,
                              paste0( "SELECT DISTINCT artifact FROM tag WHERE tag = ",
                                      "'", pattern, "'" ) ) )
                                  # when infoRepo uses searchLocal, it come with realDBname = FALSE
   }else{
     ## length pattern == 2
     md5hashES <- unique( executeSingleQuery( dir = repoDir, realDBname = realDBname,
                              paste0( "SELECT DISTINCT artifact FROM tag WHERE createdDate >",
                                      "'", as.Date(pattern[[1]])-1, "'", " AND createdDate <",
                                      "'", as.Date(pattern[[2]])+1, "'") ) ) }
                                  # when infoRepo uses searchLocal, it come with realDBname = FALSE
  }else{
    # fixed = FALSE
    md5hashES <- unique( executeSingleQuery( dir = repoDir, realDBname = realDBname,
                                             paste0( "SELECT DISTINCT artifact FROM tag WHERE tag LIKE ",
                                                     "'", pattern, "%'" ) ) )
  }
  return( as.character( md5hashES[, 1] ) ) 
}

#' @rdname searchInRepo
#' @export
searchInGithubRepo <- function( pattern, repo = NULL, user = NULL, branch = "master", repoDirGit = FALSE,
                                fixed = TRUE ){

  stopifnot( is.character( branch ), is.logical( fixed ) )
  stopifnot( is.character( pattern ) | is.list( pattern ) )
  stopifnot( length( pattern ) == 1 | length( pattern ) == 2 )

  GithubCheck( repo, user, repoDirGit ) # implemented in setRepo.R
  
  # first download database
  Temp <- downloadDB( repo, user, branch, repoDirGit )

  # extracts md5hash
  if ( fixed ){
   if ( length( pattern ) == 1 ){
     md5hashES <- unique( executeSingleQuery( dir = Temp, realDBname = FALSE,
                              paste0( "SELECT artifact FROM tag WHERE tag = ",
                                      "'", pattern, "'" ) ) )
   }else{
     # length pattern == 2
     md5hashES <- unique( executeSingleQuery( dir = Temp, realDBname = FALSE,
                              paste0( "SELECT artifact FROM tag WHERE createdDate >",
                                      "'", as.Date(pattern[[1]])-1, "'", " AND createdDate <",
                                      "'", as.Date(pattern[[2]])+1, "'") ) ) }
  }else{
    # fixed FALSE
    md5hashES <- unique( executeSingleQuery( dir = Temp, realDBname = FALSE,
                                             paste0( "SELECT DISTINCT artifact FROM tag WHERE tag LIKE ",
                                                     "'", pattern, "%'" ) ) )
  }
  file.remove( Temp )
  return( as.character( md5hashES[, 1] ) ) 
}

#' @rdname searchInRepo
#' @export
multiSearchInLocalRepo <- function( patterns, repoDir = NULL, fixed = TRUE, intersect = TRUE, realDBname = TRUE ){
  stopifnot( is.logical( intersect ) )      
             
  md5hs <- lapply(patterns, function(pattern) unique(searchInLocalRepo(pattern, repoDir=repoDir, fixed=fixed, realDBname = realDBname) ))
  if (intersect) {
    return(names(which(table(unlist(md5hs)) == length(md5hs))))
  } 
  # union
  unique(unlist(md5hs))
}



#' @rdname searchInRepo
#' @export
multiSearchInGithubRepo <- function( patterns, repo = NULL, user = NULL, 
                                     branch = "master", repoDirGit = FALSE, 
                                     fixed = TRUE, intersect = TRUE ){
  stopifnot( is.logical(  intersect ) )

  GithubCheck( repo, user, repoDirGit ) # implemented in setRepo.R
  
  Temp <- downloadDB( repo, user, branch, repoDirGit )
  m <- multiSearchInLocalRepo( patterns, repoDir = Temp, fixed=fixed,
                               intersect=intersect, realDBname = FALSE)
  file.remove( Temp )
  return( m )
}

