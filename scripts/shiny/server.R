library(shiny)
library(archivist)
library(ggplot2)

# [a] archivist repo
# create if not exist, or set as default if exists
if (!file.exists("www/arepo")) {
  createLocalRepo("www/arepo", default = TRUE)
} else {
  setLocalRepo("www/arepo")
}


shinyServer(function(input, output) {
  # create a plot...
  createPlot <- reactive({
    var1 <- input$var1
    var2 <- input$var2
    ggplot(iris, aes_string(var1, var2, color="Species")) +
      geom_point() + geom_smooth(method="lm", se=FALSE)
  })

  # just plot the plot
  output$plotIt <- renderPlot({
    createPlot()
  })
  # add the plot to repository and print it's link
  output$printArchivistHooks <- renderUI({
    pl <- createPlot()
    hash <- saveToRepo(pl)
    HTML(paste0("<i>Get the object:</i><br/><code>archivist::aread('http://mi2.mini.pw.edu.pl:8080/archivist/arepo/",hash,"')</code>"))
  })
})
