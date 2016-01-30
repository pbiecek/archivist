##    archivist package for R
##
#' @title Read Artifacts Given as a List of Tags
#'
#' @description
#' \code{asearch} searches for artifacts that contain all specified \link{Tags}
#' and reads all of them from a default or Github \link{Repository}. It's a wrapper around 
#' \link{multiSearchInLocalRepo} and \link{loadFromLocalRepo}.
#' 
#' @details
#' Function \code{asearch} reads all artifacts that contain given list of \code{Tags}
#' from default or GitHub Repository.
#' It uses both \link{loadFromLocalRepo} and \link{multiSearchInLocalRepo} functions 
#' but has shorter name and different parameter's specification.
#' 
#' @note
#' Remember that if you want to use local repository you should set it to default.
#' 
#' @param repo One of following:
#' 
#' A character with GitHub user name and GitHub repository name separated by `/`.
#' 
#' NULL in this case search will be performed in the default repo, either local or GitHub.
#' 
#' @param patterns  A character vector of \code{Tags}. Only artifacts that 
#' contain all Tags are returned.  
#' 
#' @return This function returns a list of artifacts (by their values).
#' 
#' @author 
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#' 
#' @examples
#' \dontrun{
#' ### default LOCAL version
#' ## objects preparation
#' 
#' # data.frame object
#' data(iris)
#' 
#' # ggplot/gg object
#' library(ggplot2)
#' df <- data.frame(gp = factor(rep(letters[1:3], each = 10)),y = rnorm(30))
#' library(plyr)
#' ds <- ddply(df, .(gp), summarise, mean = mean(y), sd = sd(y))
#' myplot123 <- ggplot(df, aes(x = gp, y = y)) +
#'   geom_point() +  geom_point(data = ds, aes(y = mean),
#'                              colour = 'red', size = 3)
#' 
#' # lm object
#' model <- lm(Sepal.Length~ Sepal.Width + Petal.Length + Petal.Width, data= iris)
#' model2 <- lm(Sepal.Length~ Sepal.Width + Petal.Width, data= iris)
#' model3 <- lm(Sepal.Length~ Sepal.Width, data= iris)
#' 
#' ## creating example default local repository
#' exampleRepoDir <- tempfile()
#' createEmptyRepo(repoDir = exampleRepoDir)
#' ## setting default local repository
#' setLocalRepo( repoDir = exampleRepoDir )
#' 
#' saveToRepo(myplot123)
#' saveToRepo(iris)
#' saveToRepo(model)
#' saveToRepo(model2)
#' saveToRepo(model3)
#' 
#' ## Searching for objects of class:lm
#' lm <- asearch(patterns = "class:lm")
#' 
#' ## Searching for objects of class:lm with coefname:Petal.Width
#' lm_c_PW <- asearch(patterns = c("class:lm","coefname:Petal.Width"))
#' 
#' # Note that we searched for objects. Then loaded them from repository by their value.
#' 
#' 
#' ## deleting example repository
#' deleteRepo(repoDir = exampleRepoDir, deleteRoot = TRUE)
#' rm(exampleRepoDir)
#' 
#' ### default GitHub version
#' ## Setting default github repository
#' setGithubRepo( user = "pbiecek", repo = "archivist")
#' 
#' showGithubRepo(method = "tags")$tag
#' searchInGithubRepo(pattern = "class:lm")
#' searchInGithubRepo(pattern = "class:gg")
#' getTagsGithub(md5hash = "cd6557c6163a6f9800f308f343e75e72", tag = "")
#' 
#' ## Searching for objects of class:lm
#' asearch(patterns = c("class:lm"))
#' ## Searching for objects of class:gg
#' asearch(patterns = c("class:gg"))
#' 
#' ### Github version 
#' ## Note that repo argument is passed in the following way to asearch:
#' ## repo = "GitHub user name/GitHub repository name"
#' 
#' ## Searching for objects of class:gg
#' asearch("pbiecek/graphGallery", 
#'         patterns = c("class:gg",
#'                      "labelx:Sepal.Length"))
#' }
#' @family archivist
#' @rdname asearch
#' @export
asearch <- function( patterns, repo = NULL){
  stopifnot( (is.character( repo ) & length( repo ) == 1) | is.null( repo ) )
  stopifnot( is.character( patterns ) )

  res <- list()
  
  if (is.null(repo)) {
    # use default repo
     oblist <- multiSearchInLocalRepo(patterns = patterns,
                                      intersect = TRUE)
#     oblist <- multiSearchInRepo(patterns = patterns)
#     if (length(oblist) > 0) {
#       res <- lapply(oblist, aread)
#     }
    if (length(oblist) > 0) {
      res <- lapply(oblist, loadFromLocalRepo, value = TRUE)
    }
  } else {
    # at least 3 elements
    # it's GitHub Repo
    elements <- strsplit(repo, "/")[[1]]
    stopifnot( length(elements) >= 2 )
    
    oblist <- multiSearchInGithubRepo(user = elements[1], repo=paste(elements[-1], collapse = "/"), 
                                patterns = patterns)
    if (length(oblist)>0) {
      res <- lapply(paste0(repo, "/", oblist), aread)
    } 
  } 
  res
}
