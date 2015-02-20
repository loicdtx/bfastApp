library(bfast)
library(strucchange)
library(zoo)

source('R//bfastIR.R')

load('data/landsat.rda') # LandsatZoo
x <- LandsatZoo[,2]
class(x)

test1 <- bfastIR(x = x)
class(test1)

test1
plot(x)


# Good looking plot
library(ggplot2)
source('R/ggplot.bfastIR.R')

ggplot(test1)


### Improve plot
library(zoo)
library(ggplot2)

source('R//bfastIR.R')

ts0 <- readRDS('data/maf_NDMI.rds')
ts <- ts0[,1]
tsBreak <- bfastIR(ts)

ggplot(data = tsBreak$df, aes(x=time, y = response)) +
  geom_line() +
  geom_point(color = 'green') +
  scale_x_continuous(breaks=floor(min(tsBreak$df$time)):ceiling(max(tsBreak$df$time))) +
  theme(axis.text.x = element_text(angle = 60, hjust = 1))


tts <- bfastts(data = ts, dates = index(ts), type = 'irregular')
pp <- bfastpp(tts, order = 2, stl = 'none', na.action = na.pass)
pp


segments <- c(tsBreak$df$time[c(1,tsBreak$breaks$breakpoints, nrow(tsBreak$df))])
segments

breakpts <- tsBreak

df <- breakpts$df
b <- breakpts$breaks$breakpoints
segments <- c(df$time[c(1,b, nrow(df))])
dfOut <- data.frame("Segment.Number" = numeric(), "Count.obs" = numeric(), "Length" = numeric())
for (i in 1:(length(segments) - 1)) {
  subDf <- subset(df, time <= segments[i + 1] & time >= segments[i])
  dfOut[i,] <- c(i, nrow(subDf), diff(range(subDf$time)))
}
dfOut  

