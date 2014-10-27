##
#' @title Create a zip Archive From an Existing Repository
#' 
#' @description
#' \code{zipLocalRepo} and \code{zipGithubRepo} create a zip archive from an existing \link{Repository}.
#' 
#' 
#' 
#' If the function does not work, it might be a reason of Rtools that are not installed. 
#' To solve this problem follow those \href{http://cran.r-project.org/web/packages/openxlsx/vignettes/Introduction.pdf}{Instructions.}
#' 
#' @note
#' If the function does not work, it might be a reason of Rtools that are not installed. 
#' To solve this problem follow those \href{http://cran.r-project.org/web/packages/openxlsx/vignettes/Introduction.pdf}{Instructions.}
#' 
#' 
#' @details
#' \code{zipLocalRepo} and \code{zipGithubRepo} create a zip archive from an existing \link{Repository}.
#' \code{zipLocalRepo} zips local \code{Repository}, \code{zipGithubRepo} zips \code{Repository} 
#' stored on Github.
#'
#' @param repoDir A character that specifies the directory of the Repository which
#' will be zipped.
#'
#' @param repo Only if working with a Github repository. A character containing a name of a Github repository on which the Repository to be zipped is archived.
#' 
#' @param user Only if working with a Github repository. A character containing a name of a Github user on whose account the \code{repo} is created.
#' 
#' @param branch Only if working with a Github repository. A character containing a name of 
#' Github repository's branch in which Repository to be zipped is archived. Default \code{branch} is \code{master}.
#' 
#' @param repoDirGit Only if working with a Github repository. A character containing a name of a directory on Github repository 
#' on which the Repository to be zipped is stored. If the Repository is stored in main folder on Github repository, this should be set 
#' to \code{repoDirGit = FALSE} as default.
#' 
#' @param repoTo A character that specifies the directory in which
#' will be created zip archive from \code{Repository} stored in \code{repoDir} or Github directory.
#' By default set to working directory (\code{getwd()})/
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
#' 
#'  
#' zipLocalRepo( exampleRepoDir )
#' 
#' deleteRepo( exampleRepoDir )
#' 
#' rm( exampleRepoDir )
#' 
#' # Github version
#' 
#' zipGithubRepo( user="MarcinKosinski", 
#' repo="Museum", branch="master", repoDirGit="ex1" )
#' 
#' zipGithubRepo( user="pbiecek", repo="archivist", repoTo = getwd( ) )
#' 
#' }
#' 
#' @family archivist
#' @rdname zipRepo
#' @export
zipLocalRepo <- function( repoDir, repoTo = getwd() ){
  stopifnot( is.character( repoDir ))
  
  repoDir <- checkDirectory( repoDir )
  repoTo <- checkDirectory( repoTo )

  files <- c( paste0( repoDir, "backpack.db"), 
              paste0( repoDir, "gallery/", list.files( paste0(repoDir, "gallery/") ) ) )
  zip( paste0( repoTo, "repository.zip"), files)

}

#' @family archivist
#' @rdname zipRepo
#' @export
zipGithubRepo <- function( repoTo = getwd(), user, repo, branch = "master", 
                           repoDirGit = FALSE){
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
  
  zip( paste0( repoTo, "repository.zip"), files)
  file.remove( Temp )
}
