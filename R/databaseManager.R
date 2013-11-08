#
# przeneisc baze do galerii a nie trzymac jej w pakiecie
# dodac funkcje inicjujaca polaczenie z baza
# do uruchomieniu na starcie galerii

setUpDatabase <- function() {
  library("RSQLite")
  library("lubridate")
  sqlite    <- dbDriver("SQLite")
  backpack <- dbConnect(sqlite,"inst/extdata/backpack.db")
  
  artifact <- data.frame(md5hash = "",
                         name = "",
                         class = "", 
                         createdDate = as.character(now()), 
                         pathToWelcomePage = "",
                         stringsAsFactors=FALSE)
  
  relation <- data.frame(artifactFrom = "", artifactTo = "", relationName = "", stringsAsFactors=FALSE)
  tag <- data.frame(artifact = "", tag = "", timestamp = as.character(now()), stringsAsFactors=FALSE)

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
                        createdDate = as.character(now()), stringsAsFactors=FALSE)
  
  dbListTables(backpack)
  dbWriteTable(backpack, "artifact",artifact, overwrite=TRUE)
  dbWriteTable(backpack, "setting",setting, overwrite=TRUE)
  dbWriteTable(backpack, "relation",relation, overwrite=TRUE)
  dbWriteTable(backpack, "tag",tag, overwrite=TRUE)
  
  dbGetQuery(backpack, "select * from setting")
  dbGetQuery(backpack, "select * from artifact")
  dbGetQuery(backpack, "select * from tag")
  dbGetQuery(backpack, "select * from relation")
  
  dbGetQuery(backpack, "delete from artifact")
  dbGetQuery(backpack, "delete from tag")
  dbGetQuery(backpack, "delete from relation")
  
  dbDisconnect(backpack)
}

setSettingsWrapper <- function(name = "localPathToArchive", value = "") {
  dbGetQuery(getBackpack(), 
             paste0("insert into setting (name, value, createdDate) values ", 
                    "('",name,"', '", value,"', '", as.character(now()), "')"))
}

settingsWrapper <- function(name = "localPathToArchive") {
  dbGetQuery(getBackpack(), 
             paste0("select value from setting where name='", 
                    name
                    , "' order by createdDate"))[1,1]
}

addArtifact <- function(md5hash, name, class, pathToWelcomePage, createdDate = now()) {
  dbGetQuery(getBackpack(), 
             paste0("insert into artifact (md5hash, name, class, pathToWelcomePage, createdDate) values ", 
                    "('",md5hash,"', '", name,"', '", class,"', '", pathToWelcomePage,"', '", as.character(createdDate), "')"))
}

addRelation <- function(artifactFrom, artifactTo, relationName) {
  dbGetQuery(getBackpack(), 
             paste0("insert into relation (artifactFrom, artifactTo, relationName) values ", 
                    "('",artifactFrom,"', '", artifactTo,"', '", relationName,"')"))
}

addTag <- function(md5hash, tag, timestamp = now()) {
  dbGetQuery(getBackpack(), 
             paste0("insert into tag (artifact, tag, timestamp) values ", 
                    "('",md5hash,"', '", tag,"', '", as.character(timestamp),"')"))
}


getBackpack <- function() {
  if (".backpack" %in% ls(.ArchivistEnv)) {
    return(get(".backpack", envir = .ArchivistEnv))
  } 
  
  require("RSQLite")
  sqlite    <- dbDriver("SQLite")
  assign(".backpack", 
         dbConnect(sqlite,paste0(path.package("archivist"), "/extdata/backpack.db")), 
         envir = .ArchivistEnv)
  get(".backpack", envir = .ArchivistEnv)
  
}

