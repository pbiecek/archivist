##
#' @title Create a zip Archive From an Existing Repository
#' 
#' @description
#' \code{zipLocalRepo} and \code{zipGithubRepo} create a zip archive from an
#' existing \link{Repository}. \code{zipLocalRepo} zips local \code{Repository},
#' \code{zipGithubRepo} zips \code{Repository} stored on Github.
#' 
#' 
#' @note
#' The function might not work if \code{Rtools} are not installed.
#' To solve this problem follow these \href{http://cran.r-project.org/web/packages/openxlsx/vignettes/Introduction.pdf}{Instructions.}
#' 
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in Github mode then global parameters
#' set in \link{setGithubRepo} function are used.
#'
#' @param repoDir A character that specifies the directory of the Repository which
#' will be zipped. If set to \code{NULL} (by default), uses the \code{repoDir} specified in \link{setLocalRepo}.
#'
#' @param repo While working with the Github repository. A character containing
#' a name of the Github repository on which the Repository, which is to be zipped, is archived.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param user While working with the Github repository. A character containing
#' a name of the Github user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param branch While working with the Github repository. A character containing a name of the
#' Github repository's branch on which Repository, which is to be zipped, is archived.
#' Default \code{branch} is \code{master}.
#' 
#' @param repoDirGit While working with a Github repository. A character containing a name of
#' a directory on Github repository on which the Repository, which is to be zipped, is stored.
#' If the Repository is stored in the main folder on the Github repository, this should be set 
#' to FALSE as default.
#' 
#' @param repoTo A character that specifies the directory in which there
#' will be created zip archive from \code{Repository} stored in \code{repoDir} or Github directory.
#' By default set to working directory (\code{getwd()}).
#' 
#' @param zipname A character that specifies name of the zipped repository.
#' It is assumed that this file does not exist or does not contain backpack.db file.
#' An attempt to override will produce an error.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}, Przemyslaw Biecek
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
#' exampleRepoDir <- tempfile()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' saveToRepo( myplot123, repoDir=exampleRepoDir )
#' saveToRepo( iris, repoDir=exampleRepoDir )
#' saveToRepo( model, repoDir=exampleRepoDir )
#' 
#' 
#'  
#' zipLocalRepo( exampleRepoDir )
#' 
#' deleteRepo( exampleRepoDir, TRUE)
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
zipLocalRepo <- function( repoDir = NULL, repoTo = getwd() , zipname="repository.zip"){
  stopifnot( ( is.character( repoDir ) & length( repoDir ) == 1 ) | is.null( repoDir ) )
  stopifnot( is.character( repoTo ), length( repoTo ) == 1 )
  
#   repoTo <- checkDirectory2( repoTo )
  if (file.exists(file.path(repoTo, zipname))) {
    stop(paste0("The file ", file.path(repoTo, zipname), " allready exists"))
  }

  repoDir <- checkDirectory( repoDir )
  
  files <- c( file.path( repoDir, "backpack.db"), 
              list.files( file.path(repoDir, "gallery"), full.names = TRUE ) ) 
  zip( file.path( repoTo, zipname), files)

}

#' @family archivist
#' @rdname zipRepo
#' @export
zipGithubRepo <- function( repoTo = getwd(), user = NULL, repo = NULL, branch = "master", 
                           repoDirGit = FALSE, zipname = "repository.zip"){
  stopifnot( is.character( c( repoTo, branch, zipname ) ), 
             length( repoTo ) == 1, length( branch ) == 1,  length( zipname ) == 1)
  stopifnot( file.exists( repoTo ) )

  GithubCheck( repo, user, repoDirGit ) # implemented in setRepo.R

# repoTo <- checkDirectory2( repoTo )
  if (file.exists(file.path(repoTo, zipname))) {
    stop(paste0("The file ", file.path(repoTo, zipname), " allready exists"))
  }
  
  # clone Github repo
  tempRepoTo <- gsub(pattern = ".zip", replacement = "", x = zipname)
  createEmptyRepo( tempRepoTo, force = TRUE )
  on.exit(deleteRepo( tempRepoTo, deleteRoot = TRUE ))
  hashes <- searchInGithubRepo( pattern="", user=user, repo=repo, branch = branch, repoDirGit = repoDirGit, fixed=FALSE )
  copyGithubRepo(repoTo = tempRepoTo , md5hashes = hashes,
                 user=user, repo=repo, branch = branch, repoDirGit = repoDirGit)
  # list of files
  files <- c( file.path( tempRepoTo, "backpack.db"), 
              list.files( file.path(tempRepoTo, "gallery"), full.names=TRUE ))

  zip( file.path( repoTo, zipname), files=files)
}
