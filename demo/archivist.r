#
# demo of the archivist
#
library("archivist")

#
# create a local Repository, which is a SQLite
# database named backpack.
#
createEmptyRepo( dir = "DesiredDir")

# 
# archivist has his own built-in database 
# for demo and examples purpose.
# 
# this database is situated in installation of
# archivist package directory in folder
# named "exampledata".
#
demoDir <- paste0(path.package("archivist"), "/exampledata/")

#
# there is also an example Github database.
demoGitDir <- "https://github.com/pbiecek/graphGallery/exampledata/"


#
# how does saving a data.frame is realized?
#
data( iris )

saveToRepo( object = iris, dir = demoDir)

#
# as we can see, the object's md5hash was returned
# wchich means saving operation executes properly.
#

#
# if one forgots the object's md5hash it can be
# easily checked in database.
#
# one can check with what md5hash musculus
# data were saved to the Repository.
#
(iris_md5hash  <- searchInLocalRepo( tag = "name:iris", dir = demoDir))

#
# one might check how does loading an object process
# is realized?
#
# first remove object from Global Environment before 
# it's going to be loaded.
#
rm( iris )
loadFromLocalRepo( md5hash = iris_md5hash, dir = demoDir)

#
# it also work for md5hash abbreviation.
#
data( swiss , package = "datasets")
(swiss_md5hash <- saveToRepo( object = swiss, dir = demoDir))
rm( apartments ) # note that md5hash get be get strictly from saveToRepo
swiss_md5hash_abbreviation <- "dhcj7s" # need to be fixed on real hash
loadFromLocalRepo( md5hash = swiss_md5hash_abbreviation, dir = demoDir)

#
# note that md5hash get be get strictly from saveToRepo
# but only at first call of this function.
#
# every time you'll call that function on the same object
# a new record will be created in backpack database with
#
# the same object and with the same md5hash.
#
# only creation time of object will be different.
#
# so we higly recommend to recover md5hashes from 
# searchInLocalRepo.
# 

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


#
# if one wanted to seek for an object in Repository, it is 
# advantageous to use searchInLocalRepo or searchInGithubRepo 
# functions, depending on what type of Repository user is 
# working with.
#
# search funtions take an object's Tag as an argument.
# every call return an object's md5hash.
#
searchInLocalRepo( tag = "name:myDataXYZ",  dir = demoDir)
searchInLocalRepo( tag = list( dataFrom = "2005-05-27", dataTo = "2005-07-07"), 
                   dir = demoDir)
searchInLocalRepo( tag = "class:ggplot",    dir = demoDir)
searchInLocalRepo( tag = "date:2005-05-27", dir = demoDir)


#
# if one works with Github Repository, it is suggested to use
# expresions as below.
#
searchInGithubRepo( tag = "name:marvelData",  user = "USER", repo = "REPO")
searchInGithubRepo( tag = "class:data.frame", user = "USER", repo = "REPO")
searchInGithubRepo( tag = "md5hash:37d8chs9jdj2jxnd0k2jdncjdh4ew23", 
                    user = "USER", repo = "REPO")


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
loadFromGithubRepo( md5hash = "jdkcndjamsnzjdifockdmsnadkdk3" , 
                    user = "pbiecek", repo = "graphGallery")
loadFromGithubRepo( md5hash = "ff78cu" , 
                    user = "pbiecek", repo = "graphGallery")
# load with abbreviation

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
exampleName1 <- loadFromGithubRepo( md5hash = "k09xd" , returns = TRUE
                                    user = "pbiecek", repo = "graphGallery")
exampleName2 <- loadFromLocalRepo( md5hash = "838d9dhcjajskdlfoeuajsjckdiehjd2", 
                                   dir = demoDir, returns = TRUE )
