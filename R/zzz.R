.ArchivistEnv <- new.env()

.onLoad <- function(libname, pkgname) {
  library("RSQLite")
  sqlite    <- dbDriver("SQLite")
  assign(".backpack", 
         dbConnect(sqlite,paste0(path.package("archivist"), "/database/backpack.db")), 
         envir = .ArchivistEnv)
  
}
.onAttach <- function(libname, pkgname) {
  .onLoad(libname, pkgname)  
}

.onDetach <- function(libpath) {
  dbDisconnect(get(".backpack", envir = .ArchivistEnv))
}

