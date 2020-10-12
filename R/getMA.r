#'@title Compute a simple moving average for a given time series
#'
#'@description Compute a moving average using one or more prior elements
#'
#'@usage  tsData.ma <- getMA(tsData,N)
#'
#'@details If N is null, then 1,2,...,length(tsData) points will be used in the computation of the moving average.
#'         If N is not null, then an N point moving average is computed.
#'         In either case, a one-sided (non-centered) moving average is computed.
#'         The first N-1 elements of the moving average retain the value of the first N-1 elements of the time series.
#'
#'@param tsData  A time series object.
#'@param N       An integer indicating how many prior elements to include.
#'
#'@return A time series of moving averages
#'
#'@export

getMA <- function(tsData,N = NULL)
{
	ma <- numeric(length(tsData))
	
	if (is.null(N)) {
		# Include more points in the moving average as your proceed through time
		for (k in 1:length(tsData)) 
			ma[k] <- sum(tsData[1:k])/k
	} else {
		# Compute an N point moving average, where the first N-1 elements retain their original values
		for (k in 1:length(tsData)) 
			if (k < N)
				ma[k] <- tsData[k]
			else 
				ma[k] <- sum(tsData[(k-N+1):k])/N
	}
	
	maTs <- ts(data = ma, start=start(tsData), end=end(tsData), frequency=frequency(tsData))
	return (maTs)
}

