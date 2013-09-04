
dd <- function (object, archiveWrite = "./", archiveRead = archiveWrite,  ...) 
  UseMethod("dd")

dd.default <- function(object, archiveWrite = "./", archiveRead = archiveWrite, ...) {
  md5hash <- digest(object)
  dir.create(file.path(archiveWrite, md5hash), showWarnings = FALSE)
  
  cat(file = paste0(archiveWrite, md5hash, "/load.R"), ddrescueInstructions(object, archiveRead, md5hash) )
  sink(file = paste0(archiveWrite, md5hash, "/load.html"))
  highlight::highlight(paste0(archiveWrite, md5hash, "/load.R"), detective = simple_detective, renderer = renderer_html( document = TRUE ))
  sink()
  list(md5hash)
}

dd.data.frame <- function(object, archiveWrite = "./", archiveRead = archiveWrite, ...) {
  md5hash <- dd.default(object, archiveWrite, archiveRead, ...)[[1]]
  save(file = paste0(archiveWrite, md5hash, "/df.rda"), object, ascii=TRUE)
  list(data = md5hash)
}

dd.ggplot <- function(object, archiveWrite = "./", archiveRead = archiveWrite, ..., archiveData = FALSE,  archiveWriteData = archiveWrite, archiveReadData = archiveRead) {
  md5hash <- dd.default(object, archiveWrite, archiveRead, ...)[[1]]
  save(file = paste0(archiveWrite, md5hash, "/plot.rda"), object, ascii=TRUE)
  if (archiveData) {
    md5hash2 <- dd(object$data, archiveWriteData, archiveReadData)
    return(list(plot = md5hash, data = md5hash2))
  }
  list(plot = md5hash)
}
