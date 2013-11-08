.ArchivistEnv <- new.env()

.onDetach <- function(libpath) {
  tmp <- get(".backpack", envir = .ArchivistEnv)
  if (!is.null(tmp)) {
    dbDisconnect(tmp)
    assign(".backpack", NULL, envir = .ArchivistEnv)
  }
}
