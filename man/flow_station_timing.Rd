% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{flow_station_timing}
\alias{flow_station_timing}
\title{Flow Station Timing Trend Data}
\format{A tbl data frame:
\describe{
\item{Indicator}{The indicator name (chr)}
\item{Statistic}{The statistic with levels 'Mean', 'Minimum' or 'Maximum' (fctr)}
\item{Units}{The units (chr)}
\item{Period}{The period of the estimated change in years (int)}
\item{Term}{The term of the analysis with levels 'Medium' or 'Long' (fctr)}
\item{StartYear}{The first year (int)}
\item{EndYear}{The last year (int)}
\item{Ecoprovince}{The Ecoprovince (fctr)}
\item{Season}{The season with levels 'Annual', 'Spring', 'Summer', 'Fall' or 'Winter' (fctr)}
\item{Station}{The station name if a station (fctr)}
\item{Latitude}{The longitude if a station (dbl)}
\item{Longitude}{The latitude if a station (dbl)}
\item{Estimate}{The estimated trend (dbl)}
\item{Lower}{The estimated lower 95\% confidence interval in the trend (dbl)}
\item{Upper}{The estimated lower 95\% confidence interval in the trend (dbl)}
\item{Significant}{Whether the estimate is statistically significant at the 5\% level (lgl)}
}}
\usage{
flow_station_timing
}
\description{
Flow station timing trend data imported and reformatted from
\url{https://catalogue.data.gov.bc.ca/dataset/d6f30634-a6a8-45b5-808e-210036f25044}.
}
\details{
Data licensed under the Open Data License-BC.
See metadata record in BC Data Catalogue for more details on the original data set.
}
\keyword{datasets}
