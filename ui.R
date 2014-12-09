library(shiny)

# Define UI for application that draws a histogram
shinyUI(
  fluidPage(
    
    # Application title
    titlePanel("Next Word Predictor!"),
    
    # Sidebar with a slider input for the number of bins
    sidebarLayout(
      sidebarPanel(
        h3("Enter any text."),
        textInput("inputText", label = h4("Text:"))
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        h3("What does the Tool do?"),
        p("This tool predicts the next word for any given text as input."),
        p("Keep typing any text in the input area on the left. The tool will predict"),
        p("the next word as you type."),
        br(),
        br(),        
        h3("Entered Text:"),
        textOutput("inputText"),
        br(),
        br(),
        h3("Predicted Word:"),
        textOutput("predictedText")
      )
    )
  )
)