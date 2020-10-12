#'@title Get the outliers for a given time series
#'
#'@description The outliers are relative to the trend, which is determined by stl
#'
#'@usage  tsData.out <- getTrendOutliers(tsData)
#'
#'@param tsData  A time series object.
#'
#'@return A vector of indices which represents the location the outliers within the time series
#'
#'@export

getTrendOutliers <- function(tsData)
{

    tsObj          <- tsData
	tsObj.stl      <- stats::stl(tsObj,s.window="periodic",robust=T)
	tsObj.outliers <- which(tsObj.stl$weights < 1e-8)
	
	return (tsObj.outliers)
	
}