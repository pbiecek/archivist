createMiniature <- function (object, md5hash, ... )
  UseMethod("createMiniature")

createMiniature.default <- function(object, md5hash, ...) {
}
  
createMiniature.data.frame <- function(object, md5hash, ...., firstRows = 6) {
  writeDir <- settingsWrapper("localPathToArchive")
  sink(file = paste0(writeDir, md5hash, "/summary.txt"))
  print(head(object, firstRows))
  sink()
}

createMiniature.lm <- function(object, md5hash) {
  writeDir <- settingsWrapper("localPathToArchive")
  sink(file = paste0(writeDir, md5hash, "/summary.txt"))
  print(summary(object))
  sink()
}

createMiniature.ggplot <- function(object, md5hash) {
  writeDir <- settingsWrapper("localPathToArchive")
  format <- settingsWrapper("miniatureFormat")
  width <- as.numeric(settingsWrapper("miniatureWidth"))
  height <- as.numeric(settingsWrapper("miniatureHeight"))
  
  # get function from it's name
  fun <- get(format)
  fun(paste0(writeDir, md5hash, "/miniature.", format), width, height)
  print(object)
  dev.off()
}
