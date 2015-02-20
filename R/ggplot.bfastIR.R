ggplot.bfastIR <- function(x, seg = TRUE) {
  
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