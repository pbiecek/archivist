setUpDatabase <- function() {
  library("RSQLite")
  library("lubridate")
  sqlite    <- dbDriver("SQLite")
  backpack <- dbConnect(sqlite,"database/backpack.db")
  
  artifact <- data.frame(md5hash = "", class = "", createdDate = now(), stringsAsFactors=FALSE)
  setting <- data.frame(name = c("localPath", "remotePath"), value=c("...", "..."), createdDate = now(), stringsAsFactors=FALSE)
  relation <- data.frame(artifactFrom = "", artifactTo = "", relationName = now(), stringsAsFactors=FALSE)
  tag <- data.frame(artifact = "", tag = "", relationName = now(), stringsAsFactors=FALSE)
  
  dbListTables(backpack)
  dbWriteTable(backpack,"artifact",artifact)
  dbWriteTable(backpack,"setting",setting)
  dbWriteTable(backpack,"relation",relation)
  dbWriteTable(backpack,"tag",tag)
  
}

