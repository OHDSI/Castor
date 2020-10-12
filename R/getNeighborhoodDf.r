#'@title Create and return the neighborhood data frame for a given time series 
#'
#'@description A neighborhood of a point p, consists of all the points within a certain distance from p.
#'             For the given time series, the neighborhood data frame consists of each element of
#'             the time series, the previous and next elements, the magnitude of the first difference, 
#'             the percent change of the first difference, and the sign of the change.  The column, IS_TP,
#'             is a boolean that indicates whether or not a given element is a transition point.
#'
#'@usage  tsData.nhoodDf <- getNeighborhoodDf(tsData)
#'
#'@param tsData  A time series object.
#'
#'@return A data frame characterizing each time series element and the first difference
#'
#'@export

getNeighborhoodDf <- function(tsData)
{

	neighborhoodDf <- data.frame(
		PREV_VALUE=c(NA,tsData[-length(tsData)]),
		CURRENT_VALUE=c(tsData),
		NEXT_VALUE=c(tsData[-1],NA),
		DIFF_VALUE=c(NA,diff(tsData)),
		DIFF_SIGN=c(NA,sign(diff(tsData))),
		PCT_CHANGE=c(NA,round(abs(diff(tsData)/tsData[-length(tsData)]),4)),
		IS_TP=c(NA,NA,sign(diff(sign(diff(tsData))))) != 0)

	return (neighborhoodDf)
	
}