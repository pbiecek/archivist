dd <- function (object, archiveWrite = "./", archiveRead = archiveWrite,  ... )
  UseMethod("dd")


dd.default <- function(object, archiveWrite = "./", archiveRead = archiveWrite, ...) {
  md5hash <- digest(object)
  dir.create(file.path(archiveWrite, md5hash), showWarnings = FALSE)
  
  cat(file = paste0(archiveWrite, md5hash, "/load.R"), ddrescueInstructions(object, archiveRead, md5hash) )
  sink(file = paste0(archiveWrite, md5hash, "/load.html"))
  highlight::highlight(paste0(archiveWrite, md5hash, "/load.R"), detective = simple_detective, renderer = renderer_html( document = TRUE ))
  sink()
  #
  # add access date
  cat(file = paste0(archiveWrite, md5hash, "/touch.txt"), as.character(Sys.time()), "\n", append=TRUE)
  #
  # save tags
  if (!is.null(attr(object, "tags") )) {
    cat(file = paste0(archiveWrite, md5hash, "/tags.txt"), paste(attr(object, "tags") ), collapse="\n")
  }
  
  list(hash = md5hash, ref = paste0(archiveRead, md5hash))
}


dd.data.frame <- function(object, archiveWrite = "./", archiveRead = archiveWrite, ..., firstRows = NULL) {
  md5hash <- dd.default(object, archiveWrite, archiveRead, ...)
  save(file = paste0(archiveWrite, md5hash$hash, "/df.rda"), object, ascii=TRUE)
  if (!is.null(firstRows)) {
    sink(file = paste0(archiveWrite, md5hash, "/head.txt"))
    print(head(object, firstRows))
    sink()
  }
  list(data.hash = md5hash[[1]], data.ref = paste0(archiveRead, md5hash[[1]]))
}


dd.ggplot <- function(object, archiveWrite = "./", archiveRead = archiveWrite, ..., 
                      archiveData = FALSE,  archiveWriteData = archiveWrite, archiveReadData = archiveRead, 
                      miniatures = NULL) {
  md5hash <- dd.default(object, archiveWrite, archiveRead, ...)
  save(file = paste0(archiveWrite, md5hash[[1]], "/plot.rda"), object, ascii=TRUE)
  #
  # save miniatures in specified format
  if (!is.null(miniatures)) {
    lapply(miniatures, function(forma) {
      forma$FUN(paste0(archiveWrite, md5hash[[1]], "/miniature_",forma$width, "_", forma$height,".", forma$format), 
                forma$width, forma$height)
      print(object)
      dev.off()
    })
  }

  if (archiveData) {
    md5hash2 <- dd(object$data, archiveWrite = archiveWriteData, archiveRead = archiveReadData)[[1]]
    cat(file = paste0(archiveWrite, md5hash$hash, "/data.md5"), md5hash2[[1]])
    return(list(plot.hash = md5hash[[1]], plot.ref = paste0(archiveRead, md5hash[[1]]),
                data.hash = md5hash2[[1]], data.ref = paste0(archiveReadData, md5hash2[[1]])))
  }
  list(plot.hash = md5hash[[1]], plot.ref = paste0(archiveRead, md5hash[[1]]))
}
