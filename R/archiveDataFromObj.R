archiveDataFromObj <- function (object, md5hashDF )
  UseMethod("archiveDataFromObj")

archiveDataFromObj.default <- function(object, md5hashDF) {
}

# regression model serializer
archiveDataFromObj.lm <- function(object, md5hashDF) {
  md5hashDF <- dd(object$model)
  addRelation(md5hash, md5hashDF, "data.source")
}

archiveDataFromObj.ggplot <- function(object, md5hashDF) {
  etractedDF <- object$data
  md5hashDF <- dd(etractedDF)
  addRelation(md5hash, md5hashDF, "data.source")
}
