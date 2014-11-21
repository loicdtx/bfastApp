library(shiny)

shinyUI(fluidPage(
  titlePanel("bfastApp"),
  
  sidebarLayout(
    sidebarPanel(
      
      fileInput(inputId = 'zooTs', label = 'rds file', multiple = FALSE),
      
      selectInput('formula',
                  label = 'Formula',
                  choices = list('trend',
                                 'trend + harmon',
                                 'harmon'),
                  selected = 'trend + harmon'),
      
#       selectInput("id",
#                   label = "Time Series Number", 
#                   choices = as.list(as.character(seq(1,300))),
#                   selected = '1'),
      
      numericInput("order", label = 'Harmonic order', value = 1),

      numericInput("breaks", label = 'Number of breaks allowed', value = NULL),

      sliderInput('h', label = 'minimal segment size', min = 0, max = 1, value = 0.15, step = 0.05)
      
      # character input for stl ??
      
        
    ),
    
    mainPanel(plotOutput("bfastPlot"),
              p('Work in progress'))
  )
))
