#'@title Return the transition points of the trend for the given time series
#'
#'@description Transition points are defined as indices at which the time series changes direction
#'
#'@usage  tp <- getTrendTransitionPoints(tsData)
#'
#'@param tsData A time series object.
#'
#'@return A vector of integers corresponding to indices of transition points in the time series
#'
#'@export

getTrendTransitionPoints <- function(tsData) 
{
	tsObj.tr <- getTrend(tsData)
	tsObj.tp <- which(c(NA,NA,sign(diff(sign(diff(tsObj.tr))))) != 0)
	
	return (tsObj.tp)
}