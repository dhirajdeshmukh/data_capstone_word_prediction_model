Coursera Data Science Capstone: Predict Next Word Model
========================================================
author: Dhiraj Deshmukh
date: 12/30/2017
autosize: true

Introduction
======================================================== 
- The main objective of this project is to build the model using R code and Shiny application which will predict the next word based on the input which could be a word or multiple words provided by user. 

- This kind of application will be very useful for a keyboard on a mobile device by predicting what next word would be based on what user is currently typing.
The data used in this model was provided by swiftkey on Coursera data science capstone.

- [Shiny App] (https://ddshmkh.shinyapps.io/predictnextword2/) which accept the input string and predict the next word -  
 

- [Git Hub] (https://github.com/dhirajdeshmukh/data_capstone_word_prediction_model) includes all required scripts

Next couple of slides mention the steps and algorithm used in this model and how shiny app works


Getting and Cleaning Data
========================================================
- Prepare the data for the model 

    As mentioned earlier three data files (Blogs, News and Twitter) are used. But since these files are very large, sample data from each file is extracted. (example - sample(blogs, length(blogs)*0.1))

- Clean data set 

    Data needs to be cleaned as it contains lots of symbols, bad words, punctuations, white spaces and so on. So removing the following from the data and then use it.
    
    Convert to lower case
    
    Remove non english characters
    
    Remove punctuations and double quotes
    
    Remove Symbols, Numbers and White spaces
     
    Remove profanity words

N Gram Data Model and Algorithm
========================================================
- Prepare N gram model 

    N-gram is a contiguous sequence of n items from a given sequence of text or speech.
    
    It will have # of rows with two distinct columns.
    
    One with the word and second with the frequency of that word in the data set.So in Unigram first column will have a word and second column will have the number of occurences of that word in the data set. In Bigram, first and second columns will have one word each and third column will have the number of occurences of those two words in data set and so on. 
    
    In this project models from 1 gram to 4 grams are generated.

- Back off Algorithm

    To predict the next word based on previous N words, Quadgram is used first. 
    
    If input words (last three words) are not found in Quadgram, it back off to Trigram. 
    If input words (last two words) are not found in Trigram it back off to Bigram. 
    If Input words (last word) are not found in Bigram, it back off to the most common word "the" with highest frequency is returned. 


Instructions on how to use the Shiny App
========================================================
- In the below image of app, enter the text a word or multiple words in the left box (with arrow) and the predicted word will be displayed at the right boc under "Next Word Predicted"

![Alt text] (Instruction.png)

