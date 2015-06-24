##    archivist package for R
##
#' @title Save a Set of Artifacts into a Repository 
#' 
#' @description
#' \code{saveSetToRepo} function saves desired set of artifacts to the local \link{Repository} in a given directory.
#' To learn more about artifacts visit \link[archivist]{archivist-package}. Set is a collection containing
#' \itemize{
#'  \item an artifact,
#'  \item data needed to create the artifact,
#'  \item list of functions needed to create the artifact.
#' }
#' 
#' @details
#' \code{saveSetToRepo} archives \code{artifact}, \code{data} and \code{functions} using \link{saveToRepo} function
#' but additionally it adds \link{Tags} to every part of a set in convention as:\code{set:md5hashOfArtifact} to remember
#' that all objects came originally from one set. This additional tag helps to restore a set from a \code{Repository}
#' 
#' @return
#' As a result of this function a character strings is returned, which determines
#' the \code{md5hash} of the archived artifact.
#' 
#' @seealso
#'  For more detailed information check the \pkg{archivist} package 
#' \href{https://github.com/pbiecek/archivist#-the-list-of-use-cases-}{Use Cases}.
#' The list of supported artifacts and their tags is available on \code{wiki} on \pkg{archivist} 
#' \href{https://github.com/pbiecek/archivist/wiki/archivist-package---Tags}{Github Repository}.
#' 
#' 
#' @param artifact An arbitrary R artifact to be saved. For supported artifacts see details.
#'
#' @param data Data needed to compute \code{artifact}.
#' 
#' @param functions Functions needed to compute \code{artifact}. List of them is the best form.
#' 
#' @param ... It's passed to the \link{saveToRepo}. Graphical parameters denoting width and height of a miniature. See details.
#' 
#' @param archiveData It's passed to the \link{saveToRepo}. A logical value denoting whether to archive the data from the \code{artifact}.
#' 
#' @param archiveTags It's passed to the \link{saveToRepo}. A logical value denoting whether to archive tags from the \code{artifact}.
#' 
#' @param archiveMiniature It's passed to the \link{saveToRepo}. A logical value denoting whether to archive a miniature of the \code{artifact}.
#' 
#' @param repoDir It's passed to the \link{saveToRepo}. A character denoting an existing directory in which an artifact will be saved.
#' If set to \code{NULL} (by default), uses the \code{repoDir} specified in \link{setLocalRepo}.
#' 
#' @param force It's passed to the \link{saveToRepo}. A logical value denoting whether to archive \code{artifact} if it was already archived in
#' a Repository.
#' 
#' @param rememberName It's passed to the \link{saveToRepo}. A logical value. Should not be changed by an user. It is a technical parameter.
#' 
#' @param chain It's passed to the \link{saveToRepo}. A logical value. Should the result be (default \code{chain = FALSE}) the \code{md5hash} 
#' of an stored artifact or should the result be the input artifact (\code{chain = TRUE}), so that chaining code 
#' can be used. See examples.
#'
#' @param silent It's passed to the \link{saveToRepo}. If TRUE produces no warnings.
#' 
#' @param ascii It's passed to the \link{saveToRepo}. A logical value. An \code{ascii} argument is passed to \link{save} function.
#' 
#' @author 
#' Marcin Kosinski , \email{m.p.kosinski@@gmail.com}
#' 
#' @examples
#' 
#' \dontrun{
#' 
#' # objects preparation
#' library(ggplot2)
#' library(ggthemes)
#' library(archivist)
#' createEmptyRepo( "SETS" )
#' setLocalRepo( "SETS" )
#' data(iris)
#' 
#' plotArtifact <- ggplot( iris, aes(x = Sepal.Length, y = Species)) +
#'   geom_point()+
#'   theme_wsj()
#' 
#' plotData <- iris
#' plotFunctions <- list( ggplot, geom_point, theme_wsj)
#' 
#' # storing
#' saveSetToRepo( artifact = plotArtifact,
#'    data = plotData,
#'    functions = plotFunctions)
#'    
#' # show method for set   
#' showLocalRepo(method = "sets")
#' }
#' @family archivist
#' @rdname saveSetToRepo
#' @export
saveSetToRepo <- function( artifact, data, functions = list(), 
                                      repoDir = NULL, 
                                      archiveData = TRUE, archiveTags = TRUE, archiveMiniature = TRUE, 
                                      force = TRUE, rememberName = TRUE, 
                                      chain = FALSE, ... , silent=FALSE, ascii = FALSE){
  stopifnot( is.list( functions ) )
  
  
  
  # archive artifact
  ArtifactName <- deparse( substitute( artifact ) )
#   assign(x = ArtifactName, value = artifact, envir = .ArchivistEnv)
  
  attr( artifact, "tags" ) = paste0("set:name:",ArtifactName)
  setmd5hash <- saveToRepo( artifact = artifact,#get(ArtifactName, envir = .ArchivistEnv), 
              repoDir = repoDir, 
              archiveData = archiveData,
              archiveTags = archiveTags,
              archiveMiniature = archiveMiniature,
              force = force,
              rememberName = rememberName,
              chain = chain, ...,
              silent = silent,
              ascii = ascii)
  #rm(list = ArtifactName, envir = .ArchivistEnv)
  
  # archive data
  dataName <- deparse( substitute( data ) )
  attr( data, "tags" ) = c(paste0("set:",setmd5hash), paste0("set:name:",dataName))
  saveToRepo( artifact = data, 
              repoDir = repoDir, 
              archiveData = archiveData,
              archiveTags = archiveTags,
              archiveMiniature = archiveMiniature,
              force = force,
              rememberName = rememberName,
              chain = chain, ...,
              silent = silent,
              ascii = ascii)
  
  # archive functions
  functionsName <- deparse( substitute( functions ) )
  attr( functions, "tags" ) = c(paste0("set:",setmd5hash), paste0("set:name:",functionsName))
  saveToRepo( artifact = functions, 
              repoDir = repoDir, 
              archiveData = archiveData,
              archiveTags = archiveTags,
              archiveMiniature = archiveMiniature,
              force = force,
              rememberName = rememberName,
              chain = chain, ...,
              silent = silent,
              ascii = ascii)
  setmd5hash
}