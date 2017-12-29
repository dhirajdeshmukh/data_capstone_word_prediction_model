 # setting up the working directory at local machine 
setwd("C:/Users/dhira/OneDrive/Documents/Coursera/Data Science/Course 10 Capstone Project") 

## 2. Loading Required Packages 
library(dplyr)
library(doParallel)
library(stringi)
library(tm)
library(NLP)
library(rJava)
library(RWeka)
library(RWekajars)
library(ggplot2)
library(wordcloud)
library(SnowballC) 

## 3. Download the data file from Coursera-Swiftkey if it already does not exist 
if (!file.exists("Coursera-SwiftKey.zip"))  
{ 
  download.file
  ("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip")   
  unzip("Coursera-SwiftKey.zip") 
} 

## 4. Reading Data files 
# read lines in files
blogs <- readLines("final/en_US/en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE)
news <- readLines("final/en_US/en_US.news.txt", encoding = "UTF-8", skipNul = TRUE)
twitter <- readLines("final/en_US/en_US.twitter.txt", encoding = "UTF-8", skipNul = TRUE) 
 
# get size of files
blogs.size <- file.info("final/en_US/en_US.blogs.txt")$size / 1024 ^ 2
news.size <- file.info("final/en_US/en_US.news.txt")$size / 1024 ^ 2
twitter.size <- file.info("final/en_US/en_US.twitter.txt")$size / 1024 ^ 2

# get the words in files  
blogs.words <- stri_count_words(blogs)
news.words <- stri_count_words(news)
twitter.words <- stri_count_words(twitter) 

### 4.1 Summary
#####  Summay of all files in terms of lines, words, size (in MB) and mean number of words 
data.frame(source = c("blogs", "news", "twitter"),
           file.size.MB = c(blogs.size, news.size, twitter.size),
           num.lines = c(length(blogs), length(news), length(twitter)),
           num.words = c(sum(blogs.words), sum(news.words), sum(twitter.words)),
           mean.num.words = c(mean(blogs.words), mean(news.words), mean(twitter.words))) 

## 5. Sample Data
##### Since the data set is very large, the sample of the data set is taken so that the exploratory analysis can be done on it.  
# writing a sample blog data into a local machine
set.seed(6789)
sampleblogs <- sample(blogs, length(blogs)*0.1)
write.table(sampleblogs, "./corpus/sampleblogs.txt", row.names = FALSE, col.names = FALSE)

set.seed(6789)
# writing a sample news data into a local machine
samplenews <- sample(news, length(news)*0.1)
write.table(samplenews, "./corpus/samplenews.txt", row.names = FALSE, col.names = FALSE)

# writing a sample twitter data into a local machine
set.seed(6789)
sampletwitter <- sample(twitter, length(twitter)*0.1)
write.table(sampletwitter, "./corpus/sampletwitter.txt", row.names = FALSE, col.names = FALSE)

## 6. Corpus Data 
##### Create corpus of the combined sample data and then clean the data using tm_map for the analysis.


badWords = c()
profanityFile = file("./profanity_words.txt", "r")
badWords = readLines(profanityFile)
close(profanityFile)

# create volatile corpus object of all sample files created above
corpus <- VCorpus(DirSource(directory = "corpus",encoding = "UTF-8")) 

toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x)) 

corpus <- tm_map(corpus, toSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+")

# remove extra spaces
corpus <- tm_map(corpus, toSpace, "@[^\\s]+")

corpus <- tm_map(corpus, toSpace, "\"")

# convert string to lower case
corpus <- tm_map(corpus, content_transformer(tolower)) 

# remove english stopwords
corpus <- tm_map(corpus, removeWords, stopwords("en"))

corpus <- tm_map(corpus, removeWords, badWords) 

# stripe whitespaces
corpus  <- tm_map(corpus, stripWhitespace)

# remove numbers from corpus
corpus <- tm_map(corpus, removeNumbers) 

# remove punctuations from corpus
corpus <- tm_map(corpus, removePunctuation)

# create plain text document
corpus <- tm_map(corpus, PlainTextDocument) 
 
# function to create n gram data frame
ngram_sorted_df <- function (tdm_ngram) {
  tdm_ngram_m <- as.matrix(tdm_ngram)
  tdm_ngram_df <- as.data.frame(tdm_ngram_m)
  colnames(tdm_ngram_df) <- "Count"
  tdm_ngram_df <- tdm_ngram_df[order(-tdm_ngram_df$Count), , drop = FALSE]
  tdm_ngram_df
}

# Quadgram Model
quadgramtoken <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))  
quadgramfreq <- TermDocumentMatrix(corpus, control = list(tokenize = quadgramtoken)) 
tdm_4gram_df <- ngram_sorted_df(quadgramfreq) 
quadgram <- data.frame(rows=rownames(tdm_4gram_df),count=tdm_4gram_df$Count)
quadgram$rows <- as.character(quadgram$rows)
quadgram_split <- strsplit(as.character(quadgram$rows),split=" ")
quadgram <- transform(quadgram,first = sapply(quadgram_split,"[[",1),second = sapply(quadgram_split,"[[",2),third = sapply(quadgram_split,"[[",3), fourth = sapply(quadgram_split,"[[",4))
quadgram <- data.frame(unigram = quadgram$first,bigram = quadgram$second, trigram = quadgram$third, quadgram = quadgram$fourth, freq = quadgram$count,stringsAsFactors=FALSE)
write.csv(quadgram[quadgram$freq > 1,],"./ngram/quadgram.csv",row.names=F)
quadgram <- read.csv("./ngram/quadgram.csv",stringsAsFactors = F)
saveRDS(quadgram,"./ngram/quadgram.RData")

# Trigram Model
trigramtoken <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))  
trigramfreq <- TermDocumentMatrix(corpus, control = list(tokenize = trigramtoken)) 
tdm_3gram_df <- ngram_sorted_df(trigramfreq) 
trigram <- data.frame(rows=rownames(tdm_3gram_df),count=tdm_3gram_df$Count) 
trigram$rows <- as.character(trigram$rows)
trigram_split <- strsplit(as.character(trigram$rows),split=" ")
trigram <- transform(trigram,first = sapply(trigram_split,"[[",1),second = sapply(trigram_split,"[[",2),third = sapply(trigram_split,"[[",3))
trigram <- data.frame(unigram = trigram$first,bigram = trigram$second, trigram = trigram$third, freq = trigram$count,stringsAsFactors=FALSE)
write.csv(trigram[trigram$freq > 1,],"./ngram/trigram.csv",row.names=F)
trigram <- read.csv("./ngram/trigram.csv",stringsAsFactors = F)
saveRDS(trigram,"./ngram/trigram.RData") 


# Bigram Model
bigramtoken <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2)) 
bigramfreq <- TermDocumentMatrix(corpus, control = list(tokenize = bigramtoken)) 
tdm_2gram_df <- ngram_sorted_df(bigramfreq) 
bigram <- data.frame(rows=rownames(tdm_2gram_df),count=tdm_2gram_df$Count)
bigram$rows <- as.character(bigram$rows)
bigram_split <- strsplit(as.character(bigram$rows),split=" ")
bigram <- transform(bigram,first = sapply(bigram_split,"[[",1),second = sapply(bigram_split,"[[",2))
bigram <- data.frame(unigram = bigram$first,bigram = bigram$second,freq = bigram$count,stringsAsFactors=FALSE)
write.csv(bigram[bigram$freq > 1,],"./ngram/bigram.csv",row.names=F)
bigram <- read.csv("./ngram/bigram.csv",stringsAsFactors = F)
saveRDS(bigram,"./ngram/bigram.RData")