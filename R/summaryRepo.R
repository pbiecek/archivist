##    archivist package for R
##
#' @title View the Summary of the Repository
#'
#' @description
#' \code{summaryRepo} summarizes the current state of the \link{Repository}.
#' 
#' @details
#' \code{summaryRepo} summarizes the current state of a \link{Repository}. Recommended to use
#' \code{print( summaryRepo ) )}. See examples.
#' 
#' @param repoType A character containing a type of the remote repository. Currently it can be 'github' or 'bitbucket'.
#' 
#' @param repoDir A character denoting an existing directory of the Repository for which a summary will be returned.
#' 
#' @param repo While working with the Remote repository. A character containing a name of the Remote repository on which the Repository is stored.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param user While working with the Remote repository. A character containing a name of the Remote user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}.
#'
#' @param branch While working with the Remote repository. A character containing a name of 
#' the Remote Repository's branch on which the Repository is stored. Default \code{branch} is \code{master}.
#' 
#' @param subdir While working with the Remote repository. A character containing a name of a directory on the Remote repository 
#' on which the Repository is stored. If the Repository is stored in the main folder of the Remote repository, this should be set 
#' to \code{subdir = "/"} as default.
#'
#' @return An object of class \code{repository} which can be printed: \code{print(object)}.
#' 
#' @note If the same artifact was archived many times then it is counted as one artifact or database in \code{print(summaryRepo)}.
#' 
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in the Remote mode then global parameters
#' set in \link{setRemoteRepo} function are used.
#' @author 
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#' 
#' showLocalRepo(repoDir = system.file("graphGallery", package = "archivist"))
#' #
#' # Remote version
#' #
#'  
#' x <- summaryRemoteRepo( user="pbiecek", repo="archivist")
#' print( x )
#' 
#' # many archivist-like Repositories on one Remote repository
#'   
#' summaryRemoteRepo(user="MarcinKosinski", repo="Museum", 
#' branch="master", subdir="ex2" )
#' 
#' }
#' @family archivist
#' @rdname summaryRepo
#' @export
summaryLocalRepo <- function( repoDir = aoptions('repoDir') ){
  stopifnot( ( is.character( repoDir ) & length( repoDir ) == 1 ) | is.null( repoDir ) )
  
  repoDir <- checkDirectory( repoDir )
  summaryRepo( dir = repoDir)
  
}



#' @rdname summaryRepo
#' @export
summaryRemoteRepo <- function( repo = aoptions("repo"), user = aoptions("user"), branch = "master", 
                               subdir = aoptions("subdir"),  repoType = aoptions("repoType")){
  stopifnot( is.character( branch ), length( branch ) == 1 )

  RemoteRepoCheck( repo, user, branch, subdir, repoType) # implemented in setRepo.R
  
  # database is needed to be downloaded
  remoteHook <- getRemoteHook(repo=repo, user=user, branch=branch, subdir=subdir)
  Temp <- downloadDB( remoteHook )
  
  summaryRepo( dir = Temp )
  
}

summaryRepo <- function( dir ){
    # what classes types are there in the Repository
    classes <- executeSingleQuery( dir = dir ,
                  paste0( "SELECT DISTINCT tag FROM tag WHERE tag LIKE 'class%'" ) )
    classes <- as.character( apply( classes, 1, function(y) sub( x = y, pattern = "class:", replacement="") ) )
  
info <- list( artifactsNumber = NULL, dataSetsNumber = NULL, classesNumber = NULL, 
              savesPerDay = NULL, classesTypes = classes )
    
    # how many different objects are there in the Repository
    info$artifactsNumber <- length( searchInLocalRepo( pattern = "name", fixed = FALSE, 
                                                       repoDir = dir ) )
    
    # how many datasets are there in the Repository
    info$dataSetsNumber <- length( searchInLocalRepo( pattern = "relationWith", fixed = FALSE, 
                                                      repoDir = dir ) )


    # how many different objects classes are there in the Repository
    info$classesNumber <- sapply( classes, function(x){
                          length( searchInLocalRepo( pattern = paste0("class:", x), 
                                                  fixed = TRUE, repoDir = dir ) ) })
    # how many different objects were saved in different days
    days <- unique( as.Date( unlist( executeSingleQuery( dir = dir , 
                                paste0( "SELECT createdDate FROM tag" ) ) ) ) )
    info$savesPerDay <- sapply( days, function(x){
                                length( searchInLocalRepo( pattern = list( dateFrom = x, dateTo = x),
                                                   repoDir = dir ) ) } )
    names( info$savesPerDay ) <- days
    
  class( info ) <- "repository"
  
  return( info )
}

#' @export
print.repository <- function( x, ... ){
  
  if( x$artifactsNumber == 0 & x$dataSetsNumber == 0 ){
    cat( "Repository is empty." )
  } else {
  cat( "Number of archived artifacts in Repository: ", x$artifactsNumber, "\n")
  cat( "Number of archived datasets in Repository: ", x$dataSetsNumber, "\n") 
  if( x$artifactsNumber > 1 ){
    cat( "Number of various classes archived in Repository: \n ")
    classes <- data.frame( x$classesNumber )
    names( classes ) <- "Number"
    print( classes )
  }
  
  cat( "Saves per day in Repository: \n ")
  saves <- data.frame( x$savesPerDay )
  names( saves ) <- "Saves"
  print( saves )
  
  }
    
  invisible( x )
}

# #' @export
# plot.repository <- function( x, ... ){
#   barplot( x$savesPerDay, ... )
#   # invisible( x )
# }

