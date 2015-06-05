library(shiny)

shinyUI(fluidPage(
  titlePanel("breakpoints Application"),
  p('Interactive tool for irregular time-series segmentation'),
  em('by, ', a('Loïc Dutrieux',  href = 'http://www.loicdutrieux.com')),
  
  sidebarLayout(
    sidebarPanel(
      
      
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

      sliderInput('h', label = 'minimal segment size', min = 0, max = 1, value = 0.15, step = 0.01)
      
      # character input for stl ??
      
        
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotOutput("bfastPlot")),
        tabPanel("Summary", tableOutput("summaryTable"))
      ),
              br(),
              br(),
              p('The bfastApp allows you to interactively optimize parameters selection when looking for break points in an irregular time-series. The tool integrates well with the', a("bfastSpatial R package", href = "https://github.com/dutri001/bfastSpatial"), '. See', code('?zooExtract'), 'for creating the RDS files required by the App.'))
  
)))
