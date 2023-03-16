#' Matches a set of XRF peaks to elemental transition lines
#'
#' Function for matching a set of XRF peaks to their nearest
#' matches (on the number line) from atomic transition lines
#' across the whole periodic table (Z = 4 to Z = 103) or a
#' subset of the periodic table.
#' For example for matching an experimentally observed XRF peak
#' to the nearest-lying literature values.
#'
#' @param xrfpeakdata Dataframe containing the observed line energies and
#'   expected to have the following column names and types:
#'   $ peak      : peak number (integer)
#    $ kernel    : kernel number (integer)
#    $ unique_id : a string used for identification
#    $ x         : peak energy (numeric)
#    $ height    : peak height (numeric)
#    $ area      : peak area (numeric)
#    $ fwhm      : peak FWHM (numeric)
#    $ m         : fit parameter (numeric)
#    $ accept    : accept (boolean)
#' @param sample.elements limit matching to only these elements (vector of strings)
#'   Defaults to empty string (i.e., matching against all elements).
#' @param match.interval Matches will only be considered inside this energy window.
#'   Defaults to 0.1 keV, meaning it will match within +/- 0.05 keV.
#'
#' @return Dataframe with the following columns
#'   $ Z                     numeric, element number
#'   $ element               string, chemical element
#'   $ IUPAC.formatted       string, IUPAC label of ref transition line
#'   $ transition.keV        numeric, reference position of transition line
#'   $ energydiff            numeric, delta energy between obs and ref
#'   $ peak                  numeric, the peak number (peak fit)
#'   $ kernel                numeric, the kernel number (peak fit)
#'   $ x                     obs position of XRF peak
#'   $ within.match.interval boolean, indicating whether match is inside interval
#'   $ unique_id             string, uniquely identifiying each row
#'   $ best.match            <<<<<
#' @importFrom magrittr "%<>%"
#' @importFrom rlang .data
#' @export
#'
#' @examples \dontrun{matchxrf(xrfpeakdata, sample.elements = c("Zn", "O"))}
matchxrf <- function(xrfpeakdata, sample.elements = "", match.interval = 0.1) {
   # Load the literature values from stored file xray-data
   ref.data <-
      common::LoadRData2Variable(here::here("data/xray-line-energies.rda"))
   #
   # If sample.elements has been specified, remove all
   # non-sample elements from ref.data
   if ((length(sample.elements) > 1) || (sample.elements[1] != "")) {
      # match against the specified subset of the periodic table
      ref.data <- subset(ref.data, .data$element %in% sample.elements)
   }
   #
   # Create a subset of ref.data with only transition lines and only edges, respectively
   ref.lines <- subset(ref.data, .data$transition != "")
   ref.edges <- subset(ref.data, .data$edge != "")
   #
   # Create a subset of transition lines with only K-transitions
   K.lines <- subset(ref.lines, .data$shell.filled == "K")
   #
   # Boolean flag that is used inside conditional in for-loop below
   within.match.interval <- TRUE

   # The number of rows in xrfpeakdata is the number of peaks we will match,
   # and we match them one by one against ref.data or a subset thereof
   for (i in 1:dim(xrfpeakdata)[1]) {
      #       # Match against K-shell transitions within match-interval
      #       matching.transitions <-
      #          subset(subset(K.lines,
      #                        transition.keV >= (xrfpeakdata$x[i] -
      #                           0.5 * match.interval)),
      #                 transition.keV <= (xrfpeakdata$x[i] + 0.5 * match.interval))
      # If no K-shell transitions within match-interval exist,
      # we need to match against all shells (within match-interval)
      #       if (dim(matching.transitions)[1] == 0) {
      # No K-shell matches within interval
      # Look for matches from any shell within interval
      matching.transitions <- subset(subset(
         ref.lines,
         .data$transition.keV >= (xrfpeakdata$x[i] - 0.5 * match.interval)),
         .data$transition.keV <= (xrfpeakdata$x[i] + 0.5 * match.interval))

      # If no transitions from any shell exist within interval,
      # we resort to searching for the closest-lying match
      if (dim(matching.transitions)[1] == 0) {
         # No transitions at all found inside match-interval
         warning(paste("matchxrf(): Returning matches outside interval for peak ",
                       xrfpeakdata$unique_id[i], "\n",
                       "  Please consider increasing <match.interval> above ",
                       match.interval, sep = ""))
         within.match.interval <- FALSE
         # We resort to identifying the closest-lying transition
         closest.match.uid <-
            ref.lines$uid[which(abs(xrfpeakdata$x[i] - ref.lines$transition.keV) ==
                                   min(abs(xrfpeakdata$x[i] - ref.lines$transition.keV)))]
         # Return the three closest transitions
         matching.transitions <-
            ref.lines[(which(ref.lines$uid ==
                                closest.match.uid) - 1):(which(ref.lines$uid ==
                                                                  closest.match.uid) + 1), ]
      }
      #
      # AT THIS POINT THE MATCHING IS DONE
      #
      # This for-loop is a little special (aka weird)
      # We loop over an un-used counter...
      # We will then cbind the resulting dataframe to <matching.transitions>,
      # thus hopefully making the peaks a little easier to track
      exp.line.data <- data.frame()
      for (yadayada in 1:dim(matching.transitions)[1]) {
         exp.line.data <- rbind(
            exp.line.data,
            xrfpeakdata[i, c("peak", "kernel", "x", "unique_id")])
      }
      # Now cbind <exp.line.data> to <matching.transitions>
      lines.matching.peak <- cbind(matching.transitions, exp.line.data)
      #
      # Calculate the energy diff and add it to the df
      lines.matching.peak$energydiff <-
         lines.matching.peak$x - lines.matching.peak$transition.keV
      # Add the match.interval state to the df
      lines.matching.peak$within.match.interval <- within.match.interval
      #
      # Create a best-match column, which we will use to specify the best match
      lines.matching.peak$best.match <- ""
      # Find best K-shell match
      K.matches <- subset(lines.matching.peak, .data$shell.filled == "K")
      if (dim(K.matches)[1] > 0) {
         K.match.uid <-
            K.matches$uid[which(abs(K.matches$energydiff) ==
                                   min(abs(K.matches$energydiff)))]
         lines.matching.peak[which(lines.matching.peak$uid ==
                                      K.match.uid), "best.match"] <- "K"
      } else {
         # Find best L-shell match
         L.matches <- subset(lines.matching.peak, .data$shell.filled == "L")
         if (dim(L.matches)[1] > 0) {
            L.match.uid <-
               L.matches$uid[which(abs(L.matches$energydiff) ==
                                      min(abs(L.matches$energydiff)))]
            lines.matching.peak[which(lines.matching.peak$uid ==
                                         L.match.uid), "best.match"] <- "L"
         } else {
            # Find best M-shell match
            M.matches <- subset(lines.matching.peak, .data$shell.filled == "M")
            if (dim(M.matches)[1] > 0) {
               M.match.uid <-
                  M.matches$uid[which(abs(M.matches$energydiff) ==
                                         min(abs(M.matches$energydiff)))]
               lines.matching.peak[which(lines.matching.peak$uid ==
                                            M.match.uid), "best.match"] <- "M"
            }
         }
      }

      # Keep only pertinent columns (those that are expected downstream)
      lines.matching.peak %<>% dplyr::select(
         .data$Z, .data$element, .data$IUPAC.formatted, .data$transition.keV,
         .data$energydiff, .data$peak, .data$kernel, .data$x, .data$within.match.interval,
         .data$unique_id, .data$best.match)

      if (i == 1) {
         nearest.matches <- lines.matching.peak
      } else {
         nearest.matches <-
            rbind(nearest.matches, lines.matching.peak)
      }
   }
   return(nearest.matches)
}
