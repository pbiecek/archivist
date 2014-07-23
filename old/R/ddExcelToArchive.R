ddExcelToArchive <- function(filePath, archiveDirs, tags = NULL) {
  md5hash <- digest(readBin(filePath, raw(), 10^7))
  
  dir.create(file.path(archiveDirs$archiveWrite, md5hash), showWarnings = FALSE)
  
  file.copy(filePath, paste0(archiveDirs$archiveWrite, md5hash,"/excel.xlsx"))
  ffnn <- tail(strsplit(filePath, split="/")[[1]],1)
  file.copy(filePath, paste0(archiveDirs$archiveWrite, md5hash,"/",ffnn))
  #
  # add access date
  now <- as.character(Sys.time())
  cat(file = paste0(archiveDirs$archiveWrite, md5hash, "/touch.txt"), now, "\n", append=TRUE)
  #
  # add class
  cat(file = paste0(archiveDirs$archiveWrite, md5hash, "/class.txt"), "ExcelFile")
  #
  # save tags
  if (!is.null(tags)) {
    cat(file = paste0(archiveDirs$archiveWrite, md5hash, "/tags.txt"), paste(tags , collapse="\n"))
  }
  #
  # add to object history
  cat(now, md5hash, paste0("ExcelFile", collapse=",") ,"\n", file=paste0(archiveDirs$archiveWrite, "/list.txt"), append=TRUE, sep=";")
  
  #
  # save miniatures
  writeBin(readBin(unz(filePath, "docProps/thumbnail.jpeg", open="rb"), raw(), n=10^6), 
           paste0(archiveDirs$archiveWrite, md5hash, "/miniature_Excel.jpeg"))
  
  # for github, add raw
  archiveRead <- gsub(archiveDirs$archiveRead, pattern="https://github", replacement="https://raw.github")
  archivePlotRead <- gsub(archiveDirs$archiveRead, pattern="graphGallery/master", replacement="graphGallery/tree/master")
  
  mlinks <- list.files(paste0(archiveDirs$archiveWrite, md5hash), pattern="^miniature")
  mlinks2 <- paste0("<img src='", archiveRead, md5hash, "/", mlinks, "'/>", collapse="<br/>")
  
  wplink <- paste0(archiveDirs$archiveWrite, md5hash, "/index.html")
  cat("<html><body>
<img width=200px align='right' src='https://raw.github.com/pbiecek/archivist/master/graphics/Quill_PSFsmall.png'>",
      "<h1>Object ID: ",md5hash,"</h1> ",
      "<a href='http://smarterpoland.pl/QRka/set.php?ID=",md5hash, "'>Push on The Wall</a><br>",
      "<a href='",paste0(archiveRead, md5hash,"/",ffnn), "'>Download Excel</a>",
      "<hr/><h1>Miniatures</h1>",mlinks2,
      "<h1>Tags</h1>",mtry(paste0(readLines(paste0(archiveDirs$archiveWrite, md5hash, "/tags.txt")), collapse="<br>\n")),
      "<h1>Touch dates</h1>",mtry(paste0(readLines(paste0(archiveDirs$archiveWrite, md5hash, "/touch.txt")), collapse="<br>\n")),
      "</body>
</html>", file=wplink, sep="")
  
  list(hash = md5hash, ref = paste0(archiveDirs$archiveRead, md5hash), welcomePage = wplinks)
}
