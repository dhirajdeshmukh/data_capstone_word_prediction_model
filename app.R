
library(shiny) 
library(tm)
library(NLP)
library(stringr)
library(markdown)
library(dplyr)
 


server <-  function(input, output) {
  
  quadgram <- readRDS("quadgram.RData");
  trigram <- readRDS("trigram.RData");
  bigram <- readRDS("bigram.RData");
  mesg <<- ""
  
  Predict <- function(x) {
    xclean <- removeNumbers(removePunctuation(tolower(x)))
    xs <- strsplit(xclean, " ")[[1]]
    
    if (length(xs)>= 3) {
      xs <- tail(xs,3)
      if (identical(character(0),head(quadgram[quadgram$unigram == xs[1] & quadgram$bigram == xs[2] & quadgram$trigram == xs[3], 4],1))){
        Predict(paste(xs[2],xs[3],sep=" "))
      }
      else {mesg <<- "Next word is predicted using 4-gram."; head(quadgram[quadgram$unigram == xs[1] & quadgram$bigram == xs[2] & quadgram$trigram == xs[3], 4],1)}
    }
    else if (length(xs) == 2){
      xs <- tail(xs,2)
      if (identical(character(0),head(trigram[trigram$unigram == xs[1] & trigram$bigram == xs[2], 3],1))) {
        Predict(xs[2])
      }
      else {mesg<<- "Next word is predicted using 3-gram."; head(trigram[trigram$unigram == xs[1] & trigram$bigram == xs[2], 3],1)}
    }
    else if (length(xs) == 1){
      xs <- tail(xs,1)
      if (identical(character(0),head(bigram[bigram$unigram == xs[1], 2],1))) {mesg<<-"No match found. Most common word 'the' is returned."; head("the",1)}
      else {mesg <<- "Next word is predicted using 2-gram."; head(bigram[bigram$unigram == xs[1],2],1)}
    }
  }
  
  output$prediction <- renderPrint({
    result <- Predict(input$inputString)
    output$text2 <- renderText({mesg})
    result
  });
  
  output$text1 <- renderText({
    input$inputString});
} 

ui <-  navbarPage("Data Capstone: Coursera Project",
                   tabPanel("Next Word Prediction App",
                            HTML("<strong>Author: Dhiraj Deshmukh </strong>"),
                            br(),
                            HTML("<strong>Date: 12/29/2017</strong>"),
                            br(),
                            br(),
                            img(src="https://cdnswiftkeycom.swiftkey.com/images/misc/logo.png", height=80, width=200),
                            img(src="http://media.tumblr.com/92a71d62ace9940f8ddd540400444fc4/tumblr_inline_mppo32jFBC1qz4rgp.png", height=110, width=200),
                            img(src="http://brand.jhu.edu/content/uploads/2014/06/university.logo_.small_.horizontal.blue_.jpg", height=120, width=200), 
                            br(),
                            br(),
                            # Sidebar
                            sidebarLayout(
                              sidebarPanel(
                                helpText("Enter sentence to begin the next word prediction"),
                                textInput("inputString", "Enter a phrase (multiple words) here",value = ""),
                                br(),
                                br(),
                                br(),
                                br()
                              ),
                              mainPanel(
                                h2("Next Word Predicted"),
                                verbatimTextOutput("prediction"),
                                strong("Input Statement:"),
                                tags$style(type='text/css', '#text1 {background-color: yellow; color: Black;}'), 
                                textOutput('text1'),
                                br() 
                              )
                            )
                            
                   ) 
) 


shinyApp(ui = ui, server = server)