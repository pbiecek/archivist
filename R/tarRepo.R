##
#' @title Create a Tar Archive From an Existing Repository
#' 
#' @description
#' \code{tarLocalRepo} and \code{tarGithubRepo} create a tar archive from an existing \link{Repository}.
#' 
#' @details
#' \code{tarLocalRepo} and \code{tarGithubRepo} create a tar archive from an existing \link{Repository}.
#' \code{tarLocalRepo} tars local \code{Repository}, \code{tarGithubRepo} tars \code{Repository} 
#' stored on Github.
#'
#' @param repoDir A character that specifies the directory of the Repository which
#' will be tarred.
#'
#' @param repo Only if working with a Github repository. A character containing a name of a Github repository on which the Repository to be tarred is archived.
#' 
#' @param user Only if working with a Github repository. A character containing a name of a Github user on whose account the \code{repo} is created.
#' 
#' @param branch Only if working with a Github repository. A character containing a name of 
#' Github repository's branch in which Repository to be tarred is archived. Default \code{branch} is \code{master}.
#' 
#' @param repoDirGit Only if working with a Github repository. A character containing a name of a directory on Github repository 
#' on which the Repository to be tarred is stored. If the Repository is stored in main folder on Github repository, this should be set 
#' to \code{repoDirGit = FALSE} as default.
#' 
#' @param repoTo Only if working with a Github repository. A characterthat specifies the directory in which
#' will be created tar archive from \code{Repository} stored on Github.
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
#' # Local version
#' 
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' saveToRepo( myplot123, repoDir=exampleRepoDir )
#' saveToRepo( iris, repoDir=exampleRepoDir )
#' saveToRepo( model, repoDir=exampleRepoDir )
#' 
#' tarLocalRepo( exampleRepoDir )
#' 
#' deleteRepo( exampleRepoDir )
#' 
#' rm( exampleRepoDir )
#' 
#' # Github version
#' 
#' tarGithubRepo( user="MarcinKosinski", 
#' repo="Museum", branch="master", repoDirGit="ex1" )
#' 
#' tarGithubRepo( user="pbiecek, repo="archivist, repoTo = getwd( ) )
#' 
#' }
#' 
#' @family archivist
#' @rdname tarRepo
#' @export
tarLocalRepo <- function( repoDir ){
  stopifnot( is.character( repoDir ))
  
  repoDir <- checkDirectory( repoDir )

  files <- c( paste0( repoDir, "backpack.db"), 
              paste0( repoDir, "gallery/", list.files( paste0(repoDir, "gallery/") ) ) )
  tar( paste0(repoDir, "repository.zip"), files)

}

#' @family archivist
#' @rdname tarRepo
#' @export
tarGithubRepo <- function( repoTo, user, repo, branch = "master", repoDirGit = FALSE){
  stopifnot( is.character( c( repoTo, repo, user, branch ) ) )
  stopifnot( is.logical( repoDirGit ) | is.character( repoDirGit ) )
  if( is.logical( repoDirGit ) ){
    if ( repoDirGit ){
      stop( "repoDirGit may be only FALSE or a character. See documentation." )
    }
  }
  
  repoTo <- checkDirectory( repoTo )
  # first download database
  Temp <- downloadDB( repo, user, branch, repoDirGit )
  
  Temp <- checkDirectory( Temp )

  files <- c( paste0( Temp, "backpack.db"), 
              paste0( Temp, "gallery/", list.files( paste0(repoTo, "gallery/") ) ) )
  
  tar( paste0( repoTo, "repository.tar"), files)
  file.remove( Temp )
}
