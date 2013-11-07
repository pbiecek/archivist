dd <- function (object, ... )
  UseMethod("dd")

# default serializer
# - create an artifact directory
# - create serialized artifact.rda
# - create row in the database
# - extract tags
# - add tags to database
# - if it applies add the related artifact to database and update relation structure
# - if it applies add the recreate function
dd.default <- function(object, ...) {
  md5hash <- digest(object)

  # create dir with md5hash as name
  writeDir <- settingsWrapper("localPathToArchive")
  readDir <- settingsWrapper("externalPathToArchive")

  dir.create(file.path(writeDir, md5hash), showWarnings = FALSE)
  
  # serialize the object
  save(file = paste0(writeDir, md5hash, "/object.rda"), object, ascii=TRUE)
  # add serialize instructions
  ddrescueInstructions(object, md5hash)
  cat(file = paste0(writeDir, md5hash, "/load.R"), ddrescueInstructions(object, md5hash) )
  sink(file = paste0(writeDir, md5hash, "/load.html"))
  highlight::highlight(paste0(writeDir, md5hash, "/load.R"), 
                       detective = simple_detective, renderer = renderer_html( document = TRUE ))
  sink()

  # add entry to database 
  objectName <- deparse(substitute(object))
  addArtifact(md5hash, objectName, class(object)[1], paste0(readDir, md5hash, '/index.html')) 
  # add tags
  extractedTags <- extractTags(object)
  sapply(extractedTags, addTag, md5hash=md5hash)

  # create miniature
  createMiniature(object, md5hash, ...)
  
  md5hash
}

# data frame serializer
dd.data.frame <- function(object, ...,  firstRows = 6) {
  md5hash <- dd.default(object, ...)
  md5hash
}

# regression model serializer
dd.lm <- function(object, ...) {
  md5hash <- dd.default(object, ...)
  md5hash
}

# ggplot2 plot serializer
dd.ggplot <- function(object, ...) {
  md5hash <- dd.default(object, ...)
  md5hash
}

