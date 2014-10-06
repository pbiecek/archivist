##    archivist package for R
##
#' @title Shiny Based Live Search for an Artifact in a Repository Using Tags 
#'
#' @description
#' \code{shinySearchInLocalRepo} searches for an artifact in a \link{Repository} using it's \link{Tags}.
#' An shiny base application is generated in the fly with an text input field.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' \code{shinySearchInLocalRepo} searches for an artifact in a Repository using it's \code{Tag} 
#' (e.g., \code{name}, \code{class} or \code{archiving date}). \code{Tags} are submitted in a 
#' text input in a shiny application. Many tags may be specified, they should be comma separated.
#' 
#' \code{Tags}, submitted in the text field, should be given according to the 
#' format: \code{"TagType:TagTypeValue"} - see examples.
#'   
#' @return
#' \code{shinySearchInLocalRepo} runs a shiny application.
#' 
#' @param repoDir A character denoting an existing directory in which artifacts will be searched.
#' 
#' @param host A host IP adress, see the \code{host} argument in \code{shiny::runApp}.
#' 
#' @author
#' Przemyslaw Biecek, \email{przemyslaw.biecek@@gmail.com}
#'
#' @examples
#' \dontrun{
#'   # assuming that there is a 'repo' dir with a valid archivist repository
#'   shinySearchInLocalRepo( dir = 'repo' )
#' }
#' @family archivist
#' @rdname shinySearchInRepo
#' @export
shinySearchInLocalRepo <- function( repoDir, host = '0.0.0.0' ){
  stopifnot( is.character( repoDir ) )

  runApp(list(
    ui = shinyUI(fluidPage(
      tags$head(
        tags$style(HTML("div.span4 {
                        width: 300px!important;
}"))),
    
      titlePanel(paste0("Live search in the ",repoDir)),
      sidebarLayout(
        sidebarPanel(
          textInput("search","Comma separated tags",value = "class:ggplot"),
          sliderInput("width", "Image width", min=100, max=800, value=400)),
        mainPanel(
          uiOutput("plot")
        )
      )
        )),
    server = function(input, output) {
      output$plot <- renderUI({ 
        tags <- strsplit(input$search, split=" *, *")[[1]]
        md5s <- multiSearchInLocalRepo( tags, repoDir, fixed = FALSE, intersect = TRUE )
        
        addResourcePath(
          prefix="repo", 
          directoryPath=paste0(getwd(),"/",repoDir))
        
        res <- ""
        if (length(md5s) > 0) {
          res <-  paste(
            paste0("<a href='repo/gallery/", md5s, ".rda'><img width=",input$width," src='repo/gallery/", md5s, ".png'/></a>"), 
            collapse="")
        } 
        
        HTML(res)
      })
    }
  ), host = host)
  
}
