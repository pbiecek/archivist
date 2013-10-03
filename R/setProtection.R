setProtection <- function(md5links, archiveWriteDir, period = months(1), fixedDate = now() + period) {
  require(lubridate)
  sapply(md5links, function(md5l) {
    cat(as.character(fixedDate), file=paste0(archiveWriteDir, md5l, "/protectionDate.txt"))
    as.character(fixedDate)
  })
}

