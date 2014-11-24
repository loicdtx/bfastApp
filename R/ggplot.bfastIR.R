ggplot.bfastIR <- function(x, seg = TRUE) {
  
  ggdf <- x$df
  ggdf[,'breaks'] <- NA
  ggdf$breaks[x$breaks$breakpoints] <- 1
  
  xIntercept <- ggdf$time[ggdf$breaks == 1]
  
  gg <- ggplot(ggdf, aes(time, response)) +
    geom_line() +
    geom_vline(xintercept = xIntercept, color = 'red', linetype = 'dashed')
  
  if(seg) {
    # Segments on time column
    segments <- c(ggdf$time[c(1,x$breaks$breakpoints, nrow(ggdf))])
    for(i in seq_along(segments[-1])) {
      dfsub <- subset(ggdf, time <= segments[i + 1] & time >= segments[i])
      gg <- gg + stat_smooth(method = "lm", data = dfsub, se = FALSE)
    }    
  }
  gg
}