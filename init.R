library("devtools")
install_github("archivist", "pbiecek")

library(archivist)
source("../tokens.R")

plotOb <- getBinaryURL("https://raw.github.com/pbiecek/graphGallery/master/77514920247a0a2eca602286cf8a4c60/plot.rda")
tf <- tempfile()
writeBin(plotOb, tf)
name <- load(tf)
unlink(tf)
get(name)
name


refs <- dd(plotOb, archiveData=TRUE,
           archiveWrite=archivePlotWrite, archiveRead=archivePlotRead, 
           archiveWriteData=archiveDataWrite, archiveReadData=archiveDataRead)

(plref <- getBitLy(refs$plot.ref, mytoken)$bitly)
(dtref <- getBitLy(refs$data.ref, mytoken)$bitly)

plotQRcode(plref)
plotQRcode(dtref)

plotOb
addQR2ggplot(plref)

