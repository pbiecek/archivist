\name{getQRcode}
\alias{getQRcode}
\alias{plotQRcode}
\title{get and plot QR code for given string}
\description{
 Please note, that in order to use this function you need to have installed python with module qrcode
   
 Read more about it here: \link{\code{https://pypi.python.org/pypi/qrcode}}
}
\usage{
getQRcode(text, fname1 = tempfile(),  fname2 = tempfile(), pythoncmd = "python", border=4) 

plotQRcode(...)
}
\author{
 Przemyslaw Biecek
}
\examples{
 getQRcode("http://smarterpoland.pl/", border=1) 
 plotQRcode("http://smarterpoland.pl/", border=1) 
}

