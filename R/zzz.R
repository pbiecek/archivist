.ArchivistEnv <- new.env()

.onLoad <- function(libname, pkgname) {
}

.onAttach <- function(libname, pkgname) {
  library("RSQLite")
  sqlite    <- dbDriver("SQLite")
  assign(".backpack", 
         dbConnect(sqlite,paste0(path.package("archivist"), "/database/backpack.db")), 
         envir = .ArchivistEnv)
}

.onDetach <- function(libpath) {
  dbDisconnect(get(".backpack", envir = .ArchivistEnv))
}

