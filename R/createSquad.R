createSquad <- function(vlinks) {
  require(RCurl)
  require(evaluate)

  squad <- lapply(vlinks, function(link) {
    link <- gsub(link, pattern="https://github", replacement="https://raw.github")
    instructions <- getURL(paste0(link, "/load.R"))
    plotObj <- evaluate(instructions)
    list(plotObj = plotObj, link = link)
  })
  
  class(squad) <- "squad"
  squad
}

