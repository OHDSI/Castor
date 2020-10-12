#'@title  Return a monthly or daily univariate time series object as a data frame
#'
#'@usage  tsDf <- tsToDf(tsData)
#' 
#'@param tsData  A time series object
#'
#'@return A data frame with three or four columns representing year, month number, day of the month number, and the time series value.
#'
#'@export

tsToDf  <- function(tsData)
{

	if (frequency(tsData) != 12 & frequency(tsData) != 365) {
		stop("This function is only supported for monthly and daily time series.")
	}

	if (frequency(tsData) == 12) 
		tsAsDf <- data.frame(YEAR=floor(time(tsData)), MONTH_NUM=getTsMonth(tsData), TS_VALUE=tsData, stringsAsFactors = F)
	else if (frequency(tsData) == 365) {
	    dayOfMonth <- as.integer(strftime(as.Date(paste0(floor(time(tsData)),cycle(tsData)),"%Y%j"),"%d"))
		tsAsDf <- data.frame(YEAR=floor(time(tsData)), MONTH_NUM=getTsMonth(tsData), DAY_NUM=dayOfMonth, TS_VALUE=tsData, stringsAsFactors = F)
	}
	return (tsAsDf)
}