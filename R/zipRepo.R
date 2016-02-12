##
#' @title Create a zip Archive From an Existing Repository
#' 
#' @description
#' \code{zipLocalRepo} and \code{zipRemoteRepo} create a zip archive from an
#' existing \link{Repository}. \code{zipLocalRepo} zips local \code{Repository},
#' \code{zipRemoteRepo} zips \code{Repository} stored on Github.
#' 
#' 
#' @note
#' The function might not work if \code{Rtools} are not installed.
#' To solve this problem follow these \href{http://cran.r-project.org/web/packages/openxlsx/vignettes/Introduction.pdf}{Instructions.}
#' 
#' If \code{repo} and \code{user} are set to \code{NULL} (as default) in Github mode then global parameters
#' set in \link{setRemoteRepo} function are used.
#'
#' @param repoType A character containing a type of the remote repository. Currently it can be 'Remote' or 'bitbucket'.
#' 
#' @param repoDir A character that specifies the directory of the Repository which
#' will be zipped. 
#'
#' @param repo While working with the Remote repository. A character containing
#' a name of the Remote repository on which the Repository, which is to be zipped, is archived.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param user While working with the Remote repository. A character containing
#' a name of the Remote user on whose account the \code{repo} is created.
#' By default set to \code{NULL} - see \code{Note}.
#' 
#' @param branch While working with the Remote repository. A character containing a name of the
#' Remote repository's branch on which Repository, which is to be zipped, is archived.
#' Default \code{branch} is \code{master}.
#' 
#' @param subdir While working with a Remote repository. A character containing a name of
#' a directory on Remote repository on which the Repository, which is to be zipped, is stored.
#' If the Repository is stored in the main folder on the Remote repository, this should be set 
#' to FALSE as default.
#' 
#' @param repoTo A character that specifies the directory in which there
#' will be created zip archive from \code{Repository} stored in \code{repoDir} or Remote directory.
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
#' createLocalRepo( repoDir = exampleRepoDir )
#' saveToLocalRepo( myplot123, repoDir=exampleRepoDir )
#' saveToLocalRepo( iris, repoDir=exampleRepoDir )
#' saveToLocalRepo( model, repoDir=exampleRepoDir )
#' 
#' 
#'  
#' zipLocalRepo( exampleRepoDir )
#' 
#' deleteLocalRepo( exampleRepoDir, TRUE)
#' 
#' rm( exampleRepoDir )
#' 
#' # Remote version
#' 
#' zipRemoteRepo( user="MarcinKosinski", 
#' repo="Museum", branch="master", subdir="ex1" )
#' 
#' zipRemoteRepo( user="pbiecek", repo="archivist", repoTo = getwd( ) )
#' 
#' }
#' 
#' @family archivist
#' @rdname zipRepo
#' @export
zipLocalRepo <- function( repoDir = aoptions('repoDir'), repoTo = getwd() , zipname="repository.zip"){
  stopifnot( is.character( repoDir ) & length( repoDir ) == 1 )
  stopifnot( is.character( repoTo ), length( repoTo ) == 1 )
  
#   repoTo <- checkDirectory2( repoTo )
  if (file.exists(file.path(repoTo, zipname))) {
    stop(paste0("The file ", file.path(repoTo, zipname), " already exists"))
  }

  repoDir <- checkDirectory( repoDir )
  
  files <- c( file.path( repoDir, "backpack.db"), 
              list.files( file.path(repoDir, "gallery"), full.names = TRUE ) ) 
  zip( file.path( repoTo, zipname), files)

}

#' @family archivist
#' @rdname zipRepo
#' @export
zipRemoteRepo <- function( repoTo = getwd(), user = aoptions("user"), repo = aoptions("repo"), branch = "master", 
                           subdir = aoptions("subdir"),  repoType = aoptions("repoType"), zipname = "repository.zip"){
  stopifnot( is.character( c( repoTo, branch, zipname ) ), 
             length( repoTo ) == 1, length( branch ) == 1,  length( zipname ) == 1)
  stopifnot( file.exists( repoTo ) )

  RemoteRepoCheck( repo, user, branch, subdir, repoType) # implemented in setRepo.R
  
# repoTo <- checkDirectory2( repoTo )
  if (file.exists(file.path(repoTo, zipname))) {
    stop(paste0("The file ", file.path(repoTo, zipname), " already exists"))
  }
  
  # clone Remote repo
  tempRepoTo <- gsub(pattern = ".zip", replacement = "", x = zipname)
  createLocalRepo( tempRepoTo, force = TRUE )
  on.exit(deleteLocalRepo( tempRepoTo, deleteRoot = TRUE ))
  hashes <- searchInRemoteRepo( pattern="", user=user, repo=repo, branch = branch, subdir = subdir, repoType=repoType, fixed=FALSE )
  copyRemoteRepo(repoTo = tempRepoTo , md5hashes = hashes,
                 user=user, repo=repo, branch = branch, subdir = subdir, repoType=repoType)
  # list of files
  files <- c( file.path( tempRepoTo, "backpack.db"), 
              list.files( file.path(tempRepoTo, "gallery"), full.names=TRUE ))

  zip( file.path( repoTo, zipname), files=files)
}
