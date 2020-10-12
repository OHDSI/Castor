#'@title Get the trend of a given time series
#'
#'@description This function uses stl to determine a time series' trend
#'
#'@usage  tsData.tr <- getTrend(tsData)
#'
#'@param tsData  A time series object.
#'
#'@return A time series that represents the trend of the given time series.
#'
#'@export

getTrend <- function(tsData)
{

    tsObj       <- tsData
	tsObj.stl   <- stats::stl(tsObj,s.window="periodic",robust=T)
	tsObj.trend <- tsObj.stl$time.series[,"trend"]

	return (tsObj.trend)
	
}