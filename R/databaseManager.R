setUpDatabase <- function() {
  library("RSQLite")
  library("lubridate")
  sqlite    <- dbDriver("SQLite")
  backpack <- dbConnect(sqlite,"database/backpack.db")
  
  artifact <- data.frame(md5hash = "", 
                         class = "", 
                         createdDate = now(), 
                         pathToWelcomePage = ""
                         stringsAsFactors=FALSE)
  
  relation <- data.frame(artifactFrom = "", artifactTo = "", relationName = now(), stringsAsFactors=FALSE)
  tag <- data.frame(artifact = "", tag = "", relationName = now(), stringsAsFactors=FALSE)

  setting <- data.frame(name = c("localPathToArchive",
                                 "externalPathToArchive",
                                 "miniatureFormat",
                                 "miniatureWidth",
                                 "miniatureHeight"), 
                        value=c("/Users/pbiecek/camtasia/GitHub/graphGallery/", 
                                "https://github.com/pbiecek/graphGallery/master/",
                                "png",
                                "800",
                                "600"), 
                        createdDate = now(), stringsAsFactors=FALSE)
  
  
  
  
  dbListTables(backpack)
  dbWriteTable(backpack, "artifact",artifact, overwrite=TRUE)
  dbWriteTable(backpack, "setting",setting, overwrite=TRUE)
  dbWriteTable(backpack, "relation",relation, overwrite=TRUE)
  dbWriteTable(backpack, "tag",tag, overwrite=TRUE)
  
  
  dbGetQuery(backpack, "select * from setting")
  
  
}

