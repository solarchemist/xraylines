#' @name xraydata
#' @title X-ray line and edge energies, widths, and fluorescence yields
#' @description A dataframe with transition lines, edges, fluorescence yields,
#'   widths and labels in both IUPAC and Siegbahn notation for the chemical elements
#'   (4 <= Z <= 103).
#' @docType data
#' @format A data frame with 3006 rows and 18 variables:
#' \describe{
#'   \item{Z}{Element number, numeric}
#'   \item{element}{Element symbol, string}
#'   \item{transition}{Transition label in IUPAC notation, simple string}
#'   \item{transition.keV}{Transition line energy in keV, numeric}
#'   \item{intensity}{Transition intensity, if available, numeric}
#'   \item{width.eV}{Transition line width in eV, numeric}
#'   \item{edge}{Edge label (shell), string}
#'   \item{edge.keV}{Edge energy in keV, numeric}
#'   \item{fluorescence.yield}{Fluorescence yield for transition edges, numeric}
#'   \item{shell.filled}{Label of the filled transition shell, string}
#'   \item{subshell.filled}{Label of the filled transition subshell, string}
#'   \item{shell.source}{Label of the source transition shell, string}
#'   \item{subshell.source}{Label fo the source transition subshell, string}
#'   \item{Siegbahn}{Transition label in Siegbahn notation}
#'   \item{Siegbahn.short}{Transition label in a shortened Siegbahn notation}
#'   \item{IUPAC.formatted}{Transition label in IUPAC notation, formatted as LaTeX string}
#'   \item{Siegbahn.formatted}{Transition label in Siegbahn notation, formatted as LaTeX string}
#'   \item{uid}{unique string identifying each row, formatted like Z-element-transition}
#' }
#' @source \url{https://doi.org/10.6084/m9.figshare.1168939.v1}
#' @author Taha Ahmed
NULL


#' @name xraylabels
#' @title IUPAC and Siegbahn notation of electronic transitions
#' @description A dataframe with IUPAC transition names and their corresponding
#'   labels in the old Siegbahn notation. Also with LaTeX-formatted strings.
#' @docType data
#' @format A data frame with 70 rows and 9 variables (all character class):
#' \describe{
#'   \item{IUPAC}{Transition label in the recommended IUPAC notation}
#'   \item{shell.filled}{Electronic shell where the transitioning electron starts}
#'   \item{subshell.filled}{Electronic subshell of the same}
#'   \item{shell.source}{Electronic shell where the transitioning electron ends up}
#'   \item{subshell.source}{Electronic subshell of the same}
#'   \item{Siegbahn}{Transition label in Siegbahn notation}
#'   \item{Siegbahn.short}{Short form Siegbahn notation}
#'   \item{IUPAC.formatted}{LaTeX-formatted label in IUPAC notation}
#'   \item{Siegbahn.formatted}{LaTeX-formatted label in Siegbahn notation}
#' }
#' @source \url{https://doi.org/10.6084/m9.figshare.1168939.v1}
#' @author Taha Ahmed
NULL
