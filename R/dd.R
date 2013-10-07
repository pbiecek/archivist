dd <- function (object, archiveDirs,  ... )
  UseMethod("dd")


dd.default <- function(object, archiveDirs, ...) {
  md5hash <- digest(object)
  dir.create(file.path(archiveDirs$archiveWrite, md5hash), showWarnings = FALSE)
  
  cat(file = paste0(archiveDirs$archiveWrite, md5hash, "/load.R"), ddrescueInstructions(object, archiveDirs, md5hash) )
  sink(file = paste0(archiveDirs$archiveWrite, md5hash, "/load.html"))
  highlight::highlight(paste0(archiveDirs$archiveWrite, md5hash, "/load.R"), 
                       detective = simple_detective, renderer = renderer_html( document = TRUE ))
  sink()
  #
  # add access date
  now <- as.character(Sys.time())
  cat(file = paste0(archiveDirs$archiveWrite, md5hash, "/touch.txt"), now, "\n", append=TRUE)
  #
  # add class
  cat(file = paste0(archiveDirs$archiveWrite, md5hash, "/class.txt"), class(object))
  #
  # save tags
  if (!is.null(attr(object, "tags") )) {
    cat(file = paste0(archiveDirs$archiveWrite, md5hash, "/tags.txt"), paste(attr(object, "tags") , collapse="\n"))
  }
  #
  # add to object history
  cat(now, md5hash, paste0(class(object), collapse=",") ,"\n", file=paste0(archiveDirs$archiveWrite, "/list.txt"), append=TRUE, sep=";")
  list(hash = md5hash, ref = paste0(archiveDirs$archiveRead, md5hash))
}


dd.data.frame <- function(object, archiveDirs, ..., firstRows = NULL) {
  md5hash <- dd.default(object, archiveDirs, ...)
  save(file = paste0(archiveDirs$archiveWrite, md5hash$hash, "/df.rda"), object, ascii=TRUE)
  if (!is.null(firstRows)) {
    sink(file = paste0(archiveDirs$archiveWrite, md5hash, "/head.txt"))
    print(head(object, firstRows))
    sink()
  }
  list(data.hash = md5hash[[1]], data.ref = paste0(archiveDirs$archiveRead, md5hash[[1]]))
}


dd.ggplot <- function(object, archiveDirs, ..., 
                      archiveData = TRUE,  
                      miniatures = list(list(FUN = png, format="png", width=800, height=600))) {
  md5hash <- dd.default(object, archiveDirs, ...)
  save(file = paste0(archiveDirs$archiveWrite, md5hash[[1]], "/plot.rda"), object, ascii=TRUE)
  #
  # save miniatures in specified format
  plotMlinks <- createFigureMiniature(object, archiveDirs, md5hash[[1]], miniatures)

  if (archiveData) {
    md5hash2 <- dd(object$data, archiveDirs)[[1]]
    cat(file = paste0(archiveDirs$archiveWrite, md5hash$hash, "/links_data.md5"), md5hash2[[1]], append=TRUE)
    return(list(plot.hash = md5hash[[1]], plot.ref = paste0(archiveDirs$archiveRead, md5hash[[1]]),
                data.hash = md5hash2[[1]], data.ref = paste0(archiveDirs$archiveRead, md5hash2[[1]])))
  }
  #
  # ceate QRka
  wplinks <- ddWelcomePage(object, archiveDirs, md5hash=md5hash) 
  QRkalinks <- createQRka(object, paste0("http://smarterpoland.pl/QRka/set.php?ID=",md5hash[[1]]), archiveDirs, md5hash[[1]])  
  
  list(plot.hash = md5hash[[1]], plot.ref = paste0(archiveDirs$archiveRead, md5hash[[1]]), 
       welcomePage = wplinks, plotMlinks, QRkalinks)
}




#
# squad is a list of lists
# list(plotObj = , link = )
dd.squad <- function(object, archiveDirs, ..., 
                     miniatures = list(list(FUN = png, format="png", width=500, height=500))) {
  md5hash <- dd.default(object, archiveDirs, ...)
  
  save(file = paste0(archiveDirs$archiveWrite, md5hash[[1]], "/squad.rda"), object, ascii=TRUE)
  # save miniatures of all objects in specified format
  if (!is.null(miniatures)) {
    object <- lapply(object, function(obj) {
      obj$miniaturesLinks <- lapply(miniatures, function(forma) {
        forma$FUN(paste0(archiveDirs$archiveWrite, md5hash[[1]], "/miniature_",obj$link,"_",forma$width, "_", forma$height,".", forma$format), 
                  forma$width, forma$height)
        print(obj$plotObj)
        dev.off()
        paste0(md5hash[[1]], "/miniature_",obj$link,"_",forma$width, "_", forma$height,".", forma$format)
      })
      obj
    })
  }
  class(object) = "squad"
  wplinks <- ddWelcomePage(object, archiveDirs, md5hash=md5hash) 
  
  list(squad.hash = md5hash[[1]], squad.ref = paste0(archiveDirs$archiveRead, md5hash[[1]]), welcomePage = wplinks)
}
