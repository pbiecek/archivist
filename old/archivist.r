#
# demo of the archivist
#
library("archivist")

#
# create a local Repository, which is a SQLite
# database named backpack.
#
# exampleRepoDir <- getwd()
exampleRepoDir <- tempdir()
createEmptyRepo( repoDir = exampleRepoDir )
invisible(readline())

# 
# archivist has his own example database 
# that is stored on a Github repository,
# for demo and examples purpose.
# 
# this Github repository is available
# under link:
# https://github.com/pbiecek/archivist
#

#
# you can copy this data base to your
# personal computer.
#

md5hashes1 <- searchInGithubRepo( pattern= "relation", user = "pbiecek", repo = "archivist", fixed = FALSE )
md5hashes2 <- searchInGithubRepo( pattern= "name", user = "pbiecek", repo = "archivist", fixed = FALSE )
# this code searches for artifacts in a Repository stored on a Github repository
# and nowe let's copy those artifacts to our Local Repository
exampleRepoDir2 <- tempdir()
createEmptyRepo( exampleRepoDir2 )
copyGithubRepo( repoTo = exampleRepoDir2,  c( md5hashes1, md5hashes2 ),
                user= "pbiecek", repo = "archivist")

invisible(readline())

#
# how does saving a data.frame is realized?
#
data( iris )

saveToRepo( artifact = iris, repoDir = exampleRepoDir )

#
# as we can see, the artifact's md5hash was returned
# wchich means saving operation executes properly.
#
invisible(readline())
#
# if one forgots the artifact's md5hash it can be
# easily checked in database.
#
# one can check with what md5hash iris
# data were saved to the Repository.
#
(iris_md5hash  <- searchInLocalRepo( pattern = "name:iris", repoDir = exampleRepoDir ))
invisible(readline())
#
# one might check how does loading an object process
# is realized?
#
# first remove object from Global Environment before 
# it's going to be loaded.
#
rm( iris )
loadFromLocalRepo( md5hash = "ff575c261c949d073b2895b05d1097c3", repoDir = exampleRepoDir)
invisible(readline())
#
# it also works for md5hash abbreviation.
#
data( swiss , package = "datasets")
(swiss_md5hash <- saveToRepo( swiss, repoDir = exampleRepoDir))
# 4c43fa8a4d8f0cbf65353e397f37338c
rm( swiss ) # note that md5hash will be get strictly from saveToRepo
swiss_md5hash_abbreviation <- "4c43fa8a4" #
loadFromLocalRepo( md5hash = swiss_md5hash_abbreviation, repoDir = exampleRepoDir)
invisible(readline())
#
# note that md5hash can be get strictly from saveToRepo
# but only at first call of this function.
#
# every time you'll call that function on the same artifacts
# a new record will be created in backpack database with
# the same artifact and with the same md5hash.
#
# only createdDate of object will be different.
#
showLocalRepo(repoDir = exampleRepoDir)
#
# so we higly recommend to recover md5hashes from 
# searchInLocalRepo.
# 
invisible(readline())
#
# if one is not interested anymore in archiving
# a specific artifact, then the it might be 
# removed from a database.
#
rmFromRepo( md5hash = swiss_md5hash, repoDir = exampleRepoDir)


#
# note that this function removes a \code{md5hash.rda} file 
# from folder named gallery in directory set as repoDir,
# where \code{md5hash} is artifact's hash as above.
#
# so artifact will not be available to be restored anymore.
#
invisible(readline())

#
# if one wanted to seek for an artifact in Repository, it is 
# advantageous to use searchInLocalRepo or searchInGithubRepo 
# functions, depending on what type of Repository user is 
# working with.
#
# search funtions take an artifact's Tag as an argument.
#
# every call return an artifact's md5hash.
#
searchInLocalRepo( pattern = "name:iris",  repoDir = exampleRepoDir )
invisible(readline())
searchInLocalRepo( pattern = list( dataFrom = Sys.Date()-1, dataTo = Sys.Date()+1), 
                   repoDir = exampleRepoDir)
invisible(readline())
searchInLocalRepo( pattern = "class:data.frame", repoDir = exampleRepoDir)
invisible(readline())
searchInLocalRepo( pattern = as.character(Sys.Date()), repoDir = exampleRepoDir)
invisible(readline())


#
# if one works with Github Repository, it is suggested to use
# expresions as below.
#
showGithubRepo(user = "pbiecek", repo = "archivist")
searchInGithubRepo( pattern = "name:myplot123",  user = "pbiecek", repo = "archivist")
invisible(readline())
searchInGithubRepo( pattern = "class:twins", user = "pbiecek", repo = "archivist")
invisible(readline())
searchInGithubRepo( pattern = "class", 
                    user = "pbiecek", repo = "archivist", fixed = FALSE)
invisible(readline())


#
# the operations conducted on Local Repository might 
# be conducted on a Github Repository.
# 
# thus one can search from Github Repository, there
# is also a possibility of loading artifacts from
# Github Repository.
#
loadFromGithubRepo( md5hash = "53a9f3aa4235e111524dda17aad2ee3a" , 
                    user = "pbiecek", repo = "archivist" )
invisible(readline())
loadFromGithubRepo( md5hash = "958de09ed5e088cd44e6fb486874c914" , 
                    user = "pbiecek", repo = "archivist" )
invisible(readline())
loadFromGithubRepo( md5hash = "7a761a2a" , 
                    user = "pbiecek", repo = "archivist" )
# load with abbreviation
invisible(readline())
#
# one may notice that loadFromGithubRepo and
# loadFromLocalRepo load artifacts to the Global
# Environment with it's original name.
#
# if one is not satisfied with that solution,
# a parameter value = TRUE might be specified
# so that functions return artifact as a result that
# can be attributed to a new name.
#
exampleName1 <- loadFromGithubRepo( md5hash = "692fce39df7" , value = TRUE,
                                    user = "pbiecek", repo = "archivist")
exampleName2 <- loadFromLocalRepo( md5hash = "692fce39df755d1cfec32991e50f61e0", 
                                   repoDir = exampleRepoDir, value = TRUE )
invisible(readline())
#
# VECTORIZED OPERATIONS 
#
invisible(readline())
#
# functions from archivist package are not
# vectorized.
#
# in case one wants to remove many files, e.g. from one date to another, 
# it is suggested to first perform searchIn....Repo and then a function from *apply
# family.
obj2rm <- searchInLocalRepo( pattern = list( dataFrom = Sys.Date()-1, 
                                         dataTo = Sys.Date()+1), 
                             repoDir = exampleRepoDir )
sapply( obj2rm, rmFromRepo, repoDir = exampleRepoDir )
invisible(readline())
#
# similarly when one wants to load more than one artifact,
# again *apply family is recommended (?apply, ?sapply).
#
# below is an example of loading all the artifacts from the
# Repository which class is ggplot.
#
obj2load <- searchInGithubRepo( pattern = "class:ggplot", 
                                user = "pbiecek", repo = "archivist")
sapply( obj2load, loadFromGithubRepo, value = FALSE,
        user = "pbiecek", repo = "archivist") 
invisible(readline())
#
# this can be repeated if many artifacts are desired to 
# be archived at one call.
#
# below is an exmaple of saving 3 different ggplots 
#
df <- data.frame(gp = factor(rep(letters[1:3], each = 10)),
                 y = rnorm(30))
library(plyr)
ds <- ddply(df, .(gp), summarise, mean = mean(y), sd = sd(y))

if (require(ggplot2)) {

plotRed <- ggplot(df, aes(x = gp, y = y)) +
  geom_point() +
  geom_point(data = ds, aes(y = mean),
             colour = 'red', size = 3)

plotBlue <- ggplot(df, aes(x = gp, y = y)) +
  geom_point() +
  geom_point(data = ds, aes(y = mean),
             colour = 'blue', size = 4)

plotGreen <- ggplot(df, aes(x = gp, y = y)) +
  geom_point() +
  geom_point(data = ds, aes(y = mean),
             colour = 'green', size = 3)

sapply(list(plotRed, plotBlue, plotGreen), saveToRepo, width = 4000, 
      height = 3200, archiveData = FALSE, archiveMiniature = TRUE,
      repoDir = exampleRepoDir, rememberName = FALSE)
}

# as a result md5hash of every artifact is returned
invisible(readline())
#
# even search operations can be applied to *apply's family
# function.
#
# if one wants to search for md5hashes of artifacts that are
# data.frames or matrixes he can simply type:
example_tags <- c( "class:data.frame", "class:matrix")
(MATRIX_and_FRAMES_md5hashes <- sapply(example_tags, 
                                searchInLocalRepo, repoDir = exampleRepoDir ))
# and apply to uniqe function to avoid repetitions
MATRIX_and_FRAMES_md5hashes <- unique(MATRIX_and_FRAMES_md5hashes)
invisible(readline())
#
# moreover if one wants to search for artifactss with 2 
# conditions, then also *apply family is suggested.
#
example_tags_conditions <- list( condition1 = "20f40f15",
                                 condition2 = "date:2014-08-27 20:52:22")  
TWO_condition_md5hashes <- lapply( example_tags_conditions, searchInGithubRepo, 
       user = "pbiecek", repo = "archivist")
# and then use intersection of sets containing 
# md5hashes of first and second condition
intersected_condition_md5hashes <- intersect( TWO_condition_md5hashes[[1]],
          TWO_condition_md5hashes[[2]] )

#
# when working with Github reposiotory
# there is a possibility to have more than one
# archivist-type Repository.
# in that case extra argument repoDirGit must
# be specified.
#
library(archivist)
showGithubRepo( user="MarcinKosinski", repo="Museum", branch="master",
                repoDirGit="ex1")
showGithubRepo( user="MarcinKosinski", repo="Museum", branch="master",
                repoDirGit="ex2")

loadFromGithubRepo( "ff575c261c949d073b2895b05d1097c3", 
                    user="MarcinKosinski", repo="Museum", branch="master",
                    repoDirGit="ex2")


loadFromGithubRepo( "ff575c261c949d073b2895b05d1097c3", 
                    user="MarcinKosinski", repo="Museum", branch="master",
                    repoDirGit="ex1")

searchInGithubRepo( pattern = "name", user="MarcinKosinski", repo="Museum", 
                    branch="master", repoDirGit="ex1", fixed = FALSE )

searchInGithubRepo( pattern = "name", user="MarcinKosinski", repo="Museum", 
                    branch="master", repoDirGit="ex2", fixed = FALSE )

getTagsGithub("ff575c261c949d073b2895b05d1097c3", user="MarcinKosinski", 
              repo="Museum", branch="master", repoDirGit="ex1")

# when repository is in the main folder repoDirGit should not be specified
searchInGithubRepo( pattern = "name", user="pbiecek", repo="archivist", 
                    fixed=FALSE)

getTagsGithub("a250f9167c377e0de3b6bf85bfcf4e5a", user="pbiecek", 
              repo="archivist")

dir <- paste0(getwd(), "/ex1")
createEmptyRepo( dir )
copyGithubRepo(repoTo = dir , md5hashes = "ff575c261c949d073b2895b05d1097c3",
               user="MarcinKosinski", repo="Museum", 
               branch="master", repoDirGit="ex2")
deleteRepo( dir )

summaryGithubRepo(user="MarcinKosinski", repo="Museum", 
                  branch="master", repoDirGit="ex2" )