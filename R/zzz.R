.ArchivistEnv <- new.env()

setDefaultArchivistEnv <- function() {
  .ArchivistEnv$silent <- FALSE
  .ArchivistEnv$response <- FALSE
  .ArchivistEnv$commitMessage <- NULL
  .ArchivistEnv$archiveData <-TRUE 
  .ArchivistEnv$archiveTags <- TRUE 
  .ArchivistEnv$archiveMiniature <- TRUE
  .ArchivistEnv$archiveSessionInfo <- FALSE
  .ArchivistEnv$force <- TRUE
  .ArchivistEnv$rememberName <- TRUE 
  .ArchivistEnv$chain <- FALSE 
  .ArchivistEnv$ascii <- FALSE
  .ArchivistEnv$branch <- "master"
  .ArchivistEnv$repoDirGit <- FALSE
  .ArchivistEnv$alink <- FALSE
  .ArchivistEnv$repoDescription <- "A Repository of Artifacts supported by archivist https://github.com/pbiecek"
  .ArchivistEnv$readmeDescription <- .ArchivistEnv$readmeDescription <- "A Repository of Artifacts supported by [archivist](https://github.com/pbiecek) \n\n
  [`Repository`](https://github.com/pbiecek/archivist/wiki/archivist-package-Repository) stores specific values of an artifact,
  different for various artifact's classes and artifacts themselves. To learn more about artifacts visit [wiki](https://github.com/pbiecek/archivist/wiki)."
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


