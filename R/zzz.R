.ArchivistEnv <- new.env()

setDefaultArchivistEnv <- function() {
  .ArchivistEnv$alink <- FALSE
  .ArchivistEnv$archiveData <-TRUE 
  .ArchivistEnv$archiveMiniature <- TRUE
  .ArchivistEnv$archiveSessionInfo <- FALSE
  .ArchivistEnv$archiveTags <- TRUE 
  .ArchivistEnv$ascii <- FALSE
  .ArchivistEnv$branch <- "master"
  .ArchivistEnv$chain <- FALSE 
  .ArchivistEnv$commitMessage <- NULL
  .ArchivistEnv$force <- TRUE
  .ArchivistEnv$rememberName <- TRUE 
  .ArchivistEnv$readmeDescription <- "A Repository of Artifacts supported by [archivist](https://github.com/pbiecek) \n\n
  [`Repository`](https://github.com/pbiecek/archivist/wiki/archivist-package-Repository) stores specific values of an artifact,
  different for various artifact's classes and artifacts themselves. To learn more about artifacts visit [wiki](https://github.com/pbiecek/archivist/wiki)."
  .ArchivistEnv$repoDescription <- "A Repository of Artifacts supported by archivist https://github.com/pbiecek"
  .ArchivistEnv$subdir <- FALSE
  .ArchivistEnv$repoType <- "github"
  .ArchivistEnv$response <- FALSE
  .ArchivistEnv$silent <- FALSE
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


