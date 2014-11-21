#' Detect breakpoints in irregularly spaced time-series containing seasonal and trend components
#' 
#' @param x time-series object of class zoo
#' @param order Numeric Harmonic order of the regression model
#' @param formula See \link{breakpoints}
#' @param breaks See \link{breakpoints}
#' @param h See \link{breakpoints}
#' @param stl Character See \link{bfastpp}
#' 
#' 
#' @import strucchange
#' @import zoo
#' @import bfast
#' 
#' @export
#' 


bfastIR <- function(x, order=1, formula = response ~ trend + harmon, breaks = NULL, h = 0.15, stl = 'none') {
  ts <- bfastts(data = x, dates = index(x), type = 'irregular')
  pp <- bfastpp(ts, order = order, stl = stl)
  breaks <- breakpoints(formula = formula, data = pp, breaks = breaks, h = h)
  out <- list(zoo = x,
              breaks = breaks)
  class(out) <- 'bfastIR'
  return(out)
}