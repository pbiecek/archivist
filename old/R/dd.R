# default serializer
# - create an artifact directory
# - create serialized artifact.rda
# - create row in the database
# - extract tags
# - add tags to database
# - if it applies add the related artifact to database and update relation structure
# - if it applies add the recreate function
dd <- function(object,  ..., archiveData = TRUE, rememberName = TRUE) {
  objectName <- deparse(substitute(object))
  
  md5hash <- digest(object)
  

  # create dir with md5hash as name
  writeDir <- settingsWrapper("localPathToArchive")
  readDir <- settingsWrapper("externalPathToArchive")
  
  # check if writeDir ends with "/" and add it if not
  if ( regexpr( pattern = ".$", text = writeDir) != "/" ){
    dir <- paste0( c ( writeDir, "/" ) )
  }
  
  
  dir.create(file.path(writeDir, md5hash), showWarnings = FALSE)
  
  # serialize the object with it's original name
  if (rememberName){
    save(file = paste0(writeDir, md5hash, "/object.rda"), ascii=FALSE, list=objectName,  envir = parent.frame(2))
    }else{
    save(object, file = paste0(writeDir, md5hash, "/object.rda"), ascii=FALSE)
  }
  # add serialize instructions
  cat(file = paste0(writeDir, md5hash, "/load.R"), ddrescueInstructions(object, md5hash) )
  sink(file = paste0(writeDir, md5hash, "/load.html"))
  highlight::highlight(paste0(writeDir, md5hash, "/load.R"), 
                       detective = simple_detective, renderer = renderer_html( document = TRUE ))
  sink()

  # add entry to database 
  addArtifact(md5hash, objectName, class(object)[1], paste0(readDir, md5hash, '/index.html')) 
  # add tags
  extractedTags <- extractTags(object)
  sapply(extractedTags, addTag, md5hash=md5hash)

  # create miniature
  createMiniature( object, md5hash, ...)

  if ( archiveData )
    archiveDataFromObj( object, md5hash, changeBool = FALSE )
  
  if (!rememberName){
    cat(" \n ")
    cat("Data saved in folder: ", md5hash, " \n ")
  }else{
    cat("Object saved in folder: ", md5hash, " \n ")
  }
}

 


