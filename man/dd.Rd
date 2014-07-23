\name{dd}
\alias{dd}
\alias{dd.default}
\alias{dd.data.frame}
\alias{dd.ggplot}
\title{Serialize an object to archive}
\description{
 Currently works for data.frame and plots
}
\usage{
dd(object, archiveWrite = "./", archiveRead = archiveWrite,  ...) 

dd.default(object, archiveWrite = "./", archiveRead = archiveWrite, ...) 

dd.data.frame(object, archiveWrite = "./", ...) 

dd.ggplot(object, archiveWrite = "./", archiveRead = archiveWrite, ..., archiveData = FALSE,  archiveWriteData = archiveWrite, archiveReadData = archiveRead) 
}
\author{
 Przemyslaw Biecek
}
\examples{
 plot <- qplot(Species, Sepal.Length, data=iris)
 dd(plot)
}

