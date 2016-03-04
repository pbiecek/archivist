# Intro
  
#This is the replication script for 'archivist: An R Package for Managing, Recording and Restoring Data Analysis Results' (Przemyslaw Biecek, Marcin Kosinski) submitted to JSS. 

#First, make sure that `archivist` is installed.

if (!require(archivist)) {
  install.packages("archivist")
  library(archivist)
}

# Section 2.1

# Creation of hooks to R objects.
# Following lines download R objects from remote repository.

archivist::aread("pbiecek/graphGallery/f05f0ed0662fe01850ec1b928830ef32")
archivist::aread("pbiecek/graphGallery/f05f0ed066")
setLocalRepo(system.file("graphGallery", package = "archivist"))
aread("f05f0ed0662fe01850ec1b928830ef32")

# regression model

model <- archivist::aread("2a6e492cb6982f230e48cf46023e2e4f")
summary(model)


# Section 2.2

# Retrieval of a list of R objects with given tags.

# Following lines search within remote repositories and download objects with given properties.

models <- asearch("pbiecek/graphGallery", patterns = c("class:lm", "coefname:Sepal.Length"))

lapply(models, coef)

plots <- asearch("pbiecek/graphGallery", 
                 patterns = c("class:gg", "labelx:Sepal.Length"))
length(plots)

library("gridExtra")

do.call(grid.arrange,  plots)

# from local
plots <- asearch(patterns = c("class:gg", "labelx:Sepal.Length"))
length(plots)

do.call(grid.arrange,  plots)

# Section 2.3

# Retrieval of the object's pedigree.

library("archivist")
library("dplyr")
createLocalRepo("arepo", default = TRUE)

data(iris)

iris %a%
  filter(Sepal.Length < 6) %a%
  lm(Petal.Length~Species, data=.) %a%
  summary() -> tmp

ahistory(tmp)

ahistory(md5hash = "050e41ec3bc40b3004bc6bdd356acae7")
# this is not always this hash

#Session info

sinfo <- asession("050e41ec3bc40b3004bc6bdd356acae7")
head(sinfo$packages)



# Section 3.1

# Repository management.

# Creation of a new empty repository.

# local path
repo <- "arepo"
createLocalRepo(repoDir = repo)

# Deletion of an existing repository

repo <- "arepo"
deleteLocalRepo(repoDir = repo, deleteRoot = TRUE)


# Copying artifacts from other repositories.

repo <- "arepo"
createLocalRepo(repoDir = repo, default = TRUE)
copyRemoteRepo(repoTo = repo, md5hashes= "f05f0ed0662fe01850ec1b928830ef32", 
               user = "pbiecek", repo = "graphGallery", repoType = "github")

# Showing repository statistics

showLocalRepo(repoDir = repo, method = "tags")

summaryRemoteRepo(user="pbiecek", repo="graphGallery") 

# Setting default repository

setRemoteRepo(user = "pbiecek", repo = "graphGallery")

# Section 3.2

# Artifact management

# Saving an R object into a repository

library("ggplot2")
repo <- "arepo"
pl <- qplot(Sepal.Length, Petal.Length, data = iris)
saveToLocalRepo(pl, repoDir = repo)

showLocalRepo(repoDir = repo, "tags")

#deleteLocalRepo("arepo", deleteRoot = TRUE)


# Serialization of an object creation event into repository

library("dplyr")
iris %a%
filter(Sepal.Length < 6) %a%
lm(Petal.Length~Species, data=.) %a%
summary() -> tmp

ahistory(tmp)
ahistory(md5hash = "050e41ec3bc40b3004bc6bdd356acae7")

# Loading an object from repository

pl2 <- loadFromRemoteRepo("f05f0ed0662fe01850ec1b928830ef32", repo="graphGallery", user="pbiecek", 
                          value=TRUE)
pl3 <- loadFromLocalRepo("f05f0ed0662", system.file("graphGallery", package = "archivist"), value=TRUE)

archivist::aread("pbiecek/graphGallery/f05f0ed0662fe01850ec1b928830ef32")

setLocalRepo(system.file("graphGallery", package = "archivist"))

pl3 <- loadFromLocalRepo("f05f0ed", value=TRUE)

archivist::aread("f05f0ed")

setLocalRepo(system.file("graphGallery", package = "archivist"))
model <- aread("2a6e492cb6982f230e48cf46023e2e4f")
digest::digest(model)

# Removal of an object from repository

rmFromLocalRepo("f05f0ed0662fe01850ec1b928830ef32", repoDir = repo)

#Remove all older than 30 days

obj2rm <- searchInLocalRepo(list(dateFrom = "2010-01-01", dateTo = Sys.Date()), repoDir = repo)

rmFromLocalRepo(obj2rm, repoDir = repo, many = TRUE)


# Search for an artifact

# Search in a local/GitHub repository

searchInLocalRepo(pattern = "class:gg", 
                  repoDir = system.file("graphGallery", package = "archivist"))

searchInLocalRepo(pattern = list(dateFrom = "2016-01-01",
                                 dateTo = "2016-02-07" ), 
                  repoDir = system.file("graphGallery", package = "archivist"))


searchInLocalRepo(pattern=c("class:gg", "labelx:Sepal.Length"),
                       repoDir = system.file("graphGallery", package = "archivist"))	
