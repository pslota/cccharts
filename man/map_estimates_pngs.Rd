% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/map-estimates.R
\name{map_estimates_pngs}
\alias{map_estimates_pngs}
\title{Maps PNGs}
\usage{
map_estimates_pngs(data = cccharts::precipitation, by = "Indicator",
  station = FALSE, nrow = NULL, map = cccharts::bc, width = 500L,
  height = 450L, ask = TRUE, dir = NULL, climits = NULL,
  clab = ylab_trend, labels = TRUE, low = getOption("cccharts.low"),
  mid = getOption("cccharts.mid"), high = getOption("cccharts.high"),
  insig = "white", bounds = c(0, 1, 0, 1),
  ecoprovinces = c("Coast and Mountains", "Georgia Depression",
  "Central Interior", "Southern Interior", "Southern Interior Mountains",
  "Sub-Boreal Interior", "Boreal Plains", "Taiga Plains",
  "Northern Boreal Mountains", "British Columbia"), prefix = "")
}
\arguments{
\item{data}{A data frame of the data to plot}

\item{by}{A character vector of the factors to separate plots by.}

\item{station}{A flag indicating whether the plot is for stations or ecoprovinces.}

\item{nrow}{A count of the number of rows when facet wrapping.}

\item{map}{A SpatialPolygonsDataFrame object.}

\item{width}{A count of the png width in pixels.}

\item{height}{A count of the png height in pixels.}

\item{ask}{A flag indicating whether to ask before creating the directory}

\item{dir}{A string of the directory to store the results in.}

\item{climits}{A character vector of length two providing limits of the color scale.}

\item{clab}{A function that takes the data and returns a string for the color legend label.}

\item{labels}{A flag indicating wether to plot labels.}

\item{low}{A string specifying the color for negative values.}

\item{mid}{A string specifying the color for no change.}

\item{high}{A string specifying the color for positive values.}

\item{insig}{A string specifying the color for insignificant estimates.}

\item{bounds}{A numeric vector of four values between 0 and 1 specifying the start and end of the x-axis bounding box and the start and end of the y-axis bounding box.}

\item{ecoprovinces}{A character vector specifying the ecoprovince areas to include in the map.}

\item{prefix}{A string specifying the prefix for file names.}
}
\description{
Generates maps of climate indicator data as png files.
}
