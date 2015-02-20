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
  
  ## Do the calculations outside of output object in a reactive expression
  breakpts <- reactive({
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
    out <- bfastIR(x = x, order = order, formula = formula, breaks = breaks, h = h)
    return(out)
  })
  
  
  # First output (plot)  
  output$bfastPlot <- renderPlot({    
      # plot results
    formula <- switch(input$formula,
                      'trend' = response ~ trend,
                      'trend + harmon' = response ~ trend + harmon,
                      'harmon' = response ~ harmon)
    
    order <- input$order
    ggplot(breakpts(), formula = formula, order = order)      
  })
  
  # Second output (table)
  output$summaryTable <- renderTable({
    breakpts <- breakpts()
    if (is.na(breakpts$breaks$breakpoints))
      return(NULL)
    df <- breakpts$df
    b <- breakpts$breaks$breakpoints
    segments <- c(df$time[c(1,b, nrow(df))])
    dfOut <- data.frame("Segment.Number" = numeric(), "Count.obs" = numeric(), "Length" = numeric())
    for (i in 1:(length(segments) - 1)) {
      subDf <- subset(df, time <= segments[i + 1] & time >= segments[i])
      dfOut[i,] <- c(i, nrow(subDf), diff(range(subDf$time)))
    }
    return(dfOut)  
  })
  
  
})