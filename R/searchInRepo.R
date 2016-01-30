##    archivist package for R
##
#' @title Search for an Artifact in the Repository Using Tags
#'
#' @description
#' \code{searchInRepo} searches for an artifact in the \link{Repository} using it's \link{Tags}.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' 
#' @details
#' \code{searchInRepo} searches for an artifact in the Repository using it's \code{Tag} 
#' (e.g., \code{name}, \code{class} or \code{archiving date}). \code{Tags} are used in a \code{pattern}
#' parameter. For various artifact classes different \code{Tags} can be searched for. 
#' See \link{Tags}. If a \code{pattern} is a list of length 2 then \code{md5hashes} of all 
#' artifacts created from date \code{dateFrom} to date \code{dateTo} are returned. The date 
#' should be formatted according to the YYYY-MM-DD format, e.g., \code{"2014-07-31"}.
#' 
#' \code{Tags}, used in a \code{pattern} parameter, should be determined according to the 
#' format: \code{"TagKey:TagValue"} - see examples.
#'   
#' @return
#' \code{searchInRepo} returns character vector of \code{md5hashes} of artifacts that were searched for.
#' Those are hashes assigned to artifacts while they were saved in the Repository
#' by the \link{saveToRepo} function. If the artifact
#' is not in the Repository then a logical value \code{FALSE} is returned.
#' 
#' 
#' @param pattern If \code{fixed = TRUE}: a character denoting a \code{Tag} which is to be searched for in the Repository.
#' It is also possible to specify \code{pattern} as a list of 
#' length 2 with \code{dateFrom} and \code{dateTo}; see details. If \code{fixed = FALSE}: a regular expression 
#' specifying the beginning of a \code{Tag}, which will be used to search for artifacts.
#' 
#' @param patterns A character vector of \code{patterns}(see \code{pattern}) to find artifacts in the Repository.
#' If \code{intersect = TRUE} then artifacts that 
#' match all conditions are returned. If \code{intersect = FALSE} then artifacts that match any condition
#' are returned.
#' 
#' @param intersect A logical value. See \code{patterns} for more details.
#' 
#' @param repoDir A character denoting an existing directory in which artifacts will be searched for.
#' If it is set to \code{NULL} (by default), it will use the \code{repoDir} specified in \link{setLocalRepo}.
#' 
#' @param repo While working with the Github repository. A character containing a name of the Github repository on which the Repository is stored.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param user While working with the Github repository. A character containing a name of the Github user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}.
#'
#' @param branch While working with the Github repository. A character containing a name of 
#' the Github Repository's branch on which the Repository is stored. Default \code{branch} is \code{master}.
#' 
#' @param fixed A logical value specifying how \code{artifacts} should be searched for.
#' If \code{fixed = TRUE} (default) then artifacts are searched for by using \code{pattern = "Tag"} argument.
#' If \code{fixed = FALSE} then artifacts are searched for by using \code{pattern = "regular expression"} argument.
#' The latter is wider and more flexible method, e.g.,
#' using \code{pattern = "name", fixed = FALSE} arguments enables to search for all artifacts in the \code{Repository}.
#' 
#' @param repoDirGit While working with the Github repository. A character containing a name of a directory on the Github repository 
#' on which the Repository is stored. If the Repository is stored in the main folder of the Github repository, this should be set 
#' to \code{repoDirGit = FALSE} as default.
#' 
#' @param realDBname A logical value. Should not be changed by user. It is a technical parameter.
#'
#' @note
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in the Github mode then global parameters
#' set in \link{setGithubRepo} function are used.
#' 
#' @author
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#' # objects preparation
#' 
#'  # data.frame object
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
#'   # creating example Repository - on which examples will work
#'   
#'   exampleRepoDir <- tempfile()
#'   createEmptyRepo(repoDir = exampleRepoDir)
#'   saveToRepo(myplot123, repoDir=exampleRepoDir)
#'   saveToRepo(iris, repoDir=exampleRepoDir)
#'   saveToRepo(model, repoDir=exampleRepoDir)
#'   saveToRepo(agn1, repoDir=exampleRepoDir)
#'   saveToRepo(fannyx, repoDir=exampleRepoDir)
#'   
#'   # let's see how the Repository looks like: show
#'   
#'   showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#'   showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#'   
#'   # let's see how the Repository looks like: summary
#'   
#'   summaryLocalRepo( exampleRepoDir )
#'   
#'   
#'   # search examples
#'   
#'   # Tag search, fixed version
#'   searchInLocalRepo( "class:ggplot", repoDir = exampleRepoDir )
#'   searchInLocalRepo( "name:myplot123", repoDir = exampleRepoDir )
#'   searchInLocalRepo( "varname:Sepal.Width", repoDir = exampleRepoDir )
#'   searchInLocalRepo( "class:lm", repoDir = exampleRepoDir )
#'   searchInLocalRepo( "coefname:Petal.Length", repoDir = exampleRepoDir )
#'   searchInLocalRepo( "ac:0.797755535467609", repoDir = exampleRepoDir )
#'   
#'   # Tag search, regex version
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
#'   # Tag search, fixed version
#'   searchInGithubRepo( "varname:Sepal.Width", user="pbiecek", repo="archivist" )
#'   searchInGithubRepo( "class:lm", user="pbiecek", repo="archivist", branch="master" )
#'   searchInGithubRepo( "name:myplot123", user="pbiecek", repo="archivist" )
#'   
#'   # Tag search, regex version
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
#'   # Remeber to set dateTo parameter to actual date because sometimes we update datasets.
#'   searchInGithubRepo( pattern = list( dateFrom = "2015-10-01", dateTo = "2015-11-30" ), 
#'                       user="pbiecek", repo="archivist", branch="master" )
#'   
#'   
#'   # objects from Today
#'   searchInLocalRepo( pattern = list( dateFrom = Sys.Date(), dateTo = Sys.Date() ), 
#'                      repoDir = exampleRepoDir )
#'   
#'   # removing an example Repository
#'   
#'   deleteRepo( exampleRepoDir, TRUE)
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
  stopifnot( ( is.character( repoDir ) & length( repoDir ) == 1 ) | is.null( repoDir ) )
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

  stopifnot( is.character( branch ), is.logical( fixed ), length( branch ) == 1 )
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
  on.exit(file.remove( Temp ))
  m <- multiSearchInLocalRepo( patterns, repoDir = Temp, fixed=fixed,
                               intersect=intersect, realDBname = FALSE)
  return( m )
}

#' @rdname searchInRepo
#' @export
multiSearchInRepo <- function(patterns, fixed = TRUE, intersect = TRUE,
                              repoDir = NULL, realDBname = TRUE,
                              repo = NULL, user = NULL, branch = "master", repoDirGit = FALSE ){
  
  .Deprecated("multiSearchInRepo", msg = "The multiSearchInRepo is set as deprecated. Try to use direct calls to multiSearchInLocalRepo/multiSearchInGitRepo")
  
  local <- (!is.null(aoptions("repoDir")) && is.null(repo)) || (!is.null(repoDir) && is.null(repo))
  GitHub <- (is.null(repoDir) && !is.null(aoptions("repo"))) || (is.null(repoDir) && !is.null(repo))
  if (local){
    multiSearchInLocalRepo( patterns = patterns, repoDir = repoDir, fixed = fixed,
                            intersect = intersect, realDBname = realDBname )
  }  else if (GitHub) {
    multiSearchInGithubRepo( patterns = patterns, repo = repo, user = user, branch = branch,
                             repoDirGit = repoDirGit, fixed = fixed, intersect = intersect )
  } else {
    stop("repo and repoDir parameters can not be used simultaneously.")
  }
}