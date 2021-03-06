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

#' Plot Trend Estimates
#'
#' Plots trend estimates with uncertainty if available.
#'
#' @inheritParams plot_estimates_pngs
#' @return A ggplot2 object.
#' @export
#' @examples
#' plot_estimates(cccharts::precipitation, x = "Season",
#'   facet = "Ecoprovince", nrow = 2)
plot_estimates <- function(
  data, x, facet = NULL, nrow = NULL, ylimits = NULL, climits = NULL, geom = "point",
  low = getOption("cccharts.low"), mid = getOption("cccharts.mid"), high = getOption("cccharts.high"),
  insig = NULL,
  ybreaks = waiver(), xbreaks = waiver(), ylab = ylab_estimates) {
  test_estimate_data(data)
  data %<>% complete_estimate_data()
  check_all_identical(data$Indicator)

  if (!is.null(facet)) {
    check_vector(facet, "", min_length = 1, max_length = 2)
    check_cols(data, facet)
  }
  if (!is.null(insig)) check_string(insig)

  if (data$Units[1] %in% c("percent", "Percent")) {
    data %<>% dplyr::mutate_(Estimate = ~Estimate / 100,
                             Lower = ~Lower / 100,
                             Upper = ~Upper / 100)
    if (is.numeric(ylimits))
      ylimits %<>% magrittr::divide_by(100)
    if (is.numeric(climits))
      climits %<>% magrittr::divide_by(100)
    if (is.numeric(ybreaks))
      ybreaks %<>% magrittr::divide_by(100)
  }

  ci <- any(!is.na(data$Lower))

  if (ci) {
    data %<>% inconsistent_significance()
    if (any(data$Inconsistent)) {
      warning(sum(data$Inconsistent), " data points have inconsistent significance and confidence limits", call. = FALSE, immediate. = TRUE)
    }
  }

  data$Significant %<>% not_significant()

  if (x == "Ecoprovince") levels(data[[x]]) <- acronym(levels(data[[x]]))
  if (x == "Station") levels(data[[x]]) <- stringr::str_replace_all(levels(data[[x]]), " ", "\n")

  outline <- "grey25"
  if (identical(low, high)) {
    mid <- NULL
    outline <- "grey25"
  }

  gp <- ggplot(data, aes_string(x = x, y = "Estimate")) +
    scale_y_continuous(ylab(data), labels = get_labels(data),
                       limits = ylimits, breaks = ybreaks)

  if (is.vector(xbreaks))
    gp <- gp + scale_x_continuous(breaks = xbreaks)

  if (geom == "point") {
    if (ci) {
      gp <- gp +  geom_errorbar(aes_string(ymax = "Upper", ymin = "Lower"),
                                width = 0.15, size = 0.5, color = outline)
    }
    gp <- gp + geom_hline(aes(yintercept = 0), linetype = 2) +
      geom_point(size = 6, shape = 21, aes_string(fill = "Estimate"), color = outline)
    if (!is.null(insig))
      gp <- gp + geom_point(data = dplyr::filter_(data, ~Significant == "NS"), size = 6, shape = 21, fill = insig, color = outline)
  } else {
    gp <- gp + geom_hline(aes(yintercept = 0)) +
      geom_col(aes_string(fill = "Estimate"), color = outline)
    if (!is.null(insig))
      gp <- gp + geom_col(data = dplyr::filter_(data, ~Significant == "NS"), fill = insig, color = outline)
    if (ci) {
      gp <- gp +  geom_errorbar(aes_string(ymax = "Upper", ymin = "Lower"),
                                width = 0.2, size = 0.5, color = outline)
    }
  }

  gp <- gp + geom_text(aes_(y = ~Estimate, label = ~Significant), hjust = 1.2, vjust = 1.8, size = 2.8)

  if (is.null(mid)) {
    gp <- gp + scale_fill_gradient(limits = climits, low = low, high = high, guide = FALSE)
  } else {
    gp <- gp + scale_fill_gradient2(limits = climits, low = low, mid = mid, high = high, guide = FALSE)
  }

  if (length(facet) == 1) {
    gp <- gp + facet_wrap(facet, nrow = nrow)
  } else if (length(facet) == 2) {
    gp <- gp + facet_grid(stringr::str_c(facet[1], " ~ ", facet[2]))
  }
  gp <- gp + theme_cccharts(facet = !is.null(facet), map = FALSE)
  gp
}

#' Estimate PNGs
#'
#' Generates plots of climate indicator data as png files.
#' @param data A data frame of the data to plot
#' @param x A string of the column to plot on the x-axis.
#' @param by A character vector of the factors to separate plots by.
#' @param facet A string indicating the factor to facet wrap by.
#' @param nrow A count of the number of rows when facet wrapping.
#' @param geom A string of the geom ("point" or "bar")
#' @param width A count of the png width in pixels.
#' @param height A count of the png height in pixels.
#' @param ask A flag indicating whether to ask before creating the directory
#' @param dir A string of the directory to store the results in.
#' @param ylimits A numeric vector of length two providing limits of the y-axis scale.
#' @param climits A character vector of length two providing limits of the color scale.
#' @param low A string specifying the color for negative values.
#' @param mid A string specifying the color for no change.
#' @param high A string specifying the color for positive values.
#' @param insig A string specifying the color for insignificant estimates.
#' @param ybreaks A numeric vector of y-axis tick mark positions.
#' @param xbreaks A numeric vector of x-axis tick mark positions.
#' @param ylab A function that takes the data and returns a string for the y-axis label.
#' @param prefix A string specifying the prefix for file names.
#' @export
plot_estimates_pngs <- function(
  data = cccharts::precipitation, x = NULL, by = "Indicator", facet = NULL, nrow = NULL,
  geom = "point", width = 350L, height = 350L,
  ask = TRUE, dir = NULL, ylimits = NULL, climits = NULL,
  low = getOption("cccharts.low"), mid = getOption("cccharts.mid"), high = getOption("cccharts.high"),
  insig = NULL,
  ybreaks = waiver(), xbreaks = waiver(), ylab = ylab_estimates, prefix = "") {

  test_estimate_data(data)
  check_flag(ask)
  check_scalar(geom, c("^point$", "^bar$", "^point$"))
  if (!is.function(ylab)) stop("ylab must be a function", call. = FALSE)
  check_vector(by, "", min_length = 1)

  if (is.null(dir)) {
    dir <- deparse(substitute(data)) %>% stringr::str_replace("^\\w+[:]{2,2}", "")
  } else
    check_string(dir)

  if (!abs_path(dir)) {
    dir <- file.path("cccharts", "estimates", dir)
  }

  data %<>% complete_estimate_data()

  if (ask && !yesno(paste0("Create directory '", dir ,"'"))) return(invisible(FALSE))

  dir.create(dir, recursive = TRUE, showWarnings = FALSE)

  if (is.null(ylimits)) ylimits <- get_ylimits(data)
  if (is.null(climits)) climits <- get_climits(data, insig)
  if (is.null(x)) x <- get_x(data)

  data %<>% plyr::dlply(by, fun_png, x = x, facet = facet, nrow = nrow, geom = geom, dir = dir,
                        width = width, height = height, ylimits = ylimits, climits = climits,
                        ybreaks = ybreaks, xbreaks = xbreaks,
                        low = low, mid = mid, high = high, insig = insig,
                        ylab = ylab,
                        fun = plot_estimates, prefix = prefix, by = by, suffix = "estimates")
  invisible(data)
}
