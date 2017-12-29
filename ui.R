library(shiny)
library(tm)
library(stringr)
library(markdown)
library(dplyr)

# UI files and codes required for Shiny App

setwd("C:/Users/dhira/OneDrive/Documents/Coursera/Data Science/Course 10 Capstone Project")

  shinyUI(navbarPage("Data Capstone: Coursera Project",
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
  )