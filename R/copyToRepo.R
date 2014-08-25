##    archivist package for R
##
#' @title Copy an Existing Repository to Another Repository
#'
#' @description
#' \code{copyToRepo} copies artifact from one \link{Repository} to another \code{Repository}.
#' 
#' 
#' @details
#' \code{copyToRepo} copies artifact from one \code{Repository} to another \code{Repository}. It addes new files
#' to exising \code{gallery} folder in \code{repoTo} \code{Repository}. \code{copyLocalRepo} copies local \code{Repository}, where
#' \code{copyGithubRepo} copies Github \code{Repository}. 
#'
#' @param repoFrom A character that specifies the directory of the Repository from which
#' artifacts will be copied. Works only on \code{copyLocalRepo}.
#'
#' @param repoTo A character that specifies the directory of the Repository in which
#' artifacts will be copied.
#' 
#' @param md5hashes A character or character vector containing \code{md5hashes} of artifacts to be copied.
#' 
#' @param repo Only if coping a Github repository. A character containing a name of a Github repository on which the \code{repoFrom}-Repository is archived.
#' 
#' @param user Only if coping a Github repository. A character containing a name of a Github user on whose account the \code{repoFrom} is created.
#' 
#' @param branch Only if coping with a Github repository. A character containing a name of 
#' Github Repository's branch on which a \code{repoFrom}-Repository is archived. Default \code{branch} is \code{master}.
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
#' # lda object
#' library(MASS)
#'
#' Iris <- data.frame(rbind(iris3[,,1], iris3[,,2], iris3[,,3]),
#'                   Sp = rep(c("s","c","v"), rep(50,3)))
#' train <- c(8,83,115,118,146,82,76,9,70,139,85,59,78,143,68,
#'            134,148,12,141,101,144,114,41,95,61,128,2,42,37,
#'            29,77,20,44,98,74,32,27,11,49,52,111,55,48,33,38,
#'            113,126,24,104,3,66,81,31,39,26,123,18,108,73,50,
#'            56,54,65,135,84,112,131,60,102,14,120,117,53,138,5)
#' lda1 <- lda(Sp ~ ., Iris, prior = c(1,1,1)/3, subset = train)
#'
#' # qda object
#' tr <- c(7,38,47,43,20,37,44,22,46,49,50,19,4,32,12,29,27,34,2,1,17,13,3,35,36)
#' train <- rbind(iris3[tr,,1], iris3[tr,,2], iris3[tr,,3])
#' cl <- factor(c(rep("s",25), rep("c",25), rep("v",25)))
#' qda1 <- qda(train, cl)
#'
#' # glmnet object
#' library( glmnet )
#'
#' zk=matrix(rnorm(100*20),100,20)
#' bk=rnorm(100)
#' glmnet1=glmnet(zk,bk)
#'
#' 
#' # creating example Repository - that examples will work
#' 
#' TODO ADD EXAMPLES
#' 
#' }
#' 
#' @family archivist
#' @rdname copyToRepo
#' @export
copyLocalRepo <- function( repoFrom, repoTo, md5hashes ){
 stopifnot( is.character( c( repoFrom, repoTo, md5hashes ) ) )
 
 repoFrom <- checkDirectory( repoFrom )
 repoTo <- checkDirectory( repoTo )
 
 copyRepo( repoFrom = repoFrom, repoTo = repoTo, md5hashes = md5hashes )
}


#' @rdname copyToRepo
#' @export
copyGithubRepo <- function( repoTo, md5hashes, user, repo, branch="master"){
  stopifnot( is.character( c( repoTo, user, repo, branch, md5hashes ) ) )
  
  repoTo <- checkDirectory( repoTo )
  
  Temp <- downloadDB( repo, user, branch )
  
  copyRepo( repoTo = repoTo, repoFrom = Temp, md5hashes = md5hashes , 
            local = FALSE, user = user, repo = repo, branch = branch )  
  
}


copyRepo <- function( repoFrom, repoTo, md5hashes, local = TRUE, user, repo, branch ){
  
  # clone artifact table
  toInsertArtifactTable <- executeSingleQuery( dir = repoFrom, realDBname = local,
                      paste0( "SELECT FROM artifact WHERE md5hash IN ",
                             "(", paste0( md5hashes, collapse=","), ")" ) ) 
  apply( toInsertArtifactTable, 1, function(x){
    executeSingleQuery( dir = repoTo, 
                        paste0( "INSERT INTO artifact (md5hash, name, createdDate) VALUES ('",
                                x[1], ",",
                                x[2], ",",
                                x[3], ")'" ) ) } )
  # clone tag table
  toInsertTagTable <- executeSingleQuery( dir = repoFrom, realDBname = local,
                                               paste0( "SELECT FROM tag WHERE artifact IN ",
                                                       "('", paste0( md5hashes, collapse="','"), "')" ) ) 
  apply( toInsertTagTable, 1, function(x){
    executeSingleQuery( dir = repoTo, 
                        paste0( "INSERT INTO tag (artifact, tag, createdDate) VALUES ('",
                                x[1], ",",
                                x[2], ",",
                                x[3], ")'" ) ) } )
  if ( local ){
  # clone files
  
  whichToClone <- as.vector( sapply( md5hashes, function(x){
    which( x == sub( list.files( "gallery" ), pattern = "\\.[a-z]{3}", 
                     replacement="" ) ) 
  } ) )
  
  filesToClone <- list.files( "gallery" )[whichToClone]
  sapply( filesToClone, file.copy, from = repoFrom, to = paste0( repoTo, "gallery/" ),
          recursive = TRUE )
  } else {
    # if github mode
    # get files list
    
    # TO DO - not finished 
    #
    sapply( filesToDownload, cloneGithubFile, repo = repo, user = user, branch = branch, to = repoTo )
  }
  
  }



cloneGithubFile <- function( file, repo, user, branch, to ){
    URLfile <- paste0( get( ".GithubURL", envir = .ArchivistEnv) , 
                       user, "/", repo, "/", branch, "/gallery/", file) 
    library( RCurl )
    fileFromGithub <- getBinaryURL( URLfile, ssl.verifypeer = FALSE )
    file.create( paste0( to, "gallery/", file ) )
    writeBin( fileFromGithub, paste0( to, "gallery/", file ) )
    
  }


  
  
#   for( i in 1:length( md5hashes ) ){
#     if( local ){
#       value <- loadFromLocalRepo( md5hashes[i], repoDir = repoFrom, value = TRUE )
#       
#     } else {
#       value <- loadFromGithubRepo( md5hashes[i], user = user, repo = repo, value = TRUE )
#     }
#     name <- unlist( executeSingleQuery( dir = repoFrom, paste = local,
#                                 paste0( "SELECT DISTINCT name FROM artifact WHERE md5hash = ",
#                                         "'", md5hashes[i], "'" ) ) )
#     
#     assign(x = name, value = value, .ArchivistEnv )
#     saveToRepo( get(name, envir = .ArchivistEnv ), repoDir = repoTo ) 
#     rm( list = get(name, envir = .ArchivistEnv ), envir = .ArchivistEnv)
#   }
  # error
#   
#   Error in save(file = paste0(repoDir, "gallery/", md5hash, ".rda"), ascii = TRUE,  : 
#                   nie znaleziono obiektu ‘get(name, envir = .ArchivistEnv)’ 
#                 5 stop(sprintf(ngettext(n, "object %s not found", "objects %s not found"), 
#                                paste(sQuote(list[!ok]), collapse = ", ")), domain = NA) 
#                 4 save(file = paste0(repoDir, "gallery/", md5hash, ".rda"), ascii = TRUE, 
#                        list = objectName, envir = parent.frame(2)) at saveToRepo.R#208
#                 3 saveToRepo(get(name, envir = .ArchivistEnv), repoDir = repoTo) at copyToRepo.R#135
#                 2 copyRepo(repoTo = repoTo, repoFrom = Temp, md5hashes = md5hashes, 
#                            local = FALSE, user = user, repo = repo) at copyToRepo.R#115
#                 1 copyGithubRepo(repoTo = dirr, md5hashes = hashes, user = "pbiecek", 
#                                  repo = "archivist")
  
