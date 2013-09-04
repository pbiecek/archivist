getQRcode <- function(text, fname1 = tempfile(),  fname2 = tempfile(), pythoncmd = "python", border=4) {
  content <- paste0("import qrcode, pickle, csv
qr = qrcode.QRCode(
version=None,
border=",border,",
)
qr.add_data('", text,"')
qr.make(fit=True)
qr2 = qr.get_matrix()
f = open('",fname1,"', 'wb')
wr = csv.writer(f, quoting=csv.QUOTE_ALL)
wr.writerow(qr.get_matrix())
f.close()
");
  
  cat(content, file=fname2)
  system(paste(pythoncmd,fname2))
  img <- read.table(fname1, stringsAsFactors=FALSE, sep=",")
  
  unlink(fname1)
  unlink(fname2)
  
  img2 <- gsub(img, pattern="[^FT]", replacement="")
  img4 <- sapply(strsplit(img2, split=""), `==`, "T")
  img4[,ncol(img4):1]
}

plotQRcode <- function(...) {
  par(mar=c(0,0,0,0))
  image(getQRcode(...), col=c("white", "black"), bty="n", xaxt="n", yaxt="n")
}
