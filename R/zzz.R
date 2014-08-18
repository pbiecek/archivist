.onAttach <- function(...) {
  packageStartupMessage( "\n Welcome to the archivist package (ver 0.1)." )
}
.ArchivistEnv <- new.env()

.GithubURL <- "https://raw.githubusercontent.com/"
library( "RSQLite" )
assign( x = "sqlite", value = dbDriver( "SQLite" ), envir = .ArchivistEnv )

.onDetach <- function( libpath ){
  rm(.ArchivistEnv)
  rm(.GithubURL)
  rm(.sqlite)
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


