##    archivist package for R
##
#' @title Return a Link To Download an Artifact Stored on Remote Repository
#'
#' @description
#' \code{alink} returns a link to download an artifact from the Remote \link{Repository}.
#' Artifact has to be already archived on GitHub, e.g with \code{archivist.github::archive} function (recommended) or 
#' \link{saveToRepo} function and traditional Git manual synchronization.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' For more information about \code{md5hash} see \link{md5hash}.
#' 
#' @param repoType A character containing a type of the remote repository. Currently it can be 'github' or 'bitbucket'.
#'
#' @param md5hash A character assigned to the artifact through the use of a cryptographical hash function with MD5 algorithm. 
#' If it is specified in a format of \code{'repo/user/md5hash'} then \code{user} and \code{repo} parameters are omitted.
#' 
#' @param repo The Remote \code{Repository} on which the artifact that we want to download
#' is stored.
#' 
#' @param user The name of a user on whose \code{Repository} the the artifact that we want to download
#' is stored.
#' 
#' @param subdir A character containing a name of a directory on the Remote repository 
#' on which the Repository is stored. If the Repository is stored in the main folder on the Remote repository, this should be set 
#' to \code{subdir = "/"} as default.
#' 
#' @param branch A character containing a name of the Remote Repository's branch
#' on which the Repository is archived. Default \code{branch} is \code{master}.
#' 
#' @param format In which format the link should be returned. Possibilites are \code{markdown} (default) or \code{latex}.
#' 
#' @param rawLink A logical denoting whether to return raw link or a link in the \code{format} convention. 
#' Default value is \code{FALSE}.
#' 
#' @return This function returns a link to download artifact that is archived on GitHub.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @examples
#' # link in markdown format
#' alink('pbiecek/archivist/134ecbbe2a8814d98f0c2758000c408e')
#' # link in markdown format with additional subdir
#' alink(user='BetaAndBit',repo='PieczaraPietraszki',
#'      md5hash = '1569cc44e8450439ac52c11ccac35138', 
#'      subdir = 'UniwersytetDzieci/arepo')
#' # link in latex format
#' alink(user = 'MarcinKosinski', repo = 'Museum',
#'       md5hash = '1651caa499a2b07a3bdad3896a2fc717', format = 'latex')
#' # link in raw format
#' alink('pbiecek/graphGallery/f5185c458bff721f0faa8e1332f01e0f', rawLink = TRUE)  
#' alink('pbiecek/graphgallerygit/02af4f99e440324b9e329faa293a9394', repoType='bitbucket')  
#' @family archivist
#' @rdname alink
#' @export
alink <- function(md5hash, repo = aoptions('repo'),
                  user = aoptions('user'),
                  subdir = aoptions('subdir'), branch = "master", repoType = aoptions("repoType"),
                  format = "markdown", rawLink = FALSE) {
  
  stopifnot(is.character(md5hash) & length(md5hash) == 1)
  stopifnot(is.character(format) & length(format) == 1 | format %in% c('markdown', 'latex'))
  stopifnot(is.logical(rawLink) & length(rawLink) == 1)
  
  elements <- strsplit(md5hash, "/")[[1]]
  if ( length(elements)  >= 3 ) {
    archLINK <- getRemoteHookToFile(user=elements[1], repo=elements[2], branch=branch, 
                                    subdir=ifelse(length(elements) == 3, "/", paste(elements[-c(1,2,length(elements))], collapse="/")), 
                                    repoType=repoType, 
                                    file=paste0("gallery/",elements[length(elements)],".rda"))
  } else {
    RemoteRepoCheck( repo, user, branch, subdir, repoType) # implemented in setRepo.R
    archLINK <- getRemoteHookToFile(repo=repo, user=user, branch=branch, 
                                    subdir=subdir, repoType=repoType, 
                                    file=paste0("gallery/",md5hash,".rda"))
  }
  
  if ( rawLink ) {
    resLINK <- archLINK
  } else {
    if ( format == "markdown" ){
      resLINK <- paste0('[`',
             aread_command(md5hash, user, repo, subdir), '`](', archLINK, ')') 
    } else {
      resLINK <- paste0('\\href{',
             archLINK, '}{', aread_command(md5hash, user, repo, subdir), '}')
    }
  }
  class(resLINK) <- 'alink'
  return(resLINK)
  
}


aread_command <- function(md5hash, user, repo, subdir) {
  paste0("archivist::aread('",
        ifelse(length(strsplit(md5hash, "/")[[1]]) >= 3,
               md5hash,
               file.path(user, repo, 
                         # required to handle subdir
                         ifelse(subdir == "/", 
                                md5hash, 
                                paste0(subdir,"/",md5hash))
               )),
        "')") 
}

#' @export
print.alink <- function(x, ...) {
  cat(x)
}
