##    archivist package for R
##
#' @title Return a Link To Download an Artifact Stored on GitHub Repository
#'
#' @description
#' \code{alink} returns a link to download and artifact from GitHub \link{Repository}.
#' Artifact has to be prior archived on github, e.g with \link{archive} function (recomended) or 
#' \link{saveToRepo} function and traditional git manual synchronization.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' For more information about \code{md5hash} see \link{md5hash}.
#' 
#'
#' @param md5hash A character assigned to the artifact through the use of a cryptographical hash function with MD5 algorithm. See more \link{md5hash}. 
#' If specified in a format of \code{'repo/user/md5hash'} then the \code{user} and \code{repo} parameters are omitted.
#' 
#' @param repo The GitHub \code{Repository} on which the desired to be download artifact
#' is stored.
#' @param user The name of a user on whos \code{Repository} the desired to be download artifact 
#' is stored.
#' 
#' @param format In which format the link should be returned. Possibilites are \code{markdown} (default) or \code{latex}.
#' 
#' @param rawLink A logical denoting whether to return raw link or a link in \code{format} convention.
#' 
#' @return This function returns a link to download artifact that are archived on GitHub.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @examples
#' \dontrun{
#'
#'
#' alink('pbiecek/archivist/134ecbbe2a8814d98f0c2758000c408e')
#' alink(user = 'MarcinKosinski', repo = 'Museum',
#'  md5hash = '1651caa499a2b07a3bdad3896a2fc717', format = 'latex)
#' alink('pbiecek/graphGallery/02af4f99e440324b9e329faa293a9394', rawLink = TRUE)  
#'
#' ## Exmaple with archive function and 
#' ## empty Github Repository creation
#' 
#' library(httr)
#' myapp <- oauth_app("github",
#'                    key = app_key,
#'                    secret = app_secret)
#' github_token <- oauth2.0_token(oauth_endpoints("github"),
#'                                myapp,
#'                                scope = "public_repo")
#' # setting options                              
#' aoptions("github_token", github_token)
#' aoptions("user.name", user_name)
#' aoptions("user.password", user_password)
#' 
#' createEmptyGithubRepo("archive-test4", default = TRUE)
#' ## artifact's archiving
#' vectorLong <- 1:100
#' vectorShort <- 1:20
#' # archiving
#' alink(archive(vectorLong))
#' archive(vectorShort, alink = TRUE)
#' }
#' @family archivist
#' @rdname alink
#' @export
alink <- function(md5hash, repo = aoptions('repo'),
                  user = aoptions('repo'),
                  format = "markdown", rawLink = FALSE) {
  
  stopifnot(is.character(md5hash) & length(md5hash) == 1)
  stopifnot(is.character(format) & length(format) == 1 | format %in% c('markdown', 'latex'))
  stopifnot(is.logical(rawLink) & length(rawLink) == 1)
  GithubCheck( repo, user, repoDirGit ) # implemented in setRepo.R
  
  if ( strsplit(md5hash, "/")[[1]] %>% length  == 3 ) {
    archLINK <- paste0('https://github.com/',
                       strsplit(md5hash, "/")[[1]][1],
                       '/',
                       strsplit(md5hash, "/")[[1]][2],
                       '/blob/master/gallery/',
                       strsplit(md5hash, "/")[[1]][3],
                       '.rda?raw=true')
  } else {
    archLINK <- paste0('https://github.com/',
                       user,
                       '/',
                       repo,
                       '/blob/master/gallery/',
                       md5hash,
                       '.rda?raw=true')
  }
  
  if ( rawLink ) {
    class(archLINK) <- 'alink'
    return(archLINK)
  } else {
    if ( format == "markdown" ){
      paste0('[archivist::aread(\'',
             ifelse(strsplit(md5hash, "/")[[1]] %>% length  == 3,
                                md5hash,
                                file.path(user, repo, md5hash)),
             '\')](',
             archLINK,
             ')'
             ) -> resLINK
      class(resLINK) <- 'alink'
      return(resLINK)
    } else {
      paste0('\\href{',
             archLINK,
             '}{',
             'archivist::aread(\'',
             ifelse(strsplit(md5hash, "/")[[1]] %>% length  == 3,
                    md5hash,
                    file.path(user, repo, md5hash)),
             '\')}'
      ) -> resLINK
      class(resLINK) <- 'alink'
      return(resLINK)
    }
  }
  
}


#' export
print.alink <- function(x, ...) {
  cat(x)
}