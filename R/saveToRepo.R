##    archivist package for R
##
#' @title Save an Artifact into a Repository
#'
#' @description
#' \code{saveToLocalRepo} function saves desired artifacts to the local \link{Repository} in a given directory.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#'
#' @details
#' \code{saveToLocalRepo} function saves desired artifacts to the local Repository in a given directory.
#' Artifacts are saved in the local Repository, which is a SQLite database named \code{backpack}.
#' After every \code{saveToLocalRepo} call the database is refreshed, so the artifact is available
#' immediately in the database for other collaborators.
#' Each artifact is archived in a \code{md5hash.rda} file. This file will be saved in a folder
#' (under \code{repoDir} directory) named \code{gallery}. For each artifact, \code{md5hash} is a
#' unique string of length 32 that is produced by
#' \link[digest]{digest} function, which uses a cryptographical MD5 hash algorithm.
#'
#' By default, a miniature of an artifact and (if possible) a data set needed to compute this artifact are extracted.
#' They are also going to be saved in a file named by their \code{md5hash} in the \code{gallery} folder
#' that exists in the directory specified in the \code{repoDir} argument. Moreover, a specific \code{Tag}-relation
#' is going to be added to the \code{backpack} dataset in case there is a need to load
#' the artifact with it's related data set - see \link{loadFromLocalRepo} or \link{loadFromRemoteRepo}. Default settings
#' may be changed by using the \code{archiveData}, \code{archiveTag} or \code{archiveMiniature} arguments with the
#' \code{FALSE} value.
#'
#' \code{Tags} are artifact's attributes, different for various artifact's classes. For more detailed
#' information check \link{Tags}
#'
#' Archived artifact can be searched in the \code{backpack} dataset by using the
#' \link{searchInLocalRepo} or \link{searchInRemoteRepo} functions. Artifacts can be searched by their \link{Tags},
#' \code{names}, \code{classes} or \code{archiving date}.
#'
#' \code{firstRows} parameter.
#'
#' If the artifact is of class \code{data.frame} or user set \code{archiveData = TRUE} for artifact that stores data within it,
#'  it is possible to specify
#' how many rows of that data (or that \code{data.frame}) should be archived in a \code{miniature}.
#'  This can be done by adding the argument \code{firstRows} with the
#' n corresponding to the number of rows (as in \link{head}).
#' Note that, the data can be extracted only from the artifacts that are supported by
#' the \pkg{archivist} package; see \link{Tags}.
#'
#' Graphical parameters.
#'
#' If the artifact is of class \code{lattice} or \code{ggplot}, and
#' \code{archiveMiniature = TRUE}, then it is
#' possible to set the miniature's \code{width} and \code{height} parameters. By default they are set to
#' \code{width = 800}, \code{height = 600}.
#'
#' Supported artifact's classes are listed here \link{Tags}.
#'
#' @return
#' As a result of calling this function a character string is returned, which determines
#' the \code{md5hash} of the artifact. If
#' \code{archiveData} is \code{TRUE}, the result will also
#' have an attribute, named \code{data}, which determines \code{md5hash} of the data needed
#' to compute the artifact.
#'
#' @seealso
#'  For more detailed information check the \pkg{archivist} package
#' \href{http://pbiecek.github.io/archivist/}{Use Cases}.
#' The list of supported artifacts and their tags is available on \code{wiki} on \pkg{archivist}
#' \href{https://github.com/pbiecek/archivist/wiki/archivist-package---Tags}{Github Repository}.
#'
#'
#' @note
#' In the following way one can specify his own \code{Tags} for artifacts by setting artifact's attribute
#' before call of the \code{saveToLocalRepo} function:
#' \code{attr(x, "tags" ) = c( "name1", "name2" )}, where \code{x} is an artifact
#' and \code{name1, name2} are \code{Tags} specified by a user.
#' It can be also done in a new, simpler way by using \code{userTags} parameter like this:
#'  \itemize{
#'    \item \code{saveToLocalRepo(model, repoDir, userTags = c("my_model", "do not delete"))}.
#'  }
#'  
#' Specifing additional \code{Tags} by attributes can be beneficial when one uses \link{addHooksToPrint}.
#'  
#'
#' Important: if one wants to archive data from artifacts which is one of:
#' \code{survfit, glmnet, qda, lda, trellis, htest} class, and this dataset is transformed within
#' the artifact's formula then \code{saveToLocalRepo} will not archive this dataset. \code{saveToLocalRepo}
#' only archives datasets that already exist in any of R environments.
#'
#' Example: The data set will not be archived here.
#' \itemize{
#'    \item \code{z <- lda(Sp ~ ., Iris, prior = c(1,1,1)/3, subset = train[,-8])}
#'    \item \code{saveToLocalRepo( z, repoDir )}
#' }
#' Example: The data set will be archived here.
#' \itemize{
#'    \item \code{train2 <- train[,-8]}
#'    \item \code{z <- lda(Sp ~ ., Iris, prior = c(1,1,1)/3, subset = train2)}
#'    \item \code{saveToLocalRepo( z, repoDir )}
#' }
#'
#' @param artifact An arbitrary R artifact to be saved. For supported artifacts see details.
#'
#' @param ... Graphical parameters denoting width and height of a miniature. See details.
#' Further arguments passed to \link{head}. See Details section about \code{firtsRows} parameter
#'
#' @param archiveData A logical value denoting whether to archive the data from the \code{artifact}.
#'
#' @param archiveSessionInfo A logical value denoting whether to archive the session info that describes the context in this given artifact was created.
#'
#' @param archiveTags A logical value denoting whether to archive Tags from the \code{artifact}.
#'
#' @param archiveMiniature A logical value denoting whether to archive a miniature of the \code{artifact}.
#'
#' @param userTags A character vector with Tags. These Tags will be added to the repository along with the artifact.
#'
#' @param repoDir A character denoting an existing directory in which an artifact will be saved.
#'
#' @param force A logical value denoting whether to archive \code{artifact} if it was already archived in
#' a Repository.
#'
#' @param value A logical value. Should the result be (default \code{value = FALSE}) the \code{md5hash}
#' of a stored artifact or should the result be an input artifact (\code{value = TRUE}), so that valueing code
#' can be used. See examples.
#'
#' @param silent If TRUE produces no warnings.
#'
#' @param ascii A logical value. An \code{ascii} argument is passed to \link{save} function.
#'
#' @param artifactName The name of the artifact with which it should be archived. If \code{NULL} then object's MD5 hash will be used instead.
#'
#'
#' @author
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' exampleRepoDir <- tempfile()
#' createLocalRepo(repoDir = exampleRepoDir)
#' data(swiss)
#' saveToLocalRepo(swiss, repoDir=exampleRepoDir, archiveSessionInfo = TRUE)
#' showLocalRepo(method = "md5hashes", repoDir = exampleRepoDir)
#' showLocalRepo(method = "tags", repoDir = exampleRepoDir)
#' 
#' loadFromLocalRepo(md5hash = 'f05f0ed0662fe01850ec1b928830ef32',
#'   repoDir = system.file("graphGallery", package = "archivist"), value = TRUE) -> pl
#' 
#' saveToLocalRepo(pl, repoDir=exampleRepoDir,
#'              userTags = c("do not delete", "my favourite graph"))
#' aoptions('repoDir', system.file("graphGallery", package = "archivist"))
#' showLocalRepo(method = "tags")
#' data(iris)
#' asave(iris, silent = FALSE) # iris was used in pl
#' aoptions('repoDir', NULL, unset = TRUE)
#' deleteLocalRepo(exampleRepoDir, TRUE)
#' rm(exampleRepoDir)
#'
#' @family archivist
#' @rdname saveToRepo
#' @export
saveToLocalRepo <- function( artifact, repoDir = aoptions('repoDir'), archiveData = TRUE,
                        archiveTags = TRUE,
                        archiveMiniature = TRUE, 
                        archiveSessionInfo = TRUE, 
                        force = TRUE, 
                        value = FALSE, ... , userTags = c(),
                        silent=aoptions("silent"), ascii = FALSE,
                        artifactName = deparse(substitute(artifact))) {
  stopifnot(is.logical(c(archiveData, archiveTags, archiveMiniature, force,  value, silent, ascii, archiveSessionInfo)))
  stopifnot(is.character(repoDir) & length(repoDir) == 1 )
  stopifnot(is.null(artifactName) | is.character(artifactName))
  stopifnot(length(archiveData) == 1, length(archiveTags) == 1, length(archiveMiniature) == 1,
            length(archiveSessionInfo) == 1, length(force) == 1, 
            length(value) == 1, length(ascii) == 1, length(artifactName) <= 1)

  md5hash <- digest( artifact )
  if (is.null(artifactName)) {
    artifactName <- md5hash
  }

  repoDir <- checkDirectory( repoDir )

  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = repoDir , 
                    paste0( "SELECT * from artifact WHERE md5hash ='", md5hash, "'") )[,1]

  if ( length( check ) > 0 & !force ){
    stop( paste0("Artifact ",md5hash," was already archived. If you want to archive it again, use force = TRUE. \n"))
  }
  if ( length( check ) > 0 & force & !silent){
      warning( paste0("Artifact ",md5hash," was already archived. Another archivisation executed with success."))
  } 

  assign(x = artifactName, value = artifact)
  save( file = file.path(repoDir,"gallery", paste0(md5hash, ".rda")), ascii = ascii, list = artifactName)
  addTag("format:rda", md5hash, dir=repoDir)

  # add entry to database
   addArtifact( md5hash, name = artifactName, dir = repoDir )

  # whether to add Tags
  if ( archiveTags ) {
    extractedTags <- extractTags( artifact, objectNameX = artifactName )
    derivedTags <- attr( artifact, "tags" )
    sapply( c( extractedTags, userTags, derivedTags), addTag, md5hash = md5hash, dir = repoDir )
    # attr( artifact, "tags" ) are Tags specified by a user
  }

  # whether to archive session_info
  if ( archiveSessionInfo ){
    if (!requireNamespace("devtools", quietly = TRUE)) {
      stop("devtools package required for archiveSessionInfo parameter")
    }
    sesionInfo <- devtools::session_info()
    md5hashDF <- saveToLocalRepo( sesionInfo, archiveData = FALSE, repoDir = repoDir, 
                             artifactName = NULL, archiveTags = FALSE, force=TRUE, 
                             archiveSessionInfo = FALSE)
    addTag( tag = paste0("session_info:", md5hashDF), md5hash = md5hash, dir = repoDir )
  }
  # whether to archive data
  # if valueing code is used, the "data" attr is not needed
  if ( archiveData & !value ){
    attr( md5hash, "data" )  <-  extractData( artifact, parrentMd5hash = md5hash, 
                                              parentDir = repoDir, isForce = force, ASCII = ascii )
  }
  if ( archiveData & value ){
    extractData( artifact, parrentMd5hash = md5hash,
                 parentDir = repoDir, isForce = force, ASCII = ascii )
  }

  # whether to archive miniature
  if ( archiveMiniature )
    extractMiniature( artifact, md5hash, parentDir = repoDir ,... )
  # whether to return md5hash or an artifact if valueing code is used
  if ( !value ){
    return( md5hash )
  }else{
    return( artifact )
  }
}

#'
#' @rdname saveToRepo
#' @export
saveToRepo <- saveToLocalRepo
  
#'
#' @rdname saveToRepo
#' @export
asave <- saveToLocalRepo
