##    archivist package for R
##
#' @title Shiny Based Live Search for an Artifact in a Repository Using Tags 
#'
#' @description
#' \code{shinySearchInLocalRepo} searches for an artifact in a \link{Repository} using \link{Tags}.
#' To create an application one needs to point the name of artifacts repository.
#' The application is generated on the fly. Right now two controllers are exposed. 
#' A text input field and a slider. Tags that are typed into text field are used for searching in repository. 
#' Object that have same tags are then presented on right panel.
#' These object might be also downloaded just by click.
#' To learn more about artifacts visit \link[archivist]{archivist-package}.
#' 
#' @details
#' \code{shinySearchInLocalRepo} searches for artifacts in a Repository using their's \code{Tag} 
#' (e.g., \code{name}, \code{class} or \code{archiving date}). \code{Tags} are submitted in a 
#' text input in a shiny application. Many tags may be specified, they should be comma separated. 
#' User can specify more tags when artifact is created, tags like phase, project, author etc.
#' 
#' In the search query one can add tags started with sort: or sort:-
#' then miniatures will be sorted accordingly.
#' For exaple sort:class will sort along class tag, while sort:-class backward.
#' sort:createdDate will sort along createdDate and sort:-createdDate backward.
#' 
#' \code{Tags}, submitted in the text field, should be given according to the 
#' format: \code{"TagType:TagTypeValue"} - see examples.
#'   
#' @return
#' \code{shinySearchInLocalRepo} runs a shiny application.
#' 
#' @param repoDir A character denoting an existing directory in which artifacts will be searched.
#' If set to \code{NULL} (by default), uses the \code{repoDir} specified in \link{setLocalRepo}.
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
shinySearchInLocalRepo <- function( repoDir=NULL, host = '0.0.0.0' ){
  stopifnot( is.character( repoDir ) | is.null( repoDir ) )

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
        sortTags <- grep(tags, pattern="^sort:")
        # tags with sort: key should be removed from search
        if (length(sortTags) > 0) {
          md5s <- multiSearchInLocalRepo( tags[-sortTags], repoDir, fixed = FALSE, intersect = TRUE )
        } else {
          md5s <- multiSearchInLocalRepo( tags, repoDir, fixed = FALSE, intersect = TRUE )
        }
        # should we sort results
        if (length(sortTags) > 0 & length(md5s) > 0) {
          allTags <- showLocalRepo(repoDir, method = "tags")
          selectedTags <- allTags[allTags$artifact %in% md5s,]
          if (tags[sortTags[1]] == "sort:createdDate") {
            md5s <- unique(selectedTags$artifact[order(selectedTags$createdDate)])
          } else {
            if (tags[sortTags[1]] == "sort:-createdDate") {
              md5s <- unique(selectedTags$artifact[order(selectedTags$createdDate, decreasing = TRUE)])
            } else {
              # if there is - before sort condition
              key <- substr(tags[sortTags[1]], 6, 1000)
              if (substr(key, 1, 1) == "-") {
                tmpTags <- selectedTags[grep(selectedTags$tag,pattern = substr(key, 2, 1000)),,drop=FALSE]
                md5s <- unique(tmpTags[order(tmpTags$tag, na.last = TRUE),"artifact"])
              } else {
                tmpTags <- selectedTags[grep(selectedTags$tag,pattern = key),,drop=FALSE]
                md5s <- unique(tmpTags[order(tmpTags$tag),"artifact"])
              }
            }
          }
        }
        
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
