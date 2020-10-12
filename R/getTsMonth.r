#'@title Return the two digit month for a each element of a given time series
#'
#'@description The function \code{time} in the \cr\code{stats} package returns the date in fractions. 
#'             This function converts that value to the proper integer. 
#'
#'@details Since yearly (4 digit only) time series have no month and since weeks can span months,
#'         this function is only supported for daily and monthly time series.
#'
#'@usage  tsMonth <- getMonth(tsData)
#'
#'@param tsData  A time series object.
#'
#'@return A vector of integers (representing months).
#'
#'@export


getTsMonth <- function(tsData)
{
	freqNum <- frequency(tsData)
	
	if (freqNum == 365) {
		month <- as.integer(strftime(as.Date(paste0(floor(time(tsData)),cycle(tsData)),"%Y%j"),"%m"))
	} else if (freqNum ==  12) {
		month <- as.integer(cycle(tsData)) 
	} else {
		stop("Invalid frequency: This functions is applicable to only daily and monthly time series.")
	}
		
	return (month)
	
}

