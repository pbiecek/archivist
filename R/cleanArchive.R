# remove directories without protectionDate.txt
# or with older date than dueDate
cleanArchive <- function(archiveDirs, dueDate = now(), really = FALSE) {
  if (!really) return()
  archiveWriteDir <- archiveDirs$archiveWrite
  require(lubridate)
  md5links <- list.files(archiveWriteDir)
  sapply(md5links, function(md5l) {
    if (file.exists(paste0(archiveWriteDir, md5l, "/protectionDate.txt"))) {
      suppressWarnings(content <- readLines(paste0(archiveWriteDir, md5l, "/protectionDate.txt")))
      res <- try(as.POSIXct(content) - dueDate > 0, silent=TRUE)
      if (class(res) != "try-error" && length(res)>0 && res) {
        return(paste0("protected till ",content))
      } else { # remove, protection expired
        unlink(paste0(archiveWriteDir, md5l), recursive = TRUE)
        return("removed, protection expired")
      }
    } else { # remove, no protection
      unlink(paste0(archiveWriteDir, md5l), recursive = TRUE)
      return("removed, no protection")
    }
  })
}
