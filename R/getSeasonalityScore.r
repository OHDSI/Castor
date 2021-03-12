#'@title Get the seasonality score for a given monthly time series
#'
#'@description The seasonality score of a monthly time series is computed as its departure from a uniform distribution.
#'
#'@usage  tsData.ss <- getSeasonalityScore(tsData)
#'
#'@details
#' The degree of seasonality of a monthly time series is based on its departure from a uniform distribution.
#' If the number of cases for a given concept is uniformly distributed across all time periods (in this case, all months), 
#' then its monthly prevalence (as well as proportion) would be constant.  In this case, the time series would be
#' considered "absolutely non-seasonal" and its "seasonality score" would be zero.
#' Similarly, if all the cases occur at a single point in time (that is, in a single month), such a time series would be considered
#' "absolutely seasonal" and its seasonality score would be 1.  All other time series would have
#' a seasonality score between 0 and 1.  Currently, only monthly time series are supported.
#' NB: To be able to compute a seasonality score, a time series must have a minimum of three complete years of data. 
#'    
#'@param tsData  A time series object.
#'
#'@return A numeric value between 0 and 1 (inclusive) representing the seasonality of a time series.
#'
#'@import dplyr
#'@export

getSeasonalityScore <- function(tsData)
{
	tsObj <- tsData
	maxDist   <- 1.83
	unifDist  <- 1/12
	minMonths <- 36

	if (frequency(tsObj) != 12)
		stop("ERROR: Only monthly time series are supported")
		
	tsObj <- Castor::tsCompleteYears(tsObj)

	if (length(tsObj) < minMonths)
		stop("ERROR: Time series must have a minimum of three complete years of data")
	
	tsObj.yrProp <- Castor::sumAcrossYears(tsObj)$PROP

	tsObj.ss <- round(sum(abs(tsObj.yrProp-unifDist))/maxDist,2)

	return (tsObj.ss)
}