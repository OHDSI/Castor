#'@title Return the change points of the trend for the given time series
#'
#'@description Change points are transition points that optionally exceed a certain magnitude and/or
#'             continue in a certain direction for a specified length of time.
#'             
#'
#'@details Transition points are defined as indices at which the time series changes direction.
#'         We can think of the trend of a univariate time series as analogous to a smooth function
#'         \eqn{f(t)} defined over a given interval of real numbers, \eqn{[a,b]}.  We know that  
#'         for \eqn{t in [a,b]}, \eqn{f} is increasing on \eqn{[a,b]} if \eqn{f'(t) > 0},
#'         \eqn{f} is decreasing on \eqn{[a,b]} if \eqn{f'(t) < 0} and
#'         \eqn{f} is constant on \eqn{[a,b]} if \eqn{f'(t) = 0}. 
#'         Similarly, we can examine the sign of the difference of a time series at two subsequent 
#'         points in time, to determine if the time series is increasing, decreasing, or constant from one 
#'         point in time to the next. 
#'         Additionally, if we think of the time series as moving through space, a geometric interpretation
#'         would allow us to treat the time series as a vector with a direction (increasing, decreasing, or constant) 
#'         and magnitude (the percent change of the time series from one period of time to the next).  This perspective
#'         allows one to adapt what is considered a change point.  Thus, a change point can merely be a transition point,
#'         or it can be a transition point whose percent change from the previous value exceeds some threshold,
#'         or it can be a transition point that causes the time series to continue in the new direction for a 
#'         specified period of time.
#'         
#'
#'@usage  tsData.cp <- getTrendChangePoints(tsData, minPctChange, nPeriods)
#'
#'@param tsData A time series object.
#'@param minPctChange The optional lower bound a magnitude must exceed
#'@param nPeriods An optional number of periods the transition must continue into the future
#'
#'@return A vector of integers corresponding to indices of change points in the given time series trend
#'
#'@export

getTrendChangePoints <- function(tsData, minPctChange = NULL, nPeriods = NULL)
{
	# Search neighborhood for points that:
	# i) Transition
	# ii) Optionally greater than some threshold minPctChange
	# iii) Optionally continue in the new direction for nPeriods

	nHood <- getNeighborhoodDf(getTrend(tsData))

	# If neither magnitude of change nor the length of the new direction 
    # are specified, the change points are merely the transition points

	nHood.cp <- which(nHood$IS_TP)
	
	# If a magnitude is specified, transition points must exceed a minimum percent change
	# to be considered a change point
	
	if (!is.null(minPctChange))
		nHood.cp <- which(nHood$IS_TP & nHood$PCT_CHANGE > minPctChange)
	
	# If nPeriods is given, each transition point must continue in the new
	# direction for nPeriods
	
	if (!is.null(nPeriods)) {
		cp <- integer()
		for (k in nHood.cp) 
			if (length(unique(nHood$DIFF_SIGN[k:(k+nPeriods)])) == 1)
				cp[length(cp)+1] <- k
		nHood.cp <- cp
	}
	
	return (nHood.cp)
}