ddWelcomePage <- function(object, archiveDirs, md5hash) 
  UseMethod("ddWelcomePage")

ddWelcomePage.ggplot <- function(object, archiveDirs, md5hash) {
  # for github, add raw
  archiveDirs$archiveRead <- gsub(archiveDirs$archiveRead, pattern="https://github", replacement="https://raw.github")
  archiveDirs$archivePlotRead <- gsub(archiveDirs$archivePlotRead, pattern="graphGallery/master", replacement="graphGallery/tree/master")
    
  wplink <- paste0(archiveDirs$archiveWrite, md5hash$hash, "/index.html")
  cat("<html>
<body>
<img src=''>
</body>
</html>", file=wplink)
  wplink
}

ddWelcomePage.squad <- function(object, archiveDirs, md5hash) {
  # for github, add raw
  archiveDirs$archiveRead <- gsub(archiveDirs$archiveRead, pattern="https://github", replacement="https://raw.github")
  archiveDirs$archivePlotRead <- gsub(archiveDirs$archivePlotRead, pattern="graphGallery/master", replacement="graphGallery/tree/master")
  
  imgs <- paste0(sapply(object, function(x) {
    paste0("<a href='", archiveDirs$archivePlotRead, unlist(x$link)[1], "'><img src='",archiveDirs$archiveRead, unlist(x$miniaturesLinks)[1], "'/></a><br>")
  }), collapse="\n")
  
  wplink <- paste0(archiveDirs$archiveWrite, md5hash$hash, "/index.html")
  cat(imgs, file=wplink)
  wplink
}
