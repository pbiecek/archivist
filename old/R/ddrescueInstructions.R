ddrescueInstructions <- function(object, md5hash) {
  # for github, add raw.
  readDir <- settingsWrapper("externalPathToArchive")
  archiveRead <- gsub(readDir, pattern="https://github", replacement="https://raw.github")
  
  paste0('
# load plot from archive
library(RCurl)
tmpobject <- getBinaryURL("',archiveRead,md5hash,'/object.rda")
tf <- tempfile()
writeBin(tmpobject, tf)
(name <- load(tf))
unlink(tf)
tmpobject <- NULL
')
}

