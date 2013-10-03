setProtection <- function(md5links, archiveWriteDir, period = days(1), fixed = NULL) {
  require(lubridate)
  till <- now()
  if (is.null(fixed)) {
    till <- fixed
  } else {
    till <- now() + period
  }
  sapply(md5links, function(md5l) {
    cat(as.character(till), file=paste0(archiveWriteDir, md5l, "/protectionDate.txt"))
    as.character(till)
  })
}

