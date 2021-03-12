#'@title  For a monhtly time series, compute sum and proportion by month across all years
#'
#'@usage  tsSum <- sumAcrossYears(tsData)
#'
#'@param tsData A time series object
#'
#'@return A data frame reporting the monthly sum across all years and the proportion this sum contributes to the total.
#'
#'@import dplyr
#'@export

sumAcrossYears  <- function(tsData)
{
    # Read the time series into a data frame with character string months    
	tsAsDf <- data.frame(MONTH_NUM=cycle(tsData), TS_VALUE=tsData, stringsAsFactors = F)
	# Summarize by month across all years
	tsAggregatedByMonth <- tsAsDf %>% dplyr::group_by(MONTH_NUM) %>% dplyr::summarize(SUM=sum(TS_VALUE))
	# Compute proportion for each month 
	tsPropByMonth <- data.frame(MONTH_NUM=tsAggregatedByMonth$MONTH_NUM, PROP=tsAggregatedByMonth$SUM/sum(tsData), stringsAsFactors = F)
	# Get sum and proportion in a single data frame
	tsSummary <- merge(tsAggregatedByMonth, tsPropByMonth, by.x = "MONTH_NUM", by.y="MONTH_NUM") 

	return (tsSummary[order(tsSummary$PROP, decreasing = T),])
}