ddWelcomePage <- function(object, archiveDirs, md5hash) 
  UseMethod("ddWelcomePage")

ddWelcomePage.ggplot <- function(object, archiveDirs, md5hash) {
  # for github, add raw
  archiveRead <- gsub(archiveDirs$archiveRead, pattern="https://github", replacement="https://raw.github")
  archivePlotRead <- gsub(archiveDirs$archiveRead, pattern="graphGallery/master", replacement="graphGallery/tree/master")
    
  mlinks <- list.files(paste0(archiveDirs$archiveWrite, md5hash$hash), pattern="^miniature")
  mlinks2 <- paste0("<img src='", archiveRead, md5hash$hash, "/", mlinks, "'/>", collapse="<br/>")
  
  wplink <- paste0(archiveDirs$archiveWrite, md5hash$hash, "/index.html")
  cat("<html><body>
<img width=200px align='right' src='https://raw.github.com/pbiecek/archivist/master/graphics/Quill_PSFsmall.png'>",
      "<h1>Object ID: ",md5hash$hash,"</h1> <a href='",paste0(archiveRead, md5hash$hash, "/QRka.pdf"),"'>Get QRka code</a>",
      "<br><a href='http://smarterpoland.pl/QRka/set.php?ID=",md5hash$hash, "'>Push on The Wall</a>",
      "<h1>Tags</h1>",mtry(paste0(readLines(paste0(archiveDirs$archiveWrite, md5hash$hash, "/tags.txt")), collapse="<br>\n")),
      "<h1>Touch dates</h1>",mtry(paste0(readLines(paste0(archiveDirs$archiveWrite, md5hash$hash, "/touch.txt")), collapse="<br>\n")),
      "<hr/><h1>Miniatures</h1>",mlinks2,
      "<hr/><h1>Download object to R</h1>", paste0(readLines(paste0(archiveDirs$archiveWrite, md5hash$hash, "/load.html")), sep="\n"),
"</body>
</html>", file=wplink, sep="")
  wplink
}

ddWelcomePage.squad <- function(object, archiveDirs, md5hash) {
  # for github, add raw
  archiveRead <- gsub(archiveDirs$archiveRead, pattern="https://github", replacement="https://raw.github")
  archivePlotRead <- gsub(archiveDirs$archiveRead, pattern="graphGallery/master", replacement="graphGallery/tree/master")
  
  imgs <- paste0(sapply(object, function(x) {
    paste0("<a href='", archivePlotRead, unlist(x$link)[1], "'><img src='",archiveRead, 
           unlist(x$miniaturesLinks)[1], "'/></a><br>")
  }), collapse="\n")
  
  wplink <- paste0(archiveDirs$archiveWrite, md5hash$hash, "/index.html")
  cat("<html><body>
<img width=200px align='right' src='https://raw.github.com/pbiecek/archivist/master/graphics/Quill_PSFsmall.png'>",
      "<h1>Object ID: ",md5hash$hash,"</h1>",
      "<h1>Touch dates</h1>",mtry(paste0(readLines(paste0(archiveDirs$archiveWrite, md5hash$hash, "/touch.txt")), collapse="<br>\n")),
      "<hr/><h1>Miniatures</h1>",imgs,
      "<hr/><h1>Download object to R</h1>", paste0(readLines(paste0(archiveDirs$archiveWrite, md5hash$hash, "/load.html")), sep="\n"),
      "</body>
</html>", file=wplink)
  wplink
}


mtry <- function(expr) {
  re <- try(expr, silent=TRUE)
  if (class(re) == "try-error") return("")
  re
}
