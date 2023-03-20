## ----packages, echo=FALSE, message=FALSE------------------------------------------
library(knitr)
library(dplyr)
library(magrittr)
library(here)
library(common)
library(conflicted)
conflicted::conflict_prefer("filter", "dplyr")
conflicted::conflict_prefer("lag", "dplyr")

## ----global_options, echo=FALSE, message=FALSE------------------------------------
options(
   digits   = 7,
   width    = 84,
   continue = " ",
   prompt   = "> ",
   warn = 0,
   stringsAsFactors = FALSE)
opts_chunk$set(
   dev        = 'svg',
   fig.width  = 7.10,
   fig.height = 4.39,
   fig.align  = 'center',
   echo       = TRUE,
   eval       = TRUE,
   cache      = FALSE,
   collapse   = TRUE,
   results    = 'hide',
   message    = FALSE,
   warning    = FALSE,
   tidy       = FALSE)

## ----eval=FALSE-------------------------------------------------------------------
#  utils::download.file(
#     url = "https://ndownloader.figshare.com/files/3222110",
#     destfile = here::here("inst/extdata/xray-lines.ods"))

## ----eval=FALSE-------------------------------------------------------------------
#  xraydata <- readODS::read_ods(here::here("inst/extdata/xray-lines.ods"), sheet = 1)
#  # fix header
#  names(xraydata) <- xraydata[1,]
#  xraydata <- xraydata[-1, ]
#  row.names(xraydata) <- seq(1, dim(xraydata)[1])
#  # add label columns to xraydata
#  xraydata[, column.labels] <- ""
#  # warning: this loop is quite slow
#  for (j in 1:dim(xraydata)[1]) {
#     # loop over each row in xraydata
#     for (k in 1:length(column.labels)) {
#        # loop over each element in the added column labels
#        if (xraydata$transition[j] != "") {
#           # only for transitions, do...
#           xraydata[j, column.labels[k]] <-
#              xray.labels[
#                 which(xray.labels$IUPAC == xraydata$transition[j]),
#                 which(names(xray.labels) == column.labels[k])]
#        }
#        if (xraydata$edge[j] != "") {
#           # only for edges, do...
#           xraydata$IUPAC.formatted[j] <-
#              xray.labels$IUPAC.formatted[which(xray.labels$IUPAC == xraydata$edge[j])]
#        }
#     }
#  }
#  # Create uniqueid for each xraydata row
#  xraydata$uid <- paste(
#     xraydata$Z,
#     xraydata$element,
#     ifelse(
#        xraydata$transition != "",
#        xraydata$transition,
#        xraydata$edge),
#     sep = "-")
#  # reset some columns to numeric (currently they are all character)
#  xraydata$Z                  <- as.numeric(xraydata$Z)
#  xraydata$transition.keV     <- as.numeric(xraydata$transition.keV)
#  xraydata$intensity          <- as.numeric(xraydata$intensity)
#  xraydata$width.eV           <- as.numeric(xraydata$width.eV)
#  xraydata$edge.keV           <- as.numeric(xraydata$edge.keV)
#  xraydata$fluorescence.yield <- as.numeric(xraydata$fluorescence.yield)
#  save(xraydata, file = here::here("data/xray-line-energies.rda"))

## ----matching-screenshot, echo=FALSE, results="markup", out.width="100%"----------
knitr::include_graphics(here::here("man/figures/screenshot-matching.jpg"))

