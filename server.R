library(shiny)
library(UsingR)
library(tm)
library(stringi)
library(RWeka)
library(qdap)
library(data.table)
library(RJSONIO)

options(shiny.maxRequestSize=45*1024^2)

Bigram <- readRDS("Bigram.rds")
Trigram <- readRDS("Trigram.rds")
Quagram <- readRDS("Quagram.rds")
Quingram <- readRDS("Quingram.rds")
profanityList <- readRDS("ProfanityList.rds")  

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$inputText <- renderText({
    # paste(input$inputText)
    input$inputText
  })
  
  output$predictedText <- renderText({

    text <- input$inputText
    
    bad <- rbind(data.frame(V1 = profanityList), data.frame(V1 = cbind(stopwords("english"))), "the", "of", "a")
    
    mydata.corpus <- Corpus(VectorSource(text))
    mydata.corpus <- tm_map(mydata.corpus,content_transformer(function(x) iconv(x, to='ASCII', sub=' ')))
    mydata.corpus <- tm_map(mydata.corpus,content_transformer(tolower))
    mydata.corpus <- tm_map(mydata.corpus, content_transformer(removeNumbers))
    mydata.corpus <- tm_map(mydata.corpus, content_transformer(removePunctuation))
    mydata.corpus <- tm_map(mydata.corpus, removeWords, bad) 
    mydata.corpus <- tm_map(mydata.corpus, content_transformer(stripWhitespace))
    mydata.corpus <- tm_map(mydata.corpus, PlainTextDocument)
    mydata.corpus <- tm_map(mydata.corpus, content_transformer(function(x) stri_trans_tolower(x)))
    mydata.corpus <- tm_map(mydata.corpus, content_transformer(function(x) stri_trans_general(x, "en_US")))
    
    frase <- unlist(mydata.corpus[[1]]$content)
    
    prev <- unlist (strsplit (frase, split = " ", fixed = TRUE))
    len <- length(prev)
    fra2 <- paste(tail (prev, 1), collapse = " ")
    fra3 <- paste(tail (prev, 2), collapse = " ")
    fra4 <- paste(tail (prev, 3), collapse = " ")
    fra5 <- paste(tail (prev, 4), collapse = " ")
    
    predict <- NULL
    try(pred5 <- Quingram [context == fra5, .SD [which.max (p), word]])
    try(pred4 <- Quagram [context == fra4, .SD [which.max (p), word]])
    try(pred3 <- Trigram [context == fra3, .SD [which.max (p), word]])
    try(pred2 <- Bigram [context == fra2, .SD [which.max (p), word]])
    if(length(head(pred5))==0){  
      if(length(head(pred4))==0){  
        if(length(head(pred3))==0){    
          if(length(head(pred2))!=0){predict<-pred2
          }else{
            predict<-"Next word cannot be predicted."
          }
        }else{predict<-pred3}
      }else{predict<-pred4}
    }else{predict<-pred5}

    paste(predict)
  })

})