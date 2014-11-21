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
