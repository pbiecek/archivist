.ArchivistEnv <- new.env()

.onAttach <- function(...) {
  packageStartupMessage( "\n Welcome to the archivist package (ver 1.0)." )
  assign( x = "sqlite", value = dbDriver( "SQLite" ), envir = .ArchivistEnv )
  assign( x = ".GithubURL", value = "https://raw.githubusercontent.com/", envir = .ArchivistEnv )
}


.onDetach <- function( libpath ){
  dbUnloadDriver(get( "sqlite", envir = .ArchivistEnv )) 
#  rm(.ArchivistEnv)
#  rm(.GithubURL)
}
# .onDetach <- function(libpath) {
#   if (".backpack" %in% ls(.ArchivistEnv)) {
#     tmp <- get(".backpack", envir = .ArchivistEnv)
#     if (!is.null(tmp)) {
#       dbDisconnect(tmp)
#       assign(".backpack", NULL, envir = .ArchivistEnv)
#     }
#   } 
# }

## no S4 methodology here; speedup :
.noGenerics <- TRUE


