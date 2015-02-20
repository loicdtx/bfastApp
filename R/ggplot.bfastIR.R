ggplot.bfastIR <- function(x, seg = TRUE, order, formula) {
  
  ggdf <- x$df
  ggdf[,'breaks'] <- NA
  ggdf$breaks[x$breaks$breakpoints] <- 1
  
  xIntercept <- ggdf$time[ggdf$breaks == 1]
  
  gg <- ggplot(ggdf, aes(time, response)) +
    geom_line() +
    geom_point(color = 'green') +
    geom_vline(xintercept = xIntercept, color = 'red', linetype = 'dashed') +
    scale_x_continuous(breaks=floor(min(ggdf$time)):ceiling(max(ggdf$time))) +
    theme(axis.text.x = element_text(angle = 60, hjust = 1))
  
  if(seg && !is.na(x$breaks$breakpoints)) {
    # Segments on time column
    segments <- c(ggdf$time[c(1,x$breaks$breakpoints, nrow(ggdf))])
    for(i in seq_along(segments[-1])) {
      predTs <- bfastts(rep(NA, ncol(ggdf)), date_decimal(ggdf$time), type = 'irregular')
      predDf <- bfastpp(predTs, order = order, na.action = na.pass)
      predDfSub <- subset(predDf, time <= segments[i + 1] & time >= segments[i])
      trainDfSub <- subset(ggdf, time <= segments[i + 1] & time >= segments[i])
      model <- lm(formula = formula, data = trainDfSub)
      predDfSub$pred <- predict(model, newdata = predDfSub)
      
      gg <- gg + geom_line(data = predDfSub, aes(x = time, y = pred), color = 'blue')
      
      
    }    
  }
  gg
}