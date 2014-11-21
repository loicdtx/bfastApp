ggplot.bfastIR <- function(x) {
  
  ggdf <- x$df
  ggdf[,'breaks'] <- NA
  ggdf$breaks[x$breaks$breakpoints] <- 1
  
  xIntercept <- ggdf$time[ggdf$breaks == 1]
  
  ggplot(ggdf, aes(time, response)) +
    geom_line() +
    geom_vline(xintercept = xIntercept, color = 'red', linetype = 'dashed')
}