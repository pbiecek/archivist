.ArchivistEnv <- new.env()

.onAttach <- function(...) {
  packageStartupMessage( "\n Welcome to the archivist package (ver 1.1)." )
  assign( x = "sqlite", value = dbDriver( "SQLite" ), envir = .ArchivistEnv )
  assign( x = ".GithubURL", value = "https://raw.githubusercontent.com/", envir = .ArchivistEnv )
}


.onDetach <- function( libpath ){
  dbUnloadDriver(get( "sqlite", envir = .ArchivistEnv )) 
}

## no S4 methodology here; speedup :
.noGenerics <- TRUE


