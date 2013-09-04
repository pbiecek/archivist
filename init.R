library("devtools")
install_github("archivist", "pbiecek")

library(archivist)
source("../tokens.R")

getBitLy("http://smarteroland.pl", mytoken)

pl <- qplot(1, 1, data=iris)

dd(pl, archiveData=TRUE,
   archiveWrite=archivePlotWrite, archiveRead=archivePlotRead, 
   archiveWriteData=archiveDataWrite, archiveReadData=archiveDataRead)



