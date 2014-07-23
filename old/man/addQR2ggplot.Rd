\name{addQR2ggplot}
\alias{addQR2ggplot}
\title{add QRcode to existing ggplot}
\description{
 Please note, that this function plot over existing image.
 It does not create a new ggplot object.
}
\usage{
addQR2ggplot(textm, width = 0.1, height = 0.1, x=0.95, y=0.06, ...)
}
\author{
 Przemyslaw Biecek
}
\examples{
 qplot(Species, Sepal.Length, data=iris)
 addQR2ggplot("http://smarterpoland.pl/") 
}

