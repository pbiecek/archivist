.ArchivistEnv <- new.env()

setDefaultArchivistEnv <- function() {
  .ArchivistEnv$archiveData <-TRUE 
  .ArchivistEnv$archiveMiniature <- TRUE
  .ArchivistEnv$archiveSessionInfo <- FALSE
  .ArchivistEnv$archiveTags <- TRUE 
  .ArchivistEnv$ascii <- FALSE
  .ArchivistEnv$branch <- "master"
  .ArchivistEnv$chain <- FALSE 
  .ArchivistEnv$force <- TRUE
  .ArchivistEnv$subdir <- "/"
  .ArchivistEnv$repoType <- "github"
  .ArchivistEnv$silent <- TRUE
}

.onAttach <- function(...) {
   setDefaultArchivistEnv()
   packageStartupMessage("Welcome to archivist (version: ", utils::packageVersion("archivist"), ").")
}

.onLoad <- function(...) {
  setDefaultArchivistEnv()
  assign( x = "sqlite", value = dbDriver( "SQLite" ), envir = .ArchivistEnv )
  assign( x = ".GithubURL", value = "https://raw.githubusercontent.com", envir = .ArchivistEnv )
}

onUnload <- function( libpath ){
  dbUnloadDriver(get( "sqlite", envir = .ArchivistEnv )) 
}

## no S4 methodology here; speedup :
.noGenerics <- TRUE


