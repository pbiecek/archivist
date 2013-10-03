ddWelcomePage <- function(object, archiveRead, archivePlotRead=archiveRead, md5hash, miniaturesLink) 
  UseMethod("ddWelcomePage")

ddWelcomePage.squad <- function(object, archiveRead, archivePlotRead=archiveRead, md5hash, miniaturesLink) {
  # for github, add raw.
  archiveRead <- gsub(archiveRead, pattern="https://github", replacement="https://raw.github")
  
  miniaturesLink <- c("f31976aaa933494a9ff5052acd1d37cf/miniature_adb51ea4e0d76bb592ff96cb834dd341_500_500.png",
                      "f31976aaa933494a9ff5052acd1d37cf/miniature_8d8eeaeab18d3650bb74162ff7e5405b_500_500.png")

  sapply(miniaturesLink, function(x) {
    paste0("<a href='", archivePlotRead,"'><img src='",archiveRead, x, "/></a><br>")
  })
  paste0('# load plot from archive
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
