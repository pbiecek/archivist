library("devtools")
install_github("archivist", "pbiecek")

library(archivist)
source("../tokens.R")

pl <- qplot(1, 1, data=iris)

refs <- dd(pl, archiveData=TRUE,
         archiveWrite=archivePlotWrite, archiveRead=archivePlotRead, 
         archiveWriteData=archiveDataWrite, archiveReadData=archiveDataRead)

(plref <- getBitLy(refs$plot.ref, mytoken))
(plref <- getBitLy(refs$data.ref, mytoken))


