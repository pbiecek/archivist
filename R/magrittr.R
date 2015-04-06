##    code copied from http://cran.r-project.org/web/packages/magrittr/
##    package binaries - version 1.0.1
##
#' @title magrittr - a forward-pipe operator for R
#'
#' @description
#' A copied pipe operator \link[magrittr]{\%>\%} from magrittr package version 1.0.1.
#' Enables archiving artifacts with their chaining code - see examples and vignettes.
#' 
#' 
#' @examples 
#' \dontrun{
#' iris %a% summary()
#' 
#' # Archiving artifacts with their chaining code
#' 
#' library(dplyr)
#' exampleRepoDir <- getwd()
#' createEmptyRepo( exampleRepoDir )
#' 
#' data("hflights", package = "hflights")
#' hflights %a%
#'   group_by(Year, Month, DayofMonth) %a%
#'   select(Year:DayofMonth, ArrDelay, DepDelay) %a%
#'   summarise(
#'     arr = mean(ArrDelay, na.rm = TRUE),
#'     dep = mean(DepDelay, na.rm = TRUE)
#'   ) %a%
#'   filter(arr > 30 | dep > 30) %a%
#'   saveToRepo( exampleRepoDir )
#' showLocalRepo(getwd())
#' 
#' 
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
    
    # Should rhs be evaluated first due to parentheses?
    if (is.call(rhs) && identical(rhs[[1]], quote(`(`)))
      rhs <- eval(rhs, parent.frame(), parent.frame())
    
    # Check right-hand side
    if (!any(is.symbol(rhs), is.call(rhs), is.function(rhs)))
      stop("RHS should be a symbol, a call, or a function.")
    
    # In remaining cases, LHS will be evaluated and stored in a new environment.
    env <- new.env(parent = parent.frame())
    
    # Find an appropriate name to use for evaluation:
    #   deparse(lhs) is useful for preserving the call
    #   but is not always feasible, in which case __LHS is used.
    #   It is also necessary to restrict the size of the name
    #   for a few special cases.
    nm <- paste(deparse(lhs), collapse = "")
    nm <- if (nchar(nm) < 9900 && (is.call(lhs) || is.name(lhs))) nm else "__LHS"
    
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
          stop("RHS appears to be a function name, but it cannot be found.")
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
      
      res <- withVisible(eval(e, env))
    }
    
    if (res$visible) res$value else invisible(res$value)
  }