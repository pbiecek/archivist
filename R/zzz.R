library("RSQLite")
sqlite    <- dbDriver("SQLite")

.ArchivistEnv <- new.env()
assign(".backpack", 
       dbConnect(sqlite,paste0(path.package("archivist"), "/database/backpack.db")), 
       envir = .ArchivistEnv)
