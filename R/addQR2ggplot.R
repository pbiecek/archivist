addQR2ggplot <- function(textm, width = 0.1, height = 0.1, x=0.95, y=0.06, ...) {
  qrcode <- getQRcode(textm, border=0)
  qrplot <- ggplot(melt(qrcode), aes(x=Var1, y=Var2, fill=!value)) + geom_tile() + scale_fill_grey(start = 0, end = 1) + 
    theme(line = element_blank(),
          text = element_blank(),
          line = element_blank(),
          title = element_blank(),
          panel.background = element_blank(), 
          panel.border = element_blank(), 
          axis.ticks.length = unit(0.001, "mm"),
          legend.position = "none") + labs(x=NULL, y=NULL)
  vp <- viewport(width = width, height = height, x=x, y=y, ...)
  print(qrplot, newpage=FALSE, vp=vp)
}
