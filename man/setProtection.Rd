\name{setProtection}
\alias{setProtection}
\title{Set protection for given directory for given period of time}
\description{
 Archives are going to be larger and larger.
 In order to remove object that are not necessary the cleanArchive function can be used. 
 The setProtection() function protect object from being deleted for given period of time
}
\usage{setProtection(md5links, archiveWriteDir, period = days(1), fixed = NULL)}
\author{
 Przemyslaw Biecek
}
\examples{
# setProtection("03d2d34525317af4224fc8ee110ba551", archiveDir)
}
\keyword{datasets}
