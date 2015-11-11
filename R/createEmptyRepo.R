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
#'  \code{Archivist Integration With GitHub API} visit \link{archivist-github-integration}.
#' 
#' 
#' @details
#' At least one Repository must be initialized before using other functions from the \pkg{archivist} package. 
#' While working in groups, it is highly recommended to create a Repository on a shared Dropbox/Git folder.
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
#' @param repoDir A character that specifies the directory for the Repository which is to be made.
#' 
#' @param force If \code{force = TRUE} and \code{repoDir} parameter specifies the directory that doesn't exist,
#' then function call will force to create new \code{repoDir} directory.
#' Default set to \code{force = TRUE}.
#' 
#' @param default If \code{default = TRUE} then \code{repoDir} is set as default local repository.
#' 
#' @param repoName While working with a Github repository. A character denoting new GitHub repository name. White spaces will be substitued with a dash.
#' @param github_token While working with a Github repository. An OAuth GitHub Token created with the \link{oauth2.0_token} function. See \link{archivist-github-integration}.
#' Can be set globally with \code{aoptions("github_token", github_token)}.
#' @param repoDescription While working with a Github repository. A character specifing the new GitHub repository description.
#' @param user.name While working with a Github repository. A character denoting GitHub user name. Can be set globally with \code{aoptions("user.name", user.name)}.
#'  See \link{archivist-github-integration}.
#' @param user.password While working with a Github repository. A character denoting GitHub user password. Can be set globally with \code{aoptions("user.password", user.password)}.
#' See \link{archivist-github-integration}.
#' @param readmeDescription While working with a Github repository. A character of the content of \code{README.md} file. By default a description of \link{Repository}.
#' Can be set globally with \code{aoptions("readmeDescription", readmeDescription)}. For no \code{README.md} file 
#' set \code{aoptions("readmeDescription", NULL)}.
#' @param response A logical value. Should the GitHub API response should be returned.
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
#' aoptions("user.name", user.name)
#' aoptions("user.password", user.password)
#' 
#' createEmptyGithubRepo("Museum")
#' createEmptyGithubRepo("Museum-Extras", response = TRUE)
#' createEmptyGithubRepo("Gallery", readmeDescription = NULL)
#' createEmptyGithubRepo("Landfill", repoDescription = "My models and stuff") 
#' }
#' @family archivist
#' @rdname createEmptyRepo
#' @export
createEmptyRepo <- function( repoDir, force = TRUE, default = FALSE,
                             repoName,
                             github_token = aoptions("github_token"), 
                             user.name = aoptions("user.name"),
                             #user.email = aoptions("user.email"),
                             user.password = aoptions("user.password"),
                             repoDescription = aoptions("repoDescription"),
                             readmeDescription = aoptions("readmeDescription"),
                             response = aoptions("response"),
                             type = "local"){
  stopifnot(is.character(type) & length(type) ==1 & type %in% c("local", "github"))
  if (type == "local") {
    createEmptyLocalRepo(repoDir = repoDir, force = force, default = default)
  } else {
    createEmptyGithubRepo(repoName = repoName,
                          github_token = github_token,
                          user.name = user.name,
                          user.password = user.password,
                          repoDescription = repoDescription,
                          readmeDescription = readmeDescription,
                          response = response)
  }
  
}

#' @rdname createEmptyRepo
#' @export
createEmptyLocalRepo <- function( repoDir, force = TRUE, default = FALSE){
  stopifnot( is.character( repoDir ) )
  
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
createEmptyGithubRepo <- function(repoName,
                                  github_token = aoptions("github_token"), 
                                  user.name = aoptions("user.name"),
                                  #user.email = aoptions("user.email"),
                                  user.password = aoptions("user.password"),
                                  repoDescription = aoptions("repoDescription"),
                                  readmeDescription = aoptions("readmeDescription"),
                                  response = aoptions("response")){
  stopifnot(is.character(repoName) & length(repoName) ==1)
  stopifnot(is.character(repoDescription) & length(repoDescription) ==1)
  #stopifnot(any(class(github_token) %in% "Token"))
  stopifnot(is.character(user.name) & length(user.name)==1)
  #stopifnot(is.character(user.email) & length(user.email)==1)
  stopifnot(is.character(user.password) & length(user.password)==1)
  stopifnot((is.character(readmeDescription) & length(readmeDescription)==1) |
              is.null(readmeDescription))
  
  repoName <- gsub(pattern = " ", "-", repoName)
  
  # httr imports are in archivist-package.R file
  # creating an empty GitHub Repository
  POST(url = "https://api.github.com/user/repos",
       encode = "json",
       body = list(
         name = jsonlite::unbox(repoName),
         description = jsonlite::unbox(repoDescription)
       ),
       config = httr::config(token = github_token)
  ) -> resp
  
  
  # git2r imports are in the archivist-package.R
  path <- repoName
  dir.create(path)
  
  # initialize local git repository
  # git init
  repo <- init(path)
  
  ## Create and configure a user
  # git config - added to Note section
  #git2r::config(repo, ...) # if about to use, the add to archivist-package.R
  
  # archivist-like Repository creation
  createEmptyRepo(repoDir = path)
  file.create(file.path(path, "gallery", ".gitkeep"))
  # git add
  if (!is.null(readmeDescription)){
    file.create(file.path(path, "README.md"))
    writeLines(aoptions("readmeDescription"), file.path(path, "README.md"))
    add(repo, c("backpack.db", "gallery/", "README.md"))
  } else {
    add(repo, c("backpack.db", "gallery/"))
  }
  
  # git commit
  new_commit <- commit(repo, "archivist Repository creation.")
  
  # association of the local and GitHub git repository
  # git add remote
  remote_add(repo,
             "upstream2",
             paste0("https://github.com/", user.name, "/", repoName, ".git"))
  
  # GitHub authorization
  # to perform pull and push operations
  cred <- git2r::cred_user_pass(user.name,
                         user.password)
  
  # push archivist-like Repository to GitHub repository
  push(repo,
       name = "upstream2",
       refspec = "refs/heads/master",
       credentials = cred)
  
  if (response){
    return(resp)
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
                     "('", md5hash, "', '", tag, "', '", as.character( now() ), "')" ) )
}

# realDBname was needed because Github version function uses temporary file as database
# and they do not name this file as backpack.db in repoDir directory
getConnectionToDB <- function( repoDir, realDBname ){
    if ( realDBname ){
      conn <- dbConnect( get( "sqlite", envir = .ArchivistEnv ), paste0( repoDir, "backpack.db" ) )
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

# for Github version funtion tha require to load database
downloadDB <- function( repo, user, branch, repoDirGit ){
   if( is.logical( repoDirGit ) ){
     URLdb <- paste0( get( ".GithubURL", envir = .ArchivistEnv) , user, "/", repo, "/", branch, "/backpack.db") 
   }else{
     URLdb <- paste0( get( ".GithubURL", envir = .ArchivistEnv) , user, "/", repo, "/", branch, "/", repoDirGit, "/backpack.db") 
   }
   if (url.exists(URLdb)){
     db <- getBinaryURL( URLdb )
     Temp2 <- tempfile()
     file.create( Temp2 )
     writeBin( db, Temp2 )
     return( Temp2 )
   } else {
     stop(paste0("Such a repo: ", repo, " or user ", user, " or branch ", branch, " does not exist on Github"))
   }
     
}

checkDirectory <- function( directory, create = FALSE ){
  # check if global repository was specified by setLocalRepo
  if ( is.null(directory) ){

    directory <- aoptions("repoDir")
  }
  # check whether it is second call of checkDirectory 
  # (e.g CreatEmptyRepo + default = TRUE)
  if ( grepl("/$", x = directory , perl=TRUE) ){
    directory <- gsub(pattern = ".$", replacement = "",
                      x = directory, perl = TRUE)
  }
  # check property of directory
  if ( !create ){
    # check whether repository exists
    if ( !file.exists( directory ) ){
      stop( paste0( "There is no such repository as ", directory ) )
    }
    # check if repository is proper (has backpack.db and gallery)
    if ( !all( c("backpack.db", "gallery") %in% list.files(directory) ) ){
      stop( paste0( directory, " is not a proper repository. There is neither backpack.db or gallery." ) )
    }
  }
  # check if repoDir has "/" at the end and add it if not
  if ( !grepl("/$", x = directory , perl=TRUE) ){
    directory <- paste0(  directory, "/"  )
  }
  return( directory )
}



checkDirectory2 <- function( directory ){
  # check if repoDir has "/" at the end and add it if not
  if ( !grepl("/$", x = directory , perl=TRUE) ){
    directory <- paste0(  directory, "/"  )
  }
  return( directory )
}



