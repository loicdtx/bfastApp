library(shiny)
library(zoo)
library(bfast)
library(strucchange)
library(ggplot2)
source('R/bfastIR.R')
source('R/ggplot.bfastIR.R')


shinyServer(function(input, output) {
    
  output$bfastPlot <- renderPlot({
      
      
      zooTs <- readRDS(input$zooTs$datapath)
      
      formula <- switch(input$formula,
                        'trend' = response ~ trend,
                        'trend + harmon' = response ~ trend + harmon,
                        'harmon' = response ~ harmon)
      
      id <- input$id
      
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
      ggplot.bfastIR(breakpts)    

      
    })
  })