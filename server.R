library(shiny)
library(zoo)
library(bfast)
library(strucchange)
library(ggplot2)
library(lubridate)
source('R/bfastIR.R')
source('R/ggplot.bfastIR.R')


shinyServer(function(input, output) {
  
  output$ui <- renderUI({
    zooTs <- input$zooTs
    if (is.null(zooTs))
      return(NULL)
    
    zooTs <- readRDS(zooTs$datapath)
        
    n <- ncol(zooTs)        
    selectInput("id",
                label = "Time Series Number", 
                choices = as.list(as.character(seq(1,n))),
                selected = '1')

  })
    
  output$bfastPlot <- renderPlot({
      
      zooTs <- input$zooTs
      if (is.null(zooTs))
        return(NULL)
      
      zooTs <- readRDS(zooTs$datapath)
      
      
      id <- as.numeric(input$id)
      
      formula <- switch(input$formula,
                        'trend' = response ~ trend,
                        'trend + harmon' = response ~ trend + harmon,
                        'harmon' = response ~ harmon)
      
      order <- input$order
      
      breaks <- input$breaks
      if(breaks == -1) {
        breaks <- NULL
      }
      
      h <- input$h
      
      # Subset time-series
      x <- zooTs[,id]
      
      # Run bfastIR function
      breakpts <- bfastIR(x = x, order = order, formula = formula, breaks = breaks, h = h)
      
      # plot results
      ggplot(breakpts, formula = formula, order = order)    

      
    })
  })