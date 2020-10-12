#'@title Compute and return the degree measure of the angle of the slope of the time series.
#'
#'@description The time series is fitted with a linear model and the degree measure of the angle of the slope is returned.
#'
#'@usage  angleMagnitude <- getSlopeAngleSize(tsData)
#'
#'@param tsData A time series object.
#'
#'@return A numeric value representing the degree measure of the angle of the slope of the time series.
#'
#'@export

getSlopeAngleSize <- function(tsData)
{

    tsObj    <- tsData
	tsObj.lm <- lm(tsObj ~ time(tsObj))

	degreeAngleMeasure <- as.numeric(atan(tsObj.lm$coefficients[2])*(180/pi))
	
	return (degreeAngleMeasure)

}
