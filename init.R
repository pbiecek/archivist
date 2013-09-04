library("devtools")
install_github("archivist", "pbiecek")

library(archivist)
source("../tokens.R")

getBitLy("http://smarteroland.pl", mytoken)
