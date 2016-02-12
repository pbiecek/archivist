##    code copied from http://cran.r-project.org/web/packages/magrittr/
##    package binaries - version 1.0.1
##
#' @title magrittr - a Forward-Pipe Operator for R
#'
#' @description
#' An extended pipe operator \link[magrittr]{\%>\%} from magrittr package version 1.0.1.
#' Enables archiving artifacts with their chaining code - see examples and vignettes.
#' 
#' @param lhs An artifact that will be used as an argument of \code{rhs} by 
#' \code{\%a\%} operator.
#' 
#' @param rhs A function call using \code{lhs} as an argument by
#' \code{\%a\%} operator.
#' 
#' @details
#' The extension works as follows, the result of \code{\%a\%} operator is archived together 
#' with lhs (as an artifact) and rhs (as a Tag). This allows to present a history of
#' an artifact. This option works only if a default repository is set.
#'
#' @examples 
#' \dontrun{
#' 
#' library(dplyr)
#' 
#' ## Usage of %a% operator without setting default repository
#' # We will receive sepcial warning
#' iris %a% summary()
#' 
#' ## Archiving artifacts with their chaining code
#' # Creating empty repository
#' exampleRepoDir <- tempfile()
#' createLocalRepo( exampleRepoDir, default = TRUE ) # Remember to set repo to default
#' 
#' # Start using %a% operator
#' data("hflights", package = "hflights")
#' hflights %a%
#'   group_by(Year, Month, DayofMonth) %a%
#'   select(Year:DayofMonth, ArrDelay, DepDelay) %a%
#'   summarise(arr = mean(ArrDelay, na.rm = TRUE),
#'             dep = mean(DepDelay, na.rm = TRUE)) %a%
#'   filter(arr > 30 | dep > 30)
#'   
#' # Let's check how Tags of subsequent artifacts look like
#' showLocalRepo()
#' getTagsLocal("a8ce013a8e66df222be278122423dc60", tag = "") #1
#' getTagsLocal("9d91fe67fd51f3bfdc9db0a596b12b38", tag = "") #2
#' getTagsLocal("617ded4953ac986524a1c24703363980", tag = "") #3
#' getTagsLocal("3f1ac0a27485be5d52e1b0a41d165abc", tag = "") #4
#' getTagsLocal("0cb04315482de73d7f5a1081953236f8", tag = "") #5
#' getTagsLocal("5629bc43e36d219b613076b17c665eda", tag = "") #6
#' 
#' # Deleting existing repository
#' deleteLocalRepo(exampleRepoDir, deleteRoot = TRUE)
#' rm(exampleRepoDir) 
#' }
#' @family archivist
#' @rdname magrittr
#' @export
`%a%` <-
  function(lhs, rhs)
  {
    # Capture unevaluated arguments
    lhs <- substitute(lhs)
    rhs <- substitute(rhs)
    rhs_name <- paste(deparse(rhs), collapse = "")
    lhs_name <- paste(deparse(lhs), collapse = "")

    # Should rhs be evaluated first due to parentheses?
    if (is.call(rhs) && identical(rhs[[1]], quote(`(`)))
      rhs <- eval(rhs, parent.frame(), parent.frame())
    
    # Check right-hand side
    if (!any(is.symbol(rhs), is.call(rhs), is.function(rhs)))
      stop("RHS should be a symbol, a call, or a function.")
    
    # In remaining cases, LHS will be evaluated and stored in a new environment.
    env <- parent.frame()
    
    # Find an appropriate name to use for evaluation:
    #   deparse(lhs) is useful for preserving the call
    #   but is not always feasible, in which case __LHS is used.
    #   It is also necessary to restrict the size of the name
    #   for a few special cases.
    nm <- "__LHS"
    
    # carry out assignment.
    env[[nm]] <- eval(lhs, env)
    
    if (is.function(rhs)) {
      
      # Case of a function: rare but possible
      res <- withVisible(rhs(env[[nm]]))
      
    } else if (is.call(rhs) && deparse(rhs[[1]]) == "function") {
      
      # Anonymous function:
      res <- withVisible(eval(rhs, parent.frame(), parent.frame())(
        eval(lhs, parent.frame(), parent.frame())))
      
    } else {
      
      # Construct the final expression to evaluate from lhs and rhs. Scenarios:
      #  1)  rhs is a function name and parens are omitted.
      #  2a) rhs has one or more dots that qualify as placeholder for lhs.
      #  2b) lhs is placed as first argument in rhs call.
      if (is.symbol(rhs)) {
        
        if (!exists(deparse(rhs), parent.frame(), mode = "function"))
          stop("RHS appears to be a function name, but it can not be found.")
        e <- call(as.character(rhs), as.name(nm)) # (1)
        
      } else {
        
        # Find arguments that are just a single .
        dots <- c(FALSE, vapply(rhs[-1], identical, quote(.), FUN.VALUE = logical(1)))
        if (any(dots)) {
          # Replace with lhs
          rhs[dots] <- rep(list(as.name(nm)), sum(dots))
          e <- rhs
        } else {
          
          # Otherwise insert in first position
          e <- as.call(c(rhs[[1]], as.name(nm), as.list(rhs[-1])))
        }
      }
      res <- withVisible(eval(e, envir=env))
    }
    # here saveToRepo res
    # if no local repository is set then rise a warning
    if (!exists( "repoDir", envir = .ArchivistEnv )) {
      warning("Default local repo is not set. Results are not archived.")
    } else {
      # for the output save both RHS as an object
      # and LHS as an instruction
      tag_rhs <- paste0("RHS:",rhs_name)
      tag_lhs <- paste0("LHS:",saveToRepo(env[[nm]], archiveData = FALSE, userTags = paste0("name:",lhs_name), rememberName = FALSE))
      # save the result
      res_val <- res$value
      saveToRepo(res_val, archiveData = FALSE, userTags = c(tag_lhs, tag_rhs), rememberName = FALSE)
    }
    
    res$value
  }
