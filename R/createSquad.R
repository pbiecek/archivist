createSquad <- function(vlinks) {
  require(RCurl)
  require(evaluate)

  squad <- lapply(vlinks, function(link) {
    link <- gsub(link, pattern="https://github", replacement="https://raw.github")
    instructions <- getURL(paste0(link, "/load.R"))
    tmp <- evaluate(instructions)
    list(plotObj = object, link = link)
  })
  
  class(squad) <- "squad"
  squad
}

# link <- "https://github.com/pbiecek/graphGallery/master/8d8eeaeab18d3650bb74162ff7e5405b"
