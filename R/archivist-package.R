##    archivist package for R
##
#' @title Tools for Storing, Restoring and Searching for R Objects
#'
#' @description
#' Data exploration and modelling is a process in which a lot of data artifacts are produced. 
#' Artifacts like: subsets, data aggregates, plots, statistical models, different  versions of data sets and different versions of results. 
#' The more projects we work on, the more artifacts are produced and the harder it is to manage these artifacts. 
#' 
#' Archivist helps to store and manage artifacts created in R.
#' 
#' Archivist allows you to store selected artifacts as binary files
#' along with their metadata and relations.
#' Archivist allows you to share artifacts with others, either through a shared folder or github.
#' Archivist allows you to look for artifacts by using its class, 
#' name, date of creation or other properties.
#' It also facilitates restoring such artifacts.
#' Archivist allows you to check if a new artifact is the exact 
#' copy of the one that was produced some time ago.
#' This might be useful either for testing or caching.
#'
#' The list of main use cases is available here \href{https://github.com/pbiecek/archivist}{https://github.com/pbiecek/archivist}.
#'
#'
#' @details
#' For more detailed information visit \pkg{archivist} \code{wiki} on 
#' \href{https://github.com/pbiecek/archivist/wiki}{Github}.
#'
#' @author
#' Przemyslaw Biecek [aut, cre] \email{przemyslaw.biecek@@gmail.com} \cr
#' Marcin Kosinski [aut] \email{m.p.kosinski@@gmail.com}
#' 
#' @importFrom RCurl getBinaryURL
#' @importFrom RCurl url.exists
#' @import httr
#' @importFrom DBI dbWriteTable
#' @importFrom DBI dbGetQuery
#' @importFrom DBI dbDisconnect
#' @importFrom DBI dbConnect
#' @importFrom DBI dbReadTable
#' @importFrom DBI dbDriver
#' @importFrom DBI dbUnloadDriver
#' @importClassesFrom RSQLite SQLiteDriver
#' @importFrom RSQLite SQLite
#' @importFrom lubridate now
#' @importFrom digest digest
#' @importFrom grDevices dev.off
#' @importFrom grDevices png
#' @importFrom graphics barplot
#' @importFrom graphics par
#' @importFrom graphics plot
#' @importFrom utils head
#' @importFrom utils zip
#' @importFrom utils tail
#' @importFrom utils getAnywhere
#' @importFrom utils installed.packages
#'
#' @family archivist
#' @name archivist-package
#' @docType package
invisible(NULL)
#' Pipe operator
#'
#' See \code{\link[magrittr]{\%>\%}} for more details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL
