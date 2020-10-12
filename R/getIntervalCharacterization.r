#'@title Characterize a given time series' behavior over a given interval
#'
#'@description Determine whether or not a given time series is increasing, decreasing, or constant 
#'             over a given interval for a specified change threshold 
#'
#'@usage  tsData.intervalChar <- getIntervalCharacterization(tsData,startPos,endPos,changeThreshold)
#'
#'@details Most time series are non-constant even over short intervals.  Therefore, use the \code{changeThreshold}
#'         parameter to specify the percent change that can be tolerated before considering a change meaningful.
#'         Essentially, specify the percent change you're willing to ignore when characterizing a time series over an interval.
#'         If the percent change for each difference is less than or equal to \code{changeThreshold} over the specified interval,
#'         the time series is considered constant over that interval.  Otherwise, the time series is considered either "increasing", 
#'         "decreasing", or "eventually constant". This will be determined by the magnitude of the percent change between the first
#'         and last elements in the interval. 
#'
#'@param tsData       A time series object.
#'@param startPos      The index of the first time series element to evaluate.
#'@param endPos        The index of the last time series element to evaluate.
#'@param changeThreshold A value between 0 and 1 (inclusive) serving as an upper bound for the percent change 
#'                       you're willing to tolerate from one element to the next.
#'
#'@return A string characterizing the time series over the given interval for the specified change threshold.
#'        The return values are: "INCREASNG","DECREASING", "CONSTANT", "EVENTUALLY CONSTANT"
#'
#'@export

getIntervalCharacterization <- function(tsData, startPos, endPos, changeThreshold)
{

	nhoodDf <- getNeighborhoodDf(tsData[startPos:endPos])
	
	firstValue <- nhoodDf$CURRENT_VALUE[1]
	lastValue  <- nhoodDf$CURRENT_VALUE[nrow(nhoodDf)]

	retVal <- NULL
	
	if (all(nhoodDf$PCT_CHANGE[-1] <= changeThreshold)) 
		retVal <- "CONSTANT"
	else if (abs(firstValue-lastValue)/firstValue <= changeThreshold) 
		retVal <- "EVENTUALLY CONSTANT"
	else if (sign(lastValue-firstValue) == 1) 
		retVal <- "INCREASING"
	else	
		retVal <- "DECREASING"
	
	return (retVal)
}