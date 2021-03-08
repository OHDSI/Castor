#'@title Get the outliers for a given time series
#'
#'@description The outliers are computed using different methods based on the \code{outlierType} parameter
#'
#'@usage  tsData.out <- getOutliers(tsData)
#'
#'@param tsData  A time series object.
#'@param outlierType  A string that determines the way to compute the outliers.  outlierType = c("iqr","stl").  Default is "iqr".
#'@details 
#'	iqr: Find outliers using the interquartile range of the given time series (boxplot method).
#'  stl: Use stl weights.
#'
#'@return A vector of indices which represents the location of the outliers within the time series
#'
#'@export

getOutliers <- function(tsData, outlierType = "iqr")
{

	tsObj <- tsData
	
	if (outlierType == "iqr") {
		tsObj.outliers <-  which(tsObj > quantile(tsObj,probs=.75) + 3*IQR(tsObj))
	} else if (outlierType == "stl") {
		tsObj          <- tsData
		tsObj.stl      <- stats::stl(tsObj,s.window="periodic",robust=T)
		tsObj.outliers <- which(tsObj.stl$weights < 1e-8)
	} else {
		stop("Invalid outlier type specified. Valid values are \"iqr\" and \"stl\"")
	}
	
	return (tsObj.outliers)
}