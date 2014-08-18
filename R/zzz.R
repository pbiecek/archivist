.onAttach <- function(...) {
  packageStartupMessage( "\n Welcome to the archivist package (ver 0.1)." )
}
.ArchivistEnv <- new.env()

.GithubURL <- "https://raw.githubusercontent.com/"

# .onDetach <- function(libpath) {
#   if (".backpack" %in% ls(.ArchivistEnv)) {
#     tmp <- get(".backpack", envir = .ArchivistEnv)
#     if (!is.null(tmp)) {
#       dbDisconnect(tmp)
#       assign(".backpack", NULL, envir = .ArchivistEnv)
#     }
#   } 
# }


