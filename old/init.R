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




#
# Add Excel File
filePath <- "/Users/pbiecek/camtasia/Dropbox/QRka_codes/poczekalnia/CCR_CREDIT_vs_DEBIT_Card 2.xlsx"
ddExcelToArchive(filePath, archiveDirs, tags = c("DTV", "CCR", "Spanish", "credit")) 



#
# tags for autosearch
tags <- createTagList(archiveDirs)
cat(tags$uLines, file = paste0(archiveDirs$archiveWrite,"indeks0.txt"), sep="")
cat(tags$utags, file = paste0(archiveDirs$archiveWrite,"tags.js"))


