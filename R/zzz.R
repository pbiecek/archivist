.ArchivistEnv <- new.env()

.onAttach <- function(...) {
   packageStartupMessage("Welcome to archivist (version: ", utils::packageVersion("archivist"), ").")
  .ArchivistEnv$silent <- FALSE
}

.onLoad <- function(...) {
  assign( x = "sqlite", value = dbDriver( "SQLite" ), envir = .ArchivistEnv )
  assign( x = ".GithubURL", value = "https://raw.githubusercontent.com/", envir = .ArchivistEnv )
  .ArchivistEnv$silent <- FALSE
}

onUnload <- function( libpath ){
  dbUnloadDriver(get( "sqlite", envir = .ArchivistEnv )) 
}

## no S4 methodology here; speedup :
.noGenerics <- TRUE


