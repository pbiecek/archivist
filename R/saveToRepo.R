##    archivist package for R
##
#' @title Save an Artifact into a Repository 
#'
#' @description
#' \code{saveToRepo} function saves desired artifacts to the local \link{Repository} in a given directory.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' \code{saveToRepo} function saves desired artifacts to the local Repository in a given directory.
#' Artifacts are saved in the local Repository, which is a SQLite database named \code{backpack}. 
#' After every \code{saveToRepo} call the database is refreshed, so the artifact is available 
#' immediately in the database for other collaborators.
#' Every artifact is archived in a \code{md5hash.rda} file. This file will be saved in a folder 
#' (under \code{repoDir} directory) named \code{gallery}. For every artifact, \code{md5hash} is a 
#' unique string of length 32 that comes out as a result of 
#' \link[digest]{digest} function, which uses a cryptographical MD5 hash algorithm.
#' 
#' By default, a miniature of an artifact and (if possible) a data set needed to compute this artifact are extracted. 
#' They are also going to be saved in a file named by their \code{md5hash} in the \code{gallery} folder 
#' that exists in the directory specified in the \code{repoDir} argument. Moreover, a specific \code{Tag}-relation 
#' is going to be added to the \code{backpack} dataset in case there is a need to load 
#' the artifact with it's related data set - see \link{loadFromLocalRepo} or \link{loadFromGithubRepo}. Default settings
#' may be changed by using the \code{archiveData}, \code{archiveTag} or \code{archiveMiniature} arguments with the
#' \code{FALSE} value.
#' 
#' \code{Tags} are artifact's attributes, different for various artifact's classes. For more detailed 
#' information check \link{Tags}
#' 
#' Archived artifact can be searched in the \code{backpack} dataset by using the
#' \link{searchInLocalRepo} or \link{searchInGithubRepo} functions. Artifacts can be searched by their \link{Tags}, 
#' \code{names}, \code{classes} or \code{archiving date}.
#' 
#' Graphical parameters.
#' 
#' If the artifact is of class \code{data.frame} or \code{archiveData = TRUE}, it is possible to specify 
#' how many rows of that data should be archived by adding the argument \code{firstRows} with the n
#' specified number of rows. Note that, the date can be extracted only from the artifacts that are supported by 
#' the \pkg{archivist} package; see \link{Tags}.
#' 
#' If the artifact is of class \code{lattice} or \code{ggplot}, and
#' \code{archiveMiniature = TRUE}, then it is 
#' possible to set the miniature's \code{width} and \code{height} parameters. By default they are set to
#' \code{width = 800}, \code{height = 600}.
#' 
#' Supported artifact's classes are (so far): 
#' \itemize{
#'  \item \code{lm},
#'  \item \code{data.frame},
#'  \item \code{ggplot},
#'  \item \code{htest},
#'  \item \code{trellis},
#'  \item \code{twins (result of agnes, diana or mona function)},
#'  \item \code{partition (result of pam, clara or fanny fuction)},
#'  \item \code{lda},
#'  \item \code{qda},
#'  \item \code{glmnet},
#'  \item \code{survfit}.
#'  }
#'  
#' To check what \code{Tags} will be extracted for various artifacts see \link{Tags}.
#' 
#' @return
#' As a result of this function a character string is returned, which determines
#' the \code{md5hash} of the artifact that was used in the \code{saveToRepo} function. If  
#' \code{archiveData} was \code{TRUE}, the result also
#' has an attribute, named \code{data}, that determines \code{md5hash} of the data needed
#' to compute the artifact.
#' 
#' @seealso
#'  For more detailed information check the \pkg{archivist} package 
#' \href{https://github.com/pbiecek/archivist#-the-list-of-use-cases-}{Use Cases}.
#' The list of supported artifacts and their tags is available on \code{wiki} on \pkg{archivist} 
#' \href{https://github.com/pbiecek/archivist/wiki/archivist-package---Tags}{Github Repository}.
#' 
#' 
#' @note 
#' One can specify his own \code{Tags} for artifacts by setting artifact's attribute 
#' before call of the \code{saveToRepo} function like this: 
#' \code{attr(x, "tags" ) = c( "name1", "name2" )}, where \code{x} is artifact 
#' and \code{name1, name2} are \code{Tags} specified by an user.
#' 
#' Important: if one want to archive data from arftifacts that class is one of: 
#' \code{survfit, glmnet, qda, lda, trellis, htest}, and this dataset set is transformed only in
#' the artifact's formula the \code{saveToRepo} will not archive this dataset. \code{saveToRepo}
#' only archives datasets that already exists in any of R environments. 
#' 
#' Example: here data set will not be archived.
#' \itemize{
#'    \item \code{z <- lda(Sp ~ ., Iris, prior = c(1,1,1)/3, subset = train[,-8])}
#'    \item \code{saveToRepo( z, repoDir )}
#' }
#' Example: here data set will be archived.
#' \itemize{
#'    \item \code{train2 <- train[,-8]}
#'    \item \code{z <- lda(Sp ~ ., Iris, prior = c(1,1,1)/3, subset = train2)}
#'    \item \code{saveToRepo( z, repoDir )}
#' }
#' 
#' @param artifact An arbitrary R artifact to be saved. For supported artifacts see details.
#' 
#' @param ... Graphical parameters denoting width and height of a miniature. See details.
#' 
#' @param archiveData A logical value denoting whether to archive the data from the \code{artifact}.
#' 
#' @param archiveTags A logical value denoting whether to archive tags from the \code{artifact}.
#' 
#' @param archiveMiniature A logical value denoting whether to archive a miniature of the \code{artifact}.
#' 
#' @param repoDir A character denoting an existing directory in which an artifact will be saved.
#' If set to \code{NULL} (by default), uses the \code{repoDir} specified in \link{setLocalRepo}.
#' 
#' @param force A logical value denoting whether to archive \code{artifact} if it was already archived in
#' a Repository.
#' 
#' @param rememberName A logical value. Should not be changed by an user. It is a technical parameter.
#' 
#' @param chain A logical value. Should the result be (default \code{chain = FALSE}) the \code{md5hash} 
#' of an stored artifact or should the result be the input artifact (\code{chain = TRUE}), so that chaining code 
#' can be used. See examples.
#'
#' @param silent If TRUE produces no warnings
#' 
#' @author 
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
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
#' # save examples
#' 
#' exampleRepoDir <- tempdir()
#' createEmptyRepo( repoDir = exampleRepoDir )
#' saveToRepo( myplot123, repoDir=exampleRepoDir )
#' saveToRepo( iris, repoDir=exampleRepoDir )
#' saveToRepo( model, repoDir=exampleRepoDir )
#' saveToRepo( agn1, repoDir=exampleRepoDir )
#' saveToRepo( fannyx, repoDir=exampleRepoDir )
#' saveToRepo( lda1, repoDir=exampleRepoDir )
#' saveToRepo( glmnet1, repoDir=exampleRepoDir )
#' 
#' # let's see how the Repository look like: show
#' 
#' showLocalRepo( method = "md5hashes", repoDir = exampleRepoDir )
#' showLocalRepo( method = "tags", repoDir = exampleRepoDir )
#' 
#' # let's see how the Repository look like: summary
#' 
#' summaryLocalRepo( exampleRepoDir )
#' 
#' # one can archived the same artifact twice, but there is a message
#' 
#' saveToRepo( model, repoDir=exampleRepoDir )
#' 
#' # in case not to archive the same artifact twice, use
#' 
#' saveToRepo( lda1, repoDir=exampleRepoDir, force = FALSE )
#' 
#' # one can archive artifact withouth it's database and miniature
#' 
#' saveToRepo( qda1, repoDir=exampleRepoDir, archiveData = FALSE,
#'             archiveMiniature = FALSE)
#' 
#' # one can specify his own additional tags to be archived with artifact
#' 
#' attr( model, "tags" ) = c( "do not delete", "my favourite model" )
#' saveToRepo( model, repoDir=exampleRepoDir )
#' showLocalRepo( "tags", exampleRepoDir )
#' 
#' # removing an example Repository
#' 
#' # saveToRepo in chaining code
#' library(dplyr)
#' 
#' data("hflights", package = "hflights")
#' hflights %>%
#'   group_by(Year, Month, DayofMonth) %>%
#'   select(Year:DayofMonth, ArrDelay, DepDelay) %>%
#'   saveToRepo( exampleRepoDir, chain = TRUE ) %>%
#'   # here the artifact is stored but chaining is not finished
#'   summarise(
#'     arr = mean(ArrDelay, na.rm = TRUE),
#'     dep = mean(DepDelay, na.rm = TRUE)
#'   ) %>%
#'   filter(arr > 30 | dep > 30) %>%
#'   saveToRepo( exampleRepoDir )
#'   # chaining code is finished and after last operation the 
#'   # artifact is stored
#' 
#' 
#' 
#' deleteRepo( exampleRepoDir )
#' 
#' rm( exampleRepoDir )
#' }
#' @family archivist
#' @rdname saveToRepo
#' @export
saveToRepo <- function( artifact, repoDir = NULL, archiveData = TRUE, 
                        archiveTags = TRUE, 
                        archiveMiniature = TRUE, force = TRUE, rememberName = TRUE, 
                        chain = FALSE, ... , silent=FALSE){
  stopifnot( is.logical( c( archiveData, archiveTags, archiveMiniature, 
                                                     chain, rememberName ) ) )
  stopifnot( is.character( repoDir ) | is.null( repoDir ) )
  
  md5hash <- digest( artifact )
  objectName <- deparse( substitute( artifact ) )
  
  repoDir <- checkDirectory( repoDir )
  
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = repoDir , realDBname = TRUE,
                    paste0( "SELECT * from artifact WHERE md5hash ='", md5hash, "'") )[,1] 
  
  if ( length( check ) > 0 & !force ){
    stop( "This artifact was already archived. If you want to achive it again, use force = TRUE. \n")
  } 
  if ( length( check ) > 0 & force & !silent){
    if ( rememberName ){
      warning( "This artifact was already archived. Another archivisation executed with success.")
    }else{
      warning( "This artifact's data was already archived. Another archivisation executed with success.")
    }
  }
  
  # save artifact to .rd file
  if ( rememberName & !(objectName %in% ls(envir = parent.frame(1)))) {
    warning( paste0("Object with the name ", objectName, ", not found. Saving without name."))
    rememberName = FALSE
  }
  if ( rememberName ){
    save( file = paste0(repoDir,"gallery/", md5hash, ".rda"), ascii = TRUE, list = objectName,  envir = parent.frame(1))
  }else{ 
#    assign( value = artifact, x = md5hash, envir = .GlobalEnv )
#    save( file = paste0(repoDir, "gallery/", md5hash, ".rda"),  ascii=TRUE, list = md5hash, envir = .GlobalEnv  )
    assign( value = artifact, x = md5hash, envir = .ArchivistEnv )
    save( file = paste0(repoDir, "gallery/", md5hash, ".rda"),  ascii=TRUE, list = md5hash, envir = .ArchivistEnv  )
    rm(list = md5hash, envir = .ArchivistEnv)
  }
  
  # add entry to database 
   if ( rememberName ){
  addArtifact( md5hash, name = objectName, dir = repoDir ) 
   }else{
   addArtifact( md5hash, name = md5hash , dir = repoDir)
#   # rm( list = md5hash, envir = .ArchivistEnv ) 
   }
  
  # whether to add tags
  if ( archiveTags ) {
    extractedTags <- extractTags( artifact, objectNameX = objectName )
    userTags <- attr( artifact, "tags" ) 
    sapply( c( extractedTags, userTags ), addTag, md5hash = md5hash, dir = repoDir )
    # attr( artifact, "tags" ) are tags specified by an user
  }
  
  # whether to archive data 
  # if chaining code is used, the "data" attr is not needed
  if ( archiveData & !chain ){
    attr( md5hash, "data" )  <-  extractData( artifact, parrentMd5hash = md5hash, 
                                              parentDir = repoDir, isForce = force )
  }
  if ( archiveData & chain ){
    extractData( artifact, parrentMd5hash = md5hash, 
                 parentDir = repoDir, isForce = force )
  }
  
  # whether to archive miniature
  if ( archiveMiniature )
    extractMiniature( artifact, md5hash, parentDir = repoDir ,... )
  # whether to return md5hash or an artifact if chaining code is used
  if ( !chain ){
    return( md5hash )
  }else{
    return( artifact )
  }
}
