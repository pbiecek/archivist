ddrescueInstructions <- function(object, archiveRead, md5hash) 
  UseMethod("ddrescueInstructions")

ddrescueInstructions.ggplot <- function(object, archiveRead, md5hash) {
  paste0('
# load plot from archive
library(ggplot2)
library(RCurl)
tmpobject <- getBinaryURL("',archiveRead,md5hash,'/plot.rda")
tf <- tempfile()
writeBin(tmpobject, tf)
(name <- load(tf))
unlink(tf)
get(name)
')
}

ddrescueInstructions.data.frame <- function(object, archiveRead, md5hash) {
  paste0('
 # load data grame from archive
 library(RCurl)
 tmpobject <- getBinaryURL("',archiveRead,md5hash,'/df.rda")
 tf <- tempfile()
 writeBin(tmpobject, tf)
 (name <- load(tf))
 unlink(tf)
 get(name)
 ')
}
