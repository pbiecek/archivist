library(shiny)
library(archivist)
library(ggplot2)

shinyUI(fluidPage(
  titlePanel("Example integration of Shiny and archivist"),
  p("Objects generated in Shiny are saved to the archivist repository and accessible with presented hooks."),
  br(),
  fluidRow(
    column(6,
      selectInput("var2", "Variable on OY:", colnames(iris), "Sepal.Width")),
    column(6,
      selectInput("var1", "Variable on OX:", colnames(iris), "Sepal.Length"))
    ),
    fluidRow(                                                          
    column(12,                                                         
      plotOutput("plotIt"),                                            
      uiOutput("printArchivistHooks"))                                 
    )                                                                  
  )                                                                    
)                                                                      
