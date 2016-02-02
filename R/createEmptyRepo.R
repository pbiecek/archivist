##    archivist package for R
##
#' @title Create an Empty Repository
#'
#' @description
#' \code{createEmptyLocalRepo} creates an empty \link{Repository} in the given directory in which archived artifacts will be stored.
#' \code{createEmptyGithubRepo} creates a new GitHub repository with an empty \pkg{archivist}-like \link{Repository} and
#' also creates a local \code{Repository} with \code{createEmptyLocalRepo} which is git-synchronized with
#' new GitHub repository. \code{createEmptyRepo} is a wrapper around \code{createEmptyLocalRepo} and \code{createEmptyGithubRepo}
#'  functions and by default triggers \code{createEmptyLocalRepo} to maintain consistency with the previous \pkg{archivist} versions (<1.8.6.0)
#'  where there was only \code{createEmptyRepo} which created local \code{Repository}. To learn more about
#'  \code{Archivist Integration With GitHub API} visit \link{archivist-github-integration} (\link{agithub}).
#' 
#' 
#' @details
#' At least one Repository must be initialized before using other functions from the \pkg{archivist} package. 
#' While working in groups, it is highly recommended to create a Repository on a shared Dropbox/GitHub folder.
#' 
#' All artifacts which are desired to be archived are going to be saved in the local Repository, which is an SQLite 
#' database stored in a file named \code{backpack}. 
#' After calling \code{saveToRepo} function, each artifact will be archived in a \code{md5hash.rda} file. 
#' This file will be saved in a folder (under \code{repoDir} directory) named 
#' \code{gallery}. For every artifact, \code{md5hash} is a unique string of length 32 that is produced by
#' \link[digest]{digest} function, which uses a cryptographical MD5 hash algorithm.
#' 
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' Created \code{backpack} database is a useful and fundamental tool for remembering artifact's 
#' \code{name}, \code{class}, \code{archiving date} etc. (the so called \link{Tags})
#' or for keeping artifact's \code{md5hash}.
#' 
#' Besides the \code{backpack} database, \code{gallery} folder is created in which all 
#' artifacts will be archived.
#' 
#' After every \code{saveToRepo} call the database is refreshed. As a result, the artifact is available 
#' immediately in \code{backpack.db} database for other collaborators.
#' 
#' @param type A character. Whether to use \code{Local} or \code{Github} version while using \code{createEmptyRepo} wrapper.
#' 
#' @param repoDir A character that specifies the directory for the Repository which is to be made. While working with GitHub Repository, this will
#' be the directory of the synchronized Local Repository, in which the new Local Repository will be created (is \code{NULL} then is the same as \code{repo}).
#' 
#' @param force If \code{force = TRUE} and \code{repoDir} parameter specifies the directory that doesn't exist,
#' then function call will force to create new \code{repoDir} directory.
#' Default set to \code{force = TRUE}.
#' 
#' @param default If \code{default = TRUE} then \code{repoDir} (\code{repo}) is set as default local repository 
#' (for GitHub version also the \code{user} is set as default GitHub user).
#' 
#' @param repo While working with a Github repository. A character denoting new GitHub repository name. White spaces will be substitued with a dash.
#' @param github_token While working with a Github repository. An OAuth GitHub Token created with the \link{oauth2.0_token} function. See \link{archivist-github-integration}.
#' Can be set globally with \code{aoptions("github_token", github_token)}.
#' @param repoDescription While working with a Github repository. A character specifing the new GitHub repository description.
#' @param user While working with a Github repository. A character denoting GitHub user name. Can be set globally with \code{aoptions("user", user)}.
#'  See \link{archivist-github-integration}.
#' @param password While working with a Github repository. A character denoting GitHub user password. Can be set globally with \code{aoptions("password", password)}.
#' See \link{archivist-github-integration}.
#' @param readmeDescription While working with a Github repository. A character of the content of \code{README.md} file. By default a description of \link{Repository}.
#' Can be set globally with \code{aoptions("readmeDescription", readmeDescription)}. In order to omit 
#' \code{README.md} file set \code{aoptions("readmeDescription", NULL)}.
#' @param response A logical value. Should the GitHub API response be returned.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples
#' \dontrun{
#' exampleRepoDir <- tempfile()
#' createEmptyRepo( repoDir = exampleRepoDir )
#'
#' # check the state of an empty Repository
#' 
#' summaryLocalRepo(  repoDir = exampleRepoDir )
#' showLocalRepo( exampleRepoDir )
#' 
#' # creating a Repository in non existing directory
#' 
#' createEmptyLocalRepo( "xyzdd234") # force = TRUE is default argument
#'
#' # creating a default local Repository in non existing directory
#' 
#' createEmptyRepo("def", default = TRUE) 
#' data(iris)
#' saveToRepo(iris) # We don't have to specify repoDir parameter
#' showLocalRepo() # because repoDir="def" is default 
#'
#'  # removing an example Repositories
#' 
#' deleteRepo( exampleRepoDir, TRUE)
#' deleteRepo( "xyzdd234", TRUE)
#' deleteRepo("def", TRUE)
#' 
#' rm( exampleRepoDir )
#' 
#' ## GitHub version
#' 
#' library(httr)
#' myapp <- oauth_app("github",
#'                    key = app_key,
#'                    secret = app_secret)
#' github_token <- oauth2.0_token(oauth_endpoints("github"),
#'                                 myapp,
#'                                 scope = "public_repo")
#' aoptions("github_token", github_token)
#' aoptions("user", user)
#' aoptions("password", password)
#' 
#' createEmptyGithubRepo("Museum")
#' createEmptyGithubRepo("Museum-Extras", response = TRUE)
#' createEmptyGithubRepo("Gallery", readmeDescription = NULL)
#' createEmptyGithubRepo("Landfill", 
#'         repoDescription = "My models and stuff") 
#' createEmptyGithubRepo("MuseumYYYY", repoDir = "Museum_YY")
#'         
#'         
#'         
#' # empty Github Repository creation
#' 
#' library(httr)
#' myapp <- oauth_app("github",
#'                    key = app_key,
#'                    secret = app_secret)
#' github_token <- oauth2.0_token(oauth_endpoints("github"),
#'                                myapp,
#'                                scope = "public_repo")
#' # setting options                              
#' aoptions("github_token", github_token)
#' aoptions("user", user)
#' aoptions("password", password)
#' 
#' createEmptyGithubRepo("archive-test4", default = TRUE)
#' ## artifact's archiving
#' przyklad <- 1:100
#' 
#' # archiving
#' archive(przyklad) -> md5hash_path
#' 
#' ## proof that artifact is really archived
#' showGithubRepo() # uses options from setGithubRepo
#' # let's remove przyklad
#' rm(przyklad)
#' # and load it back from md5hash_path
#' aread(md5hash_path)
#' 
#' 
#' # clone example
#' unlink("archive-test", recursive = TRUE)
#' cloneGithubRepo('https://github.com/MarcinKosinski/archive-test')
#' setGithubRepo(aoptions("user"), "archive-test")
#' data(iris)
#' archive(iris)
#' showGithubRepo()
#' 
#' }
#' @family archivist
#' @rdname createEmptyRepo
#' @export
createEmptyRepo <- function( repoDir, force = TRUE, default = FALSE,
                             repo,
                             github_token = aoptions("github_token"), 
                             user = aoptions("user"),
                             #user.email = aoptions("user.email"),
                             password = aoptions("password"),
                             repoDescription = aoptions("repoDescription"),
                             readmeDescription = aoptions("readmeDescription"),
                             response = aoptions("response"),
                             type = "local"){
  stopifnot(is.character(type) & length(type) ==1 & type %in% c("local", "github"))
  if (type == "local") {
    createEmptyLocalRepo(repoDir = repoDir, force = force, default = default)
  } else {
    createEmptyGithubRepo(repo = repo,
                          github_token = github_token,
                          repoDir = repoDir,
                          user = user,
                          password = password,
                          repoDescription = repoDescription,
                          readmeDescription = readmeDescription,
                          response = response, default = default)
  }
  
}

#' @rdname createEmptyRepo
#' @export
createEmptyLocalRepo <- function( repoDir, force = TRUE, default = FALSE ){
  stopifnot( is.character( repoDir ), length( repoDir ) == 1 )
  stopifnot( is.logical( default ), length( default ) == 1 )
  
  if ( !file.exists( repoDir ) & !force ) 
    stop( paste0("Directory ", repoDir, " does not exist. Try with force=TRUE.") )
  if ( !file.exists( repoDir ) & force ){
    cat( paste0("Directory ", repoDir, " did not exist. Forced to create a new directory.") )
    repoDir <- checkDirectory( repoDir, create = TRUE )
    dir.create( repoDir )
  }
  
  repoDir <- checkDirectory( repoDir, create = TRUE )
  
  # create connection
  backpack <- getConnectionToDB( repoDir, realDBname = TRUE )
  
  # create tables
  artifact <- data.frame(md5hash = "",
                         name = "",
                         createdDate = as.character( now() ), 
                         stringsAsFactors = FALSE ) 
  
  tag <- data.frame(artifact = "", 
                    tag = "", 
                    createdDate = as.character( now() ), 
                    stringsAsFactors = FALSE )
  
  # insert tables into database
  dbWriteTable( backpack, "artifact", artifact, overwrite = TRUE, row.names = FALSE )
  dbWriteTable( backpack, "tag", tag, overwrite = TRUE, row.names = FALSE )
  
  
  dbGetQuery(backpack, "delete from artifact")
  dbGetQuery(backpack, "delete from tag")
  
  dbDisconnect( backpack )
  
  # if gallery folder does not exist - make it
  if ( !file.exists( file.path( repoDir, "gallery" ) ) ){
    dir.create( file.path( repoDir, "gallery" ), showWarnings = FALSE)
  }
  
  if (default) {
    setLocalRepo(repoDir)
  }
   
}

#' @rdname createEmptyRepo
#' @export
createEmptyGithubRepo <- function(repo,
                                  github_token = aoptions("github_token"), 
                                  user = aoptions("user"),
                                  repoDir = NULL,
                                  #user.email = aoptions("user.email"),
                                  password = aoptions("password"),
                                  repoDescription = aoptions("repoDescription"),
                                  readmeDescription = aoptions("readmeDescription"),
                                  response = aoptions("response"),
                                  default = FALSE){
  stopifnot(is.character(repo) & length(repo) ==1)
  stopifnot((is.character(repoDir) & length(repoDir) ==1) | (is.null(repoDir)))
  stopifnot(is.character(repoDescription) & length(repoDescription) ==1)
  #stopifnot(any(class(github_token) %in% "Token"))
  stopifnot(is.character(user) & length(user)==1)
  #stopifnot(is.character(user.email) & length(user.email)==1)
  stopifnot(is.character(password) & length(password)==1)
  stopifnot((is.character(readmeDescription) & length(readmeDescription)==1) |
              is.null(readmeDescription))
  stopifnot(is.logical(response) & length(response) ==1)
  
  
  stopifnot( is.logical( default ), length( default ) == 1 )
  repo <- gsub(pattern = " ", "-", repo)

  shortPath <- FALSE
  if(is.null(repoDir)) {
    shortPath <- TRUE
    repoDir <- repo
  }
  
  # httr imports are in archivist-package.R file
  # creating an empty GitHub Repository
  POST(url = "https://api.github.com/user/repos",
       encode = "json",
       body = list(
         name = jsonlite::unbox(repo),
         description = jsonlite::unbox(repoDescription)
       ),
       config = httr::config(token = github_token)
  ) -> resp
  
  
  # git2r imports are in the archivist-package.R
  #path <- repoDir
  dir.create(repoDir)
  
  if (!shortPath){
    dir.create(file.path(repoDir, repo))
    repoDir_path <- file.path(repoDir, repo)
  } else {
    repoDir_path <- repo
  }
  
  # initialize local git repository
  # git init
  repoDir_git2r <- init(repoDir_path)
  
  ## Create and configure a user
  # git config - added to Note section
  #git2r::config(repo, ...) # if about to use, the add to archivist-package.R
  
  # archivist-like Repository creation
  createEmptyRepo(repoDir = repoDir_path)
  file.create(file.path(repoDir_path, "gallery", ".gitkeep"))
  # git add
  if (!is.null(readmeDescription)){
    file.create(file.path(repoDir_path, "README.md"))
    writeLines(aoptions("readmeDescription"), file.path(repoDir_path, "README.md"))
    add(repoDir_git2r, c("backpack.db", "gallery/", "README.md"))
  } else {
    add(repoDir_git2r, c("backpack.db", "gallery/"))
  }
  
  # git commit
  new_commit <- commit(repoDir_git2r, "archivist Repository creation.")
  
  # association of the local and GitHub git repository
  # git add remote
  remote_add(repoDir_git2r,
             #"upstream2",
             'origin',
             file.path("https://github.com", user, paste0(repo, ".git")))
  
  # GitHub authorization
  # to perform pull and push operations
  cred <- git2r::cred_user_pass(user,
                         password)
  
  # push archivist-like Repository to GitHub repository
  push(repoDir_git2r,
       #name = "upstream2",
       refspec = "refs/heads/master",
       credentials = cred)
  
  if (response){
    return(resp)
  }
  
  if (default) {
    setLocalRepo(repoDir_path)
    setGithubRepo(repo = repo, user = user)
  }
  
}



addArtifact <- function( md5hash, name, dir ){
  # creates connection and driver
  # send insert
  executeSingleQuery( dir,
              paste0( "insert into artifact (md5hash, name, createdDate) values",
                      "('", md5hash, "', '", name, "', '", as.character( now() ), "')" ) )
}

addTag <- function( tag, md5hash, createdDate = now(), dir ){
 executeSingleQuery( dir,
              paste0("insert into tag (artifact, tag, createdDate) values ",
                     "('", md5hash, "', '", gsub(tag, pattern="'", replacement=""), "', '", as.character( now() ), "')" ) )
}

# realDBname was needed because Github version function uses temporary file as database
# and they do not name this file as backpack.db in repoDir directory
getConnectionToDB <- function( repoDir, realDBname ){
    if ( realDBname ){
      conn <- dbConnect( get( "sqlite", envir = .ArchivistEnv ), file.path( repoDir, "backpack.db" ) )
    }else{
      conn <- dbConnect( get( "sqlite", envir = .ArchivistEnv ), repoDir )
    }
    return( conn )
}
  
executeSingleQuery <- function( dir, query, realDBname = TRUE ) {
  conn <- getConnectionToDB( dir, realDBname )
  on.exit( dbDisconnect( conn ) )
  res <- dbGetQuery( conn, query )
  return( res )
}

readSingleTable <- function( dir, table, realDBname = TRUE ){
  conn <- getConnectionToDB( dir, realDBname )
  tabs <- dbReadTable( conn, table )
  dbDisconnect( conn )
  return( tabs )
}

# for Github version function that requires to load database
downloadDB <- function( remoteHook ){
   URLdb <- file.path( remoteHook, "backpack.db") 
   if (url.exists(URLdb)){
     db <- getBinaryURL( URLdb )
     Temp2 <- tempfile()
     file.create( Temp2 )
     writeBin( db, Temp2 )
     return( Temp2 )
   } else {
     stop(paste0("Such a repo: ", remoteHook, " does not exist",
                 "or there is no archivist-like Repository on this repo."))
   }
     
}

checkDirectory <- function( directory, create = FALSE ){
  # check if global repository was specified by setLocalRepo
  if ( is.null(directory) ){

    directory <- aoptions("repoDir")
  }
  # check whether it is second call of checkDirectory 
  # (e.g CreatEmptyRepo + default = TRUE)
#   if ( grepl("/$", x = directory , perl=TRUE) ){
#     directory <- gsub(pattern = ".$", replacement = "",
#                       x = directory, perl = TRUE)
#   }
  # check property of directory
  if ( !create ){
    # check whether repository exists
    if ( !dir.exists( directory ) ){
      stop( paste0( "There is no such repository as ", directory ) )
    }
    # check if repository is proper (has backpack.db and gallery)
    if ( !all( c("backpack.db", "gallery") %in% list.files(directory) ) ){
      stop( paste0( directory, " is not a proper repository. There is neither backpack.db nor gallery." ) )
    }
  }
  # check if repoDir has "/" at the end and add it if not
#   if ( !grepl("/$", x = directory , perl=TRUE) ){
#     directory <- paste0(  directory, "/"  )
#   }
  return( directory )
}

# checkDirectory2 <- function( directory ){
#   check if repoDir has "/" at the end and add it if not
#   if ( !grepl("/$", x = directory , perl=TRUE) ){
#     directory <- paste0(  directory, "/"  )
#   }
#   return( directory )
# }