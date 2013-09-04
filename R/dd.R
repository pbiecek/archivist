
dd <- function (object, archiveWrite = "./", archiveRead = archiveWrite,  ...) 
  UseMethod("dd")

dd.default <- function(object, archiveWrite = "./", archiveRead = archiveWrite, ...) {
  md5hash <- digest(object)
  dir.create(file.path(archiveWrite, md5hash), showWarnings = FALSE)
  
  cat(file = paste0(archiveWrite, md5hash, "/load.R"), ddrescueInstructions(object, archiveRead, md5hash) )
  sink(file = paste0(archiveWrite, md5hash, "/load.html"))
  highlight::highlight(paste0(archiveWrite, md5hash, "/load.R"), detective = simple_detective, renderer = renderer_html( document = TRUE ))
  sink()
  list(hash = md5hash, ref = paste0(archiveRead, md5hash))
}

dd.data.frame <- function(object, archiveWrite = "./", archiveRead = archiveWrite, ...) {
  md5hash <- dd.default(object, archiveWrite, archiveRead, ...)
  save(file = paste0(archiveWrite, md5hash$hash, "/df.rda"), object, ascii=TRUE)
  list(data.hash = md5hash[[1]], data.ref = paste0(archiveRead, md5hash[[1]]))
}

dd.ggplot <- function(object, archiveWrite = "./", archiveRead = archiveWrite, ..., archiveData = FALSE,  archiveWriteData = archiveWrite, archiveReadData = archiveRead) {
  md5hash <- dd.default(object, archiveWrite, archiveRead, ...)
  save(file = paste0(archiveWrite, md5hash[[1]], "/plot.rda"), object, ascii=TRUE)
  if (archiveData) {
    md5hash2 <- dd(object$data, archiveWriteData, archiveReadData)[[1]]
    return(list(plot.hash = md5hash[[1]], plot.ref = paste0(archiveRead, md5hash[[1]]),
                data.hash = md5hash2[[1]], data.ref = paste0(archiveRead, md5hash2[[1]])))
  }
  list(plot.hash = md5hash[[1]], plot.ref = paste0(archiveRead, md5hash[[1]]))
}
