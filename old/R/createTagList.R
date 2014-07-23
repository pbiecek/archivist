createTagList <- function(archiveDirs) {
  md5links <- list.files(archiveDirs$archiveWrite)
  tags <- na.omit(sapply(md5links, function(md5l) {
    if (file.exists(paste0(archiveDirs$archiveWrit, md5l, "/index.html")) &&
          file.exists(paste0(archiveDirs$archiveWrit, md5l, "/tags.txt"))) {
      suppressWarnings(content1 <- paste(readLines(paste0(archiveDirs$archiveWrit, md5l, "/tags.txt")), collapse=" "))
      suppressWarnings(content2 <- paste(readLines(paste0(archiveDirs$archiveWrit, md5l, "/class.txt")), collapse=" "))
      set <- strsplit(gsub(paste(content1, content2), pattern="[^0-9A-Za-z\\._]", replacement= " "), split=" ")[[1]]
      set[set != ""]
    } else {
      NULL
    }
  }))
  utags <- paste0('var availableTags = [\n"', paste0(sort(tolower(unique(unlist(tags)))), collapse='", "'), '"];\n')

  tagLines <- na.omit(sapply(md5links, function(md5l) {
    if (file.exists(paste0(archiveDirs$archiveWrit, md5l, "/index.html")) &&
          file.exists(paste0(archiveDirs$archiveWrit, md5l, "/tags.txt"))) {
      suppressWarnings(content1 <- paste(readLines(paste0(archiveDirs$archiveWrit, md5l, "/tags.txt")), collapse=" "))
      suppressWarnings(content2 <- paste(readLines(paste0(archiveDirs$archiveWrit, md5l, "/class.txt")), collapse=" "))
      set <- strsplit(gsub(paste(content1, content2), pattern="[^0-9A-Za-z\\._]", replacement= " "), split=" ")[[1]]
      paste(set[set != ""], collapse=";")
    } else {
      NA
    }
  }))
  mini <- na.omit(sapply(md5links, function(md5l) {
    if (file.exists(paste0(archiveDirs$archiveWrit, md5l, "/index.html")) &&
          file.exists(paste0(archiveDirs$archiveWrit, md5l, "/tags.txt"))) {
      paste0(md5l,"/",list.files(paste0(archiveDirs$archiveWrite, md5l), pattern="^miniat")[1])
    } else NA
  }))
  uLines <- paste0(names(mini), " ", mini, " ", tagLines, "\n")
  list(utags = utags, uLines = uLines)
}
