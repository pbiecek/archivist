.onAttach <- function(...) {
  packageStartupMessage("Welcome to the archivist package version 0.x that brings a set of tools for datasets, glm/lm model outputs and figures archivisation.  \n The start default options are: \n localPathToArchive = ", paste0(getwd(),"/"), "\n externalPathToArchive = https://github.com/pbiecek/graphGallery/master/ \n miniatureFormat = png \n miniatureWidth = 800 \n miniatureHeight = 600",
"\n To change them simply use functions: setSettingsWrapper() or setUpDatabase()")
}
paste("Welcome to the archivist package that brings a set of tools for datasets, model outputs and figures archivisation  \n The start default options are: \n
                        localPathToArchive =", paste0(getwd(),"/"), "\n externalPathToArchive = https://github.com/pbiecek/graphGallery/master/ \n miniatureFormat = png \n
                        miniatureWidth = 800 \n miniatureHeight = 600")
.ArchivistEnv <- new.env()

.onDetach <- function(libpath) {
  if (".backpack" %in% ls(.ArchivistEnv)) {
    tmp <- get(".backpack", envir = .ArchivistEnv)
    if (!is.null(tmp)) {
      dbDisconnect(tmp)
      assign(".backpack", NULL, envir = .ArchivistEnv)
    }
  } 
}

