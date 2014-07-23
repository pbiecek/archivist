.onAttach <- function(...) {
  packageStartupMessage("\n Welcome to the archivist package (ver 0.x).",
                        "\n To start working, you need to build a database using: createEmptyRepo() ")
}
.ArchivistEnv <- new.env()

.onDetach <- function(libpath) {
  if (".backpack" %in% ls(.ArchivistEnv)) {
    tmp <- get(".backpack", envir = .ArchivistEnv)
    if (!is.null(tmp)) {
      dbDisconnect(tmp)
      assign(".backpack", NULL, envir = .ArchivistEnv)
    }
  } 
}
