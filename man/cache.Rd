% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cache.R
\name{cache}
\alias{cache}
\title{Enable Caching of the Function Results with the use of Archivist}
\usage{
cache(cacheRepo = NULL, FUN, ..., notOlderThan = NULL)
}
\arguments{
\item{cacheRepo}{A repository used for storing cached objects.}

\item{FUN}{A function to be called.}

\item{...}{Arguments of \code{FUN} function .}

\item{notOlderThan}{load an artifact from the database only if it was created after notOlderThan.}
}
\value{
Result of the function call with additional attributes: \code{tags} - md5 hash of the
function call and \code{call} - "".
}
\description{
\code{cache} function stores all results of function calls in local \link{Repository}.
All results are stored together with md5 hashes of the function calls.
If a function is called with the same arguments, then its results can be loaded
from the repository.

One may specify expiration date for live objects. 
It may be useful for objects that can be changed externally (like queries to database).
}
\details{
\code{cache} function stores all results of function calls in local \link{Repository} 
specified by the \code{cacheRepo} argument.
The md5 hash of \code{FUN} and it's arguments is added as a Tag to the repository.
This Tag has the following structure "cacheId:md5hash".
Note that \code{cache} is a good solution if objects are not that big but calculations
are time consuming (see \code{Examples}). If objects are big and calculations are easy, then
disk input-output operations may take more time than calculations itself.
}
\section{Contact}{

 
Bug reports and feature requests can be sent to 
\href{https://github.com/pbiecek/archivist/issues}{https://github.com/pbiecek/archivist/issues}
}

\examples{
\dontrun{

# objects preparation
library("lubridate")
cacheRepo <- tempfile()
createLocalRepo( cacheRepo )

## Example 1:
# cache is useful when objects used by FUN are not that big but calculations
# are time-comsuming. Take a look at this example:
fun <- function(n) {replicate(n, summary(lm(Sepal.Length~Species, iris))$r.squared)}

# let's check time of two evaluations of cache function
system.time( res <- cache(cacheRepo, fun, 1000) )
system.time( res <- cache(cacheRepo, fun, 1000) ) 
# The second call is much faster. Why is it so? Because the result of fun
# function evaluation has been stored in local cacheRepo during the first evaluation
# of cache. In the second call of cache we are simply loading the result of fun
# from local cacheRepo Repository.

## Example 2:
testFun <- function(x) {cat(x);x}

# testFun will be executed and saved to cacheRepo
tmp <- cache(cacheRepo, testFun, "Say hallo!")

# testFun execution will be loaded from repository
tmp <- cache(cacheRepo, testFun, "Say hallo!")

# testFun will be executed once again as it fails with expiration date. It will
# be saved to cacheRepo.
tmp <- cache(cacheRepo, testFun, "Say hallo!", notOlderThan = now())

# testFun execution will be loaded from repository as it
# passes with expiration date [within hour]
tmp <- cache(cacheRepo, testFun, "Say hallo!", notOlderThan = now() - hours(1))

deleteLocalRepo( cacheRepo, TRUE)
rm( cacheRepo )

}

}
\references{
Biecek P and Kosinski M (2017). "archivist: An R Package for Managing,
Recording and Restoring Data Analysis Results." _Journal of Statistical
Software_, *82*(11), pp. 1-28. doi: 10.18637/jss.v082.i11 (URL:
http://doi.org/10.18637/jss.v082.i11).
URL https://github.com/pbiecek/archivist
}
\seealso{
For more detailed information, check the \pkg{archivist} package 
\href{https://github.com/pbiecek/archivist#-the-list-of-use-cases-}{Use Cases}.

Other archivist: 
\code{\link{Repository}},
\code{\link{Tags}},
\code{\link{\%a\%}()},
\code{\link{addHooksToPrint}()},
\code{\link{addTagsRepo}()},
\code{\link{aformat}()},
\code{\link{ahistory}()},
\code{\link{alink}()},
\code{\link{aoptions}()},
\code{\link{archivistPackage}},
\code{\link{aread}()},
\code{\link{areadLocal}()},
\code{\link{asearch}()},
\code{\link{asearchLocal}()},
\code{\link{asession}()},
\code{\link{atrace}()},
\code{\link{copyLocalRepo}()},
\code{\link{createLocalRepo}()},
\code{\link{createMDGallery}()},
\code{\link{deleteLocalRepo}()},
\code{\link{getRemoteHook}()},
\code{\link{getTagsLocal}()},
\code{\link{loadFromLocalRepo}()},
\code{\link{md5hash}},
\code{\link{removeTagsRepo}()},
\code{\link{restoreLibs}()},
\code{\link{rmFromLocalRepo}()},
\code{\link{saveToLocalRepo}()},
\code{\link{searchInLocalRepo}()},
\code{\link{setLocalRepo}()},
\code{\link{shinySearchInLocalRepo}()},
\code{\link{showLocalRepo}()},
\code{\link{splitTagsLocal}()},
\code{\link{summaryLocalRepo}()},
\code{\link{zipLocalRepo}()}
}
\author{
Przemyslaw Biecek, \email{Przemyslaw.Biecek@gmail.com}
}
\concept{archivist}
