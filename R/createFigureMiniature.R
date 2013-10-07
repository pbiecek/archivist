createFigureMiniature <- function(object, archiveDirs, md5hash, miniatures = NULL) {
  if (is.null(miniatures)) 
    return (NULL)

  lapply(miniatures, function(forma) {
        forma$FUN(paste0(archiveDirs$archiveWrite, md5hash, "/miniature_",md5hash, "_", forma$width, "_", forma$height,".", forma$format), 
                  forma$width, forma$height)
        print(object)
        dev.off()
        paste0("/miniature_",md5hash, "_",forma$width, "_", forma$height,".", forma$format)
      })
}
