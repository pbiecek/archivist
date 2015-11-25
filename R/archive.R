##    archivist package for R
##
#' @title Archive Artifact to Local and Github Repository
#'
#' @description
#' \code{archive}
#' 
#' More archivist functionalities that integrate archivist and GitHub API can be found here \link{archivist-github-integration}.
#' @param artifact An artifact to be archived on Local and Github \link{Repository}.
#' @param commitMessage A character denoting a message added to the commit while archiving \code{artifact} on GitHub Repository.
#' By default, an artifact's \link{md5hash} is added to the commit message when it is specified to \code{NULL}.
#' @param repo A character denoting GitHub repository name.
#' @param user.name A character denoting GitHub user name. Can be set globally with \code{aoptions("user.name", user.name)}.
#'  See \link{archivist-github-integration}.
#' @param user.password A character denoting GitHub user password. Can be set globally with \code{aoptions("user.password", user.password)}.
#' See \link{archivist-github-integration}.
#' @param response A logical value. Should the GitHub API response be printed.
#' @param archiveData A logical value denoting whether to archive the data from the \code{artifact}.
#' 
#' @param archiveTags A logical value denoting whether to archive Tags from the \code{artifact}.
#' 
#' @param archiveMiniature A logical value denoting whether to archive a miniature of the \code{artifact}.
#' 
#' @param userTags A character vector with Tags. These Tags will be added to the repository along with the artifact.
#' 
#' @param repoDir A character denoting an existing directory in which an artifact will be saved.
#' If it is set to \code{NULL} (by default), it will use the \code{repoDir} specified in \link{setLocalRepo}.
#' 
#' @param force A logical value denoting whether to archive \code{artifact} if it was already archived in
#' a Repository.
#' 
#' @param rememberName A logical value. Should not be changed by a user. It is a technical parameter.
#' 
#' @param chain A logical value. Should the result be (default \code{chain = FALSE}) the \code{md5hash} 
#' of a stored artifact or should the result be an input artifact (\code{chain = TRUE}), so that chaining code 
#' can be used. See examples.
#'
#' @param silent If TRUE produces no warnings.
#' 
#' @param ascii A logical value. An \code{ascii} argument is passed to \link{save} function.
#' 
#' 
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @examples 
#' \dontrun{
#' 
#' ## Empty Github Repository Creation
#' 
#' library(httr)
#' myapp <- oauth_app("github",
#'                    key = app_key,
#'                    secret = app_secret)
#' github_token <- oauth2.0_token(oauth_endpoints("github"),
#'                                myapp,
#'                                scope = "public_repo")
#' aoptions("github_token", github_token)
#' aoptions("user.name", user.name)
#' aoptions("user.password", user.password)
#' 
#' createEmptyGithubRepo("archive-test")
#' unlink("archive-test", recursive = TRUE)
#' cloneGithubRepo('https://github.com/MarcinKosinski/archive-test')
#' setGithubRepo(aoptions("user.name"), "archive-test")
#' ## artifact's archiving
#' 
#' przyklad <- 1:100
#' archive(przyklad) -> md5hash_path
#' 
#' ## proof that artifact is really archived
#' showGithubRepo() # uses options from setGithubRepo
#' # let's remove przyklad
#' rm(przyklad)
#' # and load it back from md5hash_path
#' aread(md5hash_path)
#' 
#' }
#' @family archivist
#' @rdname archive
#' @export
archive <- function(artifact, commitMessage = aoptions("commitMessage"),
                    repo = aoptions("repo"), 
                    user.name = aoptions("user.name"),
                    user.password = aoptions("user.password"),
                    response = aoptions("response"),
                    archiveData = aoptions("archiveData"), 
                    archiveTags = aoptions("archiveTags"), 
                    archiveMiniature = aoptions("archiveMiniature"),
                    force = aoptions("force"),
                    rememberName = aoptions("rememberName"), 
                    ... ,
                    userTags = c(), 
                    silent=aoptions("silent"),
                    ascii = aoptions("ascii")){
  stopifnot(is.character(repo) & length(repo) ==1)
  stopifnot(is.character(user.name) & length(user.name)==1)
  stopifnot(is.character(user.password) & length(user.password)==1)
  stopifnot(is.logical(response) & length(response) ==1)
  
  # artifact archiving
  # the name of the GitHub repo should be the same
  # as local clone repo (can be cloned with cloneGithubRepo)
  # or initialized with createEmptyGithubRepo
#   saveToRepo(artifact = artifact, repoDir = repo,
#              userTags = paste0("name:", 
#                                deparse( substitute( artifact ) ))
#              ) -> md5hash
  stopifnot( is.logical( c( archiveData, archiveTags, archiveMiniature, 
                            rememberName, ascii ) ) )
  #   stopifnot( is.character( format ) & length( format ) == 1 & any(format %in% c("rda", "rdx")) )
  
repoDir <- repo
chain <- FALSE
###########################
###########################
##### start saveToRepo ######
###########################
###########################


  md5hash <- digest( artifact )
  objectName <- deparse( substitute( artifact ) )
  
  repoDir <- checkDirectory( repoDir )
  
  # check if that artifact might have been already archived
  check <- executeSingleQuery( dir = repoDir , realDBname = TRUE,
                               paste0( "SELECT * from artifact WHERE md5hash ='", md5hash, "'") )[,1] 
  
  if ( length( check ) > 0 & !force ){
    stop( paste0("Artifact ",md5hash," was already archived. If you want to achive it again, use force = TRUE. \n"))
  } 
  if ( length( check ) > 0 & force & !silent){
    if ( rememberName ){
      warning( paste0("Artifact ",md5hash," was already archived. Another archivisation executed with success."))
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
    #     if( format == "rda"){
    save( file = file.path(repoDir,"gallery", paste0(md5hash, ".rda")), ascii = ascii, list = objectName,  envir = parent.frame(1))
    #     }else{
    #       saveToRepo2(artifact, filebase = paste0(repoDir,"gallery/", md5hash), ascii = ascii, ...)
    #     }
  }else{ 
    #    assign( value = artifact, x = md5hash, envir = .GlobalEnv )
    #    save( file = paste0(repoDir, "gallery/", md5hash, ".rda"),  ascii=TRUE, list = md5hash, envir = .GlobalEnv  )
    assign( value = artifact, x = md5hash, envir = .ArchivistEnv )
    #     if( format == "rda" ){
    save( file = file.path(repoDir, "gallery", paste0(md5hash, ".rda")),  ascii=ascii, list = md5hash, envir = .ArchivistEnv  )
    #     }else{
    #       saveToRepo2(artifact, filebase = paste0(repoDir,"gallery/", md5hash), ascii = ascii, ...)
    #     }
    rm(list = md5hash, envir = .ArchivistEnv)
  }
  
  # add entry to database 
  if ( rememberName ){
    addArtifact( md5hash, name = objectName, dir = repoDir ) 
  }else{
    addArtifact( md5hash, name = md5hash , dir = repoDir)
    #   # rm( list = md5hash, envir = .ArchivistEnv ) 
  }
  
  # whether to add Tags
  if ( archiveTags ) {
    extractedTags <- extractTags( artifact, objectNameX = objectName )
    # remove name from Tags
    if (!rememberName) {
      extractedTags <- extractedTags[!grepl(extractedTags, pattern="^name:")]
    }
    derivedTags <- attr( artifact, "tags" ) 
    sapply( c( extractedTags, userTags, derivedTags), addTag, md5hash = md5hash, dir = repoDir )
    # attr( artifact, "tags" ) are Tags specified by an user
  }
  
  # whether to archive data 
  # if chaining code is used, the "data" attr is not needed
  if ( archiveData & !chain ){
    attr( md5hash, "data" )  <-  extractData( artifact, parrentMd5hash = md5hash, 
                                              parentDir = repoDir, isForce = force, ASCII = ascii )
  }
  if ( archiveData & chain ){
    extractData( artifact, parrentMd5hash = md5hash, 
                 parentDir = repoDir, isForce = force, ASCII = ascii )
  }
  
  # whether to archive miniature
  if ( archiveMiniature )
    extractMiniature( artifact, md5hash, parentDir = repoDir ,... )
  
###########################
###########################
##### end saveToRepo ######
###########################
###########################

  # commit
  # new rows in backpack.db
  # and new files for artifact
  repoName <- repo
  repo <- git2r::repository(repo)
  
  git2r::add(repo, c("backpack.db",  
             grep(md5hash,
                  x = file.path("gallery",
                                list.files(file.path(repoName, "gallery"))),
                  value = TRUE)))
  
  if (is.null(commitMessage)){
    new_commit <- commit(repo, paste0("archivist: add ", md5hash))
  } else {
    new_commit <- commit(repo, commitMessage)
  }
  
  
#   # skojarzenie lokalnego repozytorium z repozytorium na githubie
#   remote_add(repoLocal,
#              "upstream2",
#              paste0("https://github.com/",user,"/",repo,".git"))
  
  # authentication with GitHub
  cred <- cred_user_pass(user.name,
                         user.password)
  
  # wyslanie do repozytorium na githubie
  push(repo,
       #name = "upstream2",
       refspec = "refs/heads/master",
       credentials = cred)
  
  hook <- paste0("archivist::aread(\"",user.name,"/",repoName,"/",md5hash,"\")")
  
  cat(hook, "\n\n")
  if (response){
    cat(print(resp))
  }
  return(paste0(user.name,"/",repoName,"/",md5hash))
  
  
}