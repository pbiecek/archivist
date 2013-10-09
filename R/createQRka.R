createQRka <- function(object, link, archiveDirs, md5hash) {
  require(gridExtra)
  pdf(paste0(archiveDirs$archiveWrite,md5hash,"/QRka.pdf"), 2.28 *4, 4.85 *4)
  
  print(object, vp=viewport(x=0.5, y = 0.75, width=0.9, height=0.5*0.9))
  addQR2ggplot(link, width = 0.9, height = 0.47 * 0.9, x=0.5, y=0.25)
  grid.text(link, 0.5, 0.48, gp=gpar(fontsize=15))
  
  dev.off()
}

