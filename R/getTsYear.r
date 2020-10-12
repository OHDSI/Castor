#'@title Return the four digit year for each element of a given time series
#'
#'@description The function \code{time} in the \cr\code{stats} package returns the date in fractions. 
#'             This function converts that value to the proper four digit integer. 
#'
#'@usage  year <- getYear(tsData)
#'
#'@param tsData  A Time Series Object.
#'
#'@return A vector of 4 digit integers (representing years).
#'
#'@export

getTsYear <- function(tsData)
{
 	return (floor(time(tsData)))	
}