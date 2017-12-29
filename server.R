library(shiny)
library(tm)
library(stringr)
library(markdown)
library(dplyr)

source("./predict_word.R")

server <- shinyServer(function(input, output) {
  output$prediction <- renderPrint({
    result <- Predict(input$inputString)
    output$text2 <- renderText({mesg})
    result
  });
  
  output$text1 <- renderText({
    input$inputString});
}
)
