archiveDataFromObj <- function (object, md5hash, changeBool = TRUE)
  UseMethod("archiveDataFromObj")

archiveDataFromObj.default <- function(object, md5hash, changeBool = TRUE) {
}

# regression model serializer
archiveDataFromObj.lm <- function(object, md5hash, changeBool = TRUE) {
  extractedDF <- object$model
  md5hashDF <- dd(extractedDF, rememberName = changeBool)
    addRelation(md5hash, md5hashDF, "data.source")  
}

archiveDataFromObj.ggplot <- function(object, md5hash, changeBool = TRUE) {
  extractedDF <- object$data
  md5hashDF <- dd(extractedDF, rememberName = changeBool)
  addRelation(md5hash, md5hashDF, "data.source")
}




