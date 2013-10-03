ddWelcomePage <- function(object, archiveWrite, archiveRead, archivePlotRead=archiveRead, md5hash) 
  UseMethod("ddWelcomePage")

ddWelcomePage.squad <- function(object, archiveWrite, archiveRead, archivePlotRead=archiveRead, md5hash) {
  # for github, add raw.
  archiveRead <- gsub(archiveRead, pattern="https://github", replacement="https://raw.github")
  
  imgs <- paste0(sapply(object, function(x) {
    paste0("<a href='", archivePlotRead, unlist(x$link)[1], "'><img src='",archiveRead, unlist(x$miniaturesLinks)[1], "'/></a><br>")
  }), collapse="\n")
  
  wplink <- paste0(archiveWrite, md5hash$hash, "/index.html")
  cat(imgs, file=wplink)
  wplink
}
