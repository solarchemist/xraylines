## ----packages, echo=FALSE, message=FALSE--------------------------------------
library(knitr)
library(dplyr)
library(magrittr)
library(here)
library(common)
library(reticulate)
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
knitr::opts_chunk$set(
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

## ----pysetup, warning=FALSE-------------------------------------------------------
# CAREFUL, if you change pyenv name or path below, make sure to edit ./.Renviron accordingly!
# note, now that we are also sharing some r variables in python, *avoid* using dots in names
pyenv_here <- here::here()
pyenv_name <- "vignette-auger"
pyenv_path <- here::here("man/pyenv", pyenv_name)
reticulate::virtualenv_create(
   # to avoid relying on virtualenv_root(), explicitly provide a path instead of just a name
   envname = pyenv_path,
   # this is just cosmetic, hides repeated PATH warning and makes Python output more readable
   pip_options = c("--no-warn-script-location"),
   # note, "camelot-py[base]" (like the docs on pypi says) resulted in only v0.9
   # https://stackoverflow.com/a/67962556/1198249
   packages = c("opencv-python-headless", "ghostscript", "camelot-py"))
# use_python() **doesn't work** in RStudio IDE (claims RETICULATE_PYTHON overrides it,
# despite that env not being set in $HOME or anywhere else on the system), but
# works as expected when run in simple R terminal
# reticulate::use_python(paste0(pyenv_path, "/bin/python"))
# anyway, the solution appears to be to simply set RETICULATE_PYTHON env ourselves
# in .Renviron in this package's root
# py_config() was helpful to understand whether our pyenv was active
# reticulate::py_config()

