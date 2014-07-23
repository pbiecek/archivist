\name{cleanArchive}
\alias{cleanArchive}
\title{Removes all object without protection from archive}
\description{
 Archives are going to be larger and larger.
 In order to remove object that are not necessary the cleanArchive function can be used. 
 The setProtection() function protect object from being deleted for given period of time.
}
\usage{cleanArchive(archiveWriteDir, dueDate = now())}
\author{
 Przemyslaw Biecek
}
\examples{
# cleanArchive(archiveDir)
}
