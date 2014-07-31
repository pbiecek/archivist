#
# demo of the archivist
#
library("archivist")

#
# create a local Repository, which is a SQLite
# database named backpack.
#
createEmptyRepo( dir = getwd() )
invisible(readline())

# 
# archivist has his own built-in database 
# for demo and examples purpose.
# 
# this database is situated in directory where
# archivist package was installed, in folder
# named "exampledata".
#
# demoDir <- paste0(path.package("archivist"), "/exampledata/")
# OR
#
demoDir <- getwd()

#
# there is also an example Github database.
#
demoGitDir <- "https://github.com/pbiecek/graphGallery/exampledata/"
invisible(readline())

#
# how does saving a data.frame is realized?
#
data( iris )

saveToRepo( object = iris, dir = demoDir)

#
# as we can see, the object's md5hash was returned
# wchich means saving operation executes properly.
#
invisible(readline())
#
# if one forgots the object's md5hash it can be
# easily checked in database.
#
# one can check with what md5hash iris
# data were saved to the Repository.
#
(iris_md5hash  <- searchInLocalRepo( tag = "name:iris", dir = demoDir))
invisible(readline())
#
# one might check how does loading an object process
# is realized?
#
# first remove object from Global Environment before 
# it's going to be loaded.
#
rm( iris )
loadFromLocalRepo( md5hash = iris_md5hash, dir = demoDir)
invisible(readline())
#
# it also works for md5hash abbreviation.
#
data( swiss , package = "datasets")
(swiss_md5hash <- saveToRepo( object = swiss, dir = demoDir))
rm( apartments ) # note that md5hash get be get strictly from saveToRepo
swiss_md5hash_abbreviation <- "dhcj7s" # need to be fixed on real hash
loadFromLocalRepo( md5hash = swiss_md5hash_abbreviation, dir = demoDir)
invisible(readline())
#
# note that md5hash can be get strictly from saveToRepo
# but only at first call of this function.
#
# every time you'll call that function on the same object
# a new record will be created in backpack database with
# the same object and with the same md5hash.
#
# only creation time of object will be different.
#
# so we higly recommend to recover md5hashes from 
# searchInLocalRepo.
# 
invisible(readline())
#
# if one is not interested anymore in archivizing
# a specific object, then the object might be 
# removed from a database.
#
rmFromRepo( md5hash = swiss_md5hash, dir = demoDir)


#
# note that this function removes a \code{md5hash.rda} file 
# from folder named gallery in directory set as demoDir,
# where \code{md5hash} is object's hash as above.
#
# so object will not be able to restore anymore.
#
invisible(readline())

#
# if one wanted to seek for an object in Repository, it is 
# advantageous to use searchInLocalRepo or searchInGithubRepo 
# functions, depending on what type of Repository user is 
# working with.
#
# search funtions take an object's Tag as an argument.
#
# every call return an object's md5hash.
#
searchInLocalRepo( tag = "name:myDataXYZ",  dir = demoDir)
invisible(readline())
searchInLocalRepo( tag = list( dataFrom = "2005-05-27", dataTo = "2005-07-07"), 
                   dir = demoDir)
invisible(readline())
searchInLocalRepo( tag = "class:ggplot",    dir = demoDir)
invisible(readline())
searchInLocalRepo( tag = "date:2005-05-27", dir = demoDir)
invisible(readline())


#
# if one works with Github Repository, it is suggested to use
# expresions as below.
#
searchInGithubRepo( tag = "name:marvelData",  user = "USER", repo = "REPO")
invisible(readline())
searchInGithubRepo( tag = "class:data.frame", user = "USER", repo = "REPO")
invisible(readline())
searchInGithubRepo( tag = "md5hash:37d8chs9jdj2jxnd0k2jdncjdh4ew23", 
                    user = "USER", repo = "REPO")
invisible(readline())


#
# the operations conducted on Local Repository might 
# be conducted on a Github Repository.
# 
# thus one can search from Github Repository, there
# is also a possibility of loading objects from
# Github Repository.
#
loadFromGithubRepo( md5hash = "jd7fhcndkwid8fhcbs9d0ckdhen31" , 
                    user = "pbiecek", repo = "graphGallery")
invisible(readline())
loadFromGithubRepo( md5hash = "jdkcndjamsnzjdifockdmsnadkdk3" , 
                    user = "pbiecek", repo = "graphGallery")
invisible(readline())
loadFromGithubRepo( md5hash = "ff78cu" , 
                    user = "pbiecek", repo = "graphGallery")
# load with abbreviation
invisible(readline())
#
# one may notice that loadFromGithubRepo and
# loadFromLocalRepo load objects to the Global
# Environment with it's original name.
#
# if one is not satisfied with that solution,
# a parameter returns = TRUE might be specified
# so that functions return object as a result that
# can be attributed to a new name.
#
exampleName1 <- loadFromGithubRepo( md5hash = "k09xd" , returns = TRUE,
                                    user = "pbiecek", repo = "graphGallery")
exampleName2 <- loadFromLocalRepo( md5hash = "838d9dhcjajskdlfoeuajsjckdiehjd2", 
                                   dir = demoDir, returns = TRUE )
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
obj2rm <- searchInLocalRepo( tag = list( dataFrom = "2005-05-27", 
                                         dataTo = "2005-07-07"), 
                             dir = demoDir )
sapply( obj2rm, rmFromRepo, dir = demoDir )
invisible(readline())
#
# similarly when one wants to load more than one object,
# again *apply family is recommended (?apply, ?sapply).
#
# above is an example of loading all objects from the
# repository which class is ggplot.
#
obj2load <- searchInGithubRepo( tag = "class:ggplot", 
                                user = "pbiecek", repo = "graphGallery")
sapply( obj2load, loadFromGithubRepo, returns = FALSE,
        user = "pbiecek", repo = "graphGallery") 
invisible(readline())
#
# this can be repeated if many objects are desired to 
# be archivised at one call.
#
# above is an exmaple of saving 3 different ggplots 
#
df <- data.frame(gp = factor(rep(letters[1:3], each = 10)),
                 y = rnorm(30))
library(plyr)
ds <- ddply(df, .(gp), summarise, mean = mean(y), sd = sd(y))

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

sappl(c(plotRed, plotBlue, plotGreen), saveToRepo, width = 4000, 
      height = 3200, archiveData = FALSE, archiveMiniature = TRUE,
      dir = demoDir)
# as a result md5hash of every object is returned
invisible(readline())
#
# even search operations can be applied to *apply's family
# function.
#
# if one wants to search for md5hashes of objects that are
# data.frames or matrixes he can simply type:
example_tags <- c( "class:data.frame", "class:matrix")
(MATRIX_and_FRAMES_md5hashes <- sapply(example_tags, 
                                searchInLocalRepo, dir = demoDir))
# and apply to uniqe function to avoid repetitions
MATRIX_and_FRAMES_md5hashes <- unique(MATRIX_and_FRAMES_md5hashes)
invisible(readline())
#
# moreover if one wants to search for objects with 2 
# conditions, then also *apply family is suggested.
#
example_tags_conditions <- list( condition1 = "md5hash:hcgd6",
                                 condition2 = "date:2005-07-07")  
TWO_condition_md5hashes <- lapply( example_tags_conditions, searchInGithubRepo, 
       user = "pbiecek", repo = "graphGallery")
# and the use intersection of sets containing 
# md5hashes of first and second condition
intersected_condition_md5hashes <- intersect( TWO_condition_md5hashes[[1]],
          TWO_condition_md5hashes[[2]] )

