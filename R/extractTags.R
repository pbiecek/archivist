extractTags <- function (object, ... )
  UseMethod("extractTags")

extractTags.default <- function(object, ...) {
}

extractTags.lm <- function(object, ...) {
  unique(c(names(object$coefficients), 
           as.character(object$terms),
           colnames(object$model),
           "linear regression model"))
}

extractTags.data.frame <- function(object, ...) {
  unique(c(colnames(object),
           "data frame"))
}


