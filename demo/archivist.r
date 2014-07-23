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
# archivist has his own built in database 
# for demo purpose and so examples given in 
# functions' descriptions work.
# 
# this database is situated in installation of
# archivist package directory in folder
# named "exampledata".
#
demoDir <- paste0(path.package("archivist"), "/exampledata/")


#
# how does saving a data.frame is realized?
#
library("PBImisc")
data( musculus )

saveToRepo( object = musculus, dir = demoDir)

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
(musculus_md5hash  <- searchInLocalRepo( tag = "name:musculus", dir = demoDir))

#
# one might check how does loading an object process
# is realized?
#
# first remove object from Global Environment before 
# it's going to be loaded.
#
rm( musculus )
loadFromLocalRepo( md5hash = musculus_md5hash, dir = demoDir)

#
# it also work for md5hash abbreviation.
#
data( apartments , package = "PBImisc")
(apartments_md5hash <- saveToRepo( object = apartments, dir = demoDir))
rm( apartments ) # note that md5hash get be get strictly from saveToRepo
apartments_md5hash_abbreviation <- abbreviate( apartments_md5hash )
loadFromLocalRepo( md5hash = apartments_md5hash_abbreviation, dir = demoDir)

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
rmFromRepo( md5hash = apartments_md5hash, dir = demoDir)


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


# to 
