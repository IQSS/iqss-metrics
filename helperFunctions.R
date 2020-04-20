# Date helper functions ----------------
getPreviousMonth <- function () {
  now <- Sys.Date()
  as.Date(paste(format(now, "%m"), 1, format(now, "%Y"), sep='/' ), "%m/%d/%Y ")
}

getLast12Months <- function () {
  now <- Sys.Date()
  as.Date(paste(format(now, "%m"), 1, as.numeric(format(now, "%Y")) -1, sep='/' ), "%m/%d/%Y ")
}

thisYear <- function() {
  now <- Sys.Date()
  as.Date(paste(1, 1, as.numeric(format(now, "%Y")), sep='/' ), "%m/%d/%Y ")  
}

currentYear <- as.numeric(format(Sys.Date(), "%Y"))

getYear <- function(d) {
  as.numeric(format(d,"%Y"))
}


# Formatting ------------------

formatLargeNumber <- function(x) {
  paste0(formatC(as.numeric(x), format="f", digits=0, big.mark=","))
}
formatAsMoney  <- function(x, ...) {
  paste0("$", formatC(as.numeric(x), format="f", digits=0, big.mark=","))
}

formatAsPercentage <- function(x) {
  paste0(formatC(as.numeric(x), format="f", digits=0, big.mark=","), "%")
}

formatFractionAsPercentage <- function(x) {
  paste0(formatC(as.numeric(x*100), format="f", digits=0, big.mark=","), "%")
}