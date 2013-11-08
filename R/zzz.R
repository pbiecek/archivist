.ArchivistEnv <- new.env()

.onLoad <- function(libname, pkgname) {
  library("RSQLite")
  sqlite    <- dbDriver("SQLite")
  browser()
  assign(".backpack", 
         dbConnect(sqlite,paste0(libname, "/database/backpack.db")), 
         envir = .ArchivistEnv)
  
}
.onAttach <- function(libname, pkgname) {
  .onLoad(libname, pkgname)  
}

.onDetach <- function(libpath) {
  dbDisconnect(get(".backpack", envir = .ArchivistEnv))
}

