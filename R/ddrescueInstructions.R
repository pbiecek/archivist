ddrescueInstructions <- function(object, archiveRead, md5hash) 
  UseMethod("ddrescueInstructions")

ddrescueInstructions.ggplot <- function(object, archiveRead, md5hash) {
  # for github, add raw.
  archiveRead <- gsub(archiveRead, pattern="https://github", replacement="https://raw.github")
  
  paste0('
# load plot from archive
library(ggplot2)
library(RCurl)
tmpobject <- getBinaryURL("',archiveRead,md5hash,'/plot.rda")
tf <- tempfile()
writeBin(tmpobject, tf)
(name <- load(tf))
unlink(tf)
tmpobject <- NULL
# get(name)
')
}

ddrescueInstructions.squad <- function(object, archiveRead, md5hash) {
  # for github, add raw.
  archiveRead <- gsub(archiveRead, pattern="https://github", replacement="https://raw.github")
  
  paste0('
# load plot from archive
library(ggplot2)
library(RCurl)
tmpobject <- getBinaryURL("',archiveRead,md5hash,'/squad.rda")
tf <- tempfile()
writeBin(tmpobject, tf)
(name <- load(tf))
unlink(tf)
tmpobject <- NULL
# get(name)
')
}

ddrescueInstructions.data.frame <- function(object, archiveRead, md5hash) {
  archiveRead <- gsub(archiveRead, pattern="https://github", replacement="https://raw.github")

paste0('
 # load data grame from archive
 library(RCurl)
 tmpobject <- getBinaryURL("',archiveRead,md5hash,'/df.rda")
 tf <- tempfile()
 writeBin(tmpobject, tf)
 (name <- load(tf))
 unlink(tf)
 tmpobject <- NULL
 # get(name)
 ')
}
