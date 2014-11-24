library(shiny)

shinyUI(fluidPage(
  titlePanel("bfast Application"),
  p('Interactive tool for irregular time-series segmentation'),
  em('Loïc Dutrieux'),
  
  sidebarLayout(
    sidebarPanel(
      
      fileInput(inputId = 'zooTs', label = 'rds file', multiple = FALSE, accept = '.rds'),
      
      uiOutput("ui"),
      
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

      numericInput("breaks", label = 'Number of breaks allowed', value = -1),

      sliderInput('h', label = 'minimal segment size', min = 0, max = 1, value = 0.15, step = 0.05)
      
      # character input for stl ??
      
        
    ),
    
    mainPanel(plotOutput("bfastPlot"),
              br(),
              br(),
              p('The bfastApp allows you to interactively optimize parameters selection when looking for break points in an irregular time-series. The tool integrates well with the', a("bfastSpatial R package", href = "https://github.com/dutri001/bfastSpatial"), '. See', code('?zooExtract'), 'for creating the RDS files required by the App.'))
  
)))
