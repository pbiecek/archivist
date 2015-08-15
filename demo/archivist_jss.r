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

archivist::aread("pbiecek/graphGallery/2166dfbd3a7a68a91a2f8e6df1a44111")
archivist::aread("pbiecek/graphGallery/2166d")

model <- archivist::aread("pbiecek/graphGallery/2a6e492cb6982f230e48cf46023e2e4f")
summary(model)


# Section 2.2

# Retrieval of a list of R objects with given tags.

# Following lines search within remote repositories and download objects with given properties.

models <- asearch("pbiecek/graphGallery", patterns = c("class:lm", "coefname:Sepal.Length"))

lapply(models, coef)

plots <- asearch("pbiecek/graphGallery", 
                 patterns = c("class:gg",
                              "labelx:Sepal.Length"))

library("gridExtra")
do.call(grid.arrange,  plots)

# Section 2.3

# Retrieval of the object's pedigree.


library("dplyr")
library("archivist")
createEmptyRepo("tmp_archivist")
setLocalRepo(repoDir = "tmp_archivist")

iris %a%
filter(Sepal.Length < 6) %a%
lm(Petal.Length~Species, data=.) %a%
summary() -> tmp

ahistory(tmp)

ahistory(md5hash = "050e41ec3bc40b3004bc6bdd356acae7")

# Section 3.1

# Repository management.

# Creation of a new empty repository.

# local path
repo <- "new_repo"
createEmptyRepo(repoDir = repo)

# Deletion of an existing repository

repo <- "new_repo"
deleteRepo(repoDir = repo)


# Copying artifacts from other repositories.

repo <- "new_repo"
createEmptyRepo(repoDir = repo)
copyGithubRepo( repoTo = repo, md5hashes= "2166dfbd3a7a68a91a2f8e6df1a44111", 
user="pbiecek", repo="graphGallery" )

# Showing repository statistics

showLocalRepo(repoDir = repo, method = "tags")

summaryGithubRepo(user="pbiecek", repo="graphGallery") 

# Setting default repository

setGithubRepo(user = "pbiecek", repo = "graphGallery")

# Section 3.2

# Artifact management

# Saving an R object into a repository

library("ggplot2")
repo <- "new_repo"
pl <- qplot(Sepal.Length, Petal.Length, data = iris)
saveToRepo(pl, repoDir = repo)

showLocalRepo(repoDir = repo, "tags")

deleteRepo("new_repo")


# Serialization of an object creation event into repository

library("dplyr")
iris %a%
filter(Sepal.Length < 6) %a%
lm(Petal.Length~Species, data=.) %a%
summary() -> tmp

ahistory(tmp)
ahistory(md5hash = "050e41ec3bc40b3004bc6bdd356acae7")

# Loading an object from repository

pl2 <- loadFromGithubRepo("92ada1", repo="graphGallery", user="pbiecek", 
value=TRUE)
pl3 <- loadFromLocalRepo("92ada1", repo, value=TRUE)

archivist::aread("pbiecek/graphGallery/2166d")

model <- aread("pbiecek/graphGallery/2a6e492cb6982f230e48cf46023e2e4f")
digest::digest(model)

# Removal of an object from repository

rmFromRepo("92ada1e052d4d963e5787bfc9c4b506c", repoDir = repo)

obj2rm <- searchInLocalRepo(list(dateFrom = "2010-01-01", dateTo = Sys.Date()-30), repoDir = repo)

rmFromRepo(obj2rm, repoDir = repo, many = TRUE)

# Search for an artifact

# Search in a local/GitHub repository

searchInGithubRepo(pattern="class:gg", user="pbiecek", repo="graphGallery")

searchInGithubRepo(pattern = list( dateFrom = "2014-09-01", 
dateTo = "2014-09-30" ),
user="pbiecek", repo="graphGallery")

multiSearchInGithubRepo(pattern=c("class:gg", "labelx:Sepal.Length"),
user="pbiecek", repo="graphGallery")	

