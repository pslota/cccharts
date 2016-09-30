# Copyright 2016 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

source("data-raw/header.R")

## Load CSV data file from BC Data Catalogue. Data licensed under the Open Data License-BC
## See metadata record in BC Data Catalogue for details on the data set.
degree_days <- read_csv("https://catalogue.data.gov.bc.ca/dataset/8f0d304e-161d-42e6-a982-cad13e60bd8f/resource/31d62c2b-ab92-49b5-89af-16ebda42aa98/download/growheatcooldegreedaychange1900-2013.csv")

degree_days$Station <- factor(NA)

degree_days$Indicator <- degree_days$Measure %>% str_replace_all("_", " ")

degree_days$Statistic <- "Mean"
degree_days$Statistic %<>% factor(levels = statistic)

degree_days$Units <- "Degree Days"
degree_days$Years <- 100L

degree_days$Ecoprovince %<>% tolower() %>% toTitleCase()
degree_days$Ecoprovince %<>%  factor(levels = ecoprovince)
degree_days$Season %<>% factor(levels = season)

degree_days %<>% mutate(Significant = Stat_Significance == 1)

degree_days$Latitude <- NA_real_
degree_days$Longitude <- NA_real_

degree_days %<>% select(
  Indicator, Statistic, Units, Years, Ecoprovince, Season, Station, Latitude, Longitude,
  Trend = Trend_DDcentury, Uncertainty = Uncertainty_DDcentury,
  Significant)

degree_days$Trend %<>% as.numeric()
degree_days$Uncertainty %<>% as.numeric()

degree_days %<>% arrange(Indicator, Statistic, Ecoprovince, Station, Season)

use_data(degree_days, overwrite = TRUE)

