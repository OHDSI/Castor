#'@title Compute a simple moving average for a given time series
#'
#'@description Compute a moving average using prior or later elements
#'
#'@usage  tsData.ma <- getMA(tsData,N)
#'
#'@details If N is null and direction is "prior", then the current point and all prior points are used in the compuation.
#'         If N is null and direction is "later", then the current point and all later points are used in the computation.
#'         If N is not null, then an N point moving average is computed in the direction specified (default is "prior").
#'         In any case, a one-sided (non-centered) moving average is computed.
#'         If direction is "prior", then the current point and the prior N-1 points are included in the computation.
#'         If direction is "later", then the current point and the later N-1 points are included in the computation.
#'         If there are not enough points to compute an N-point MA, then the original values are retained.
#'
#'@param tsData  A time series object.
#'@param N       An integer indicating how many prior or later elements to include.
#'@param direction A string indicating which elements to use to compute the moving average relative to each point. Valid values are "prior" and "later".
#'
#'@return A time series of moving averages
#'
#'@export

getMA <- function(tsData, N = NULL, direction = "prior")
{
	ma <- numeric(length(tsData))
	
	if (is.null(N)) {
		if (direction == "prior")
			# Include more points in the moving average as your proceed through time
			for (k in 1:length(tsData)) 
				ma[k] <- sum(tsData[1:k])/k
		else if (direction == "later")
			# Include fewer points in the moving average as your proceed through time
			# (exclude points before the current point)
			for (k in 1:length(tsData)) 
				ma[k] <- sum(tsData[k:length(tsData)])/(length(tsData)-k+1)
		
	} else {
		if (direction == "prior")
			# Compute an N point moving average, where the first N-1 elements retain their original values
			for (k in 1:length(tsData)) 
				if (k < N)
					ma[k] <- tsData[k]
				else 
					ma[k] <- sum(tsData[(k-N+1):k])/N
		else if (direction == "later")
			for (k in 1:length(tsData)) 
				if (k > length(tsData)-N)
					ma[k] <- tsData[k]
				else 
					ma[k] <- sum(tsData[k:(k+N-1)])/N
	}
	
	maTs <- ts(data = ma, start=start(tsData), end=end(tsData), frequency=frequency(tsData))
	return (maTs)
}

