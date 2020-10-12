#'@title Return a monthly multivariate time series of Achilles data from a data frame or concept_ids
#'
#'@description Build a multivariate time series object from one or more concept_ids or a dataframe in the proper format.
#'             If supplying a data frame from which to create the time series, it must have the following columns: 
#'             START_DATE, COUNT_VALUE, PREVALENCE, and PROPORTION_WITHIN_YEAR.
#'            
#'@usage # Method 1: Create the time series in two steps then access the individual time series.
#'       # First, get results from Achilles for one or more concept_ids, then transform the results into a time series object.
#'         AchillesData <- getAchillesMonthlyData (connectionDetails, cdmSchema, resultsSchema, conceptId) 
#'         achillesTs   <- getAchillesTs(resultSet = AchillesData)
#'         prevTs       <- achillesTs[,"PREVALENCE"]
#'         countTs      <- achillesTs[,"COUNT_VALUE"]
#'         pwyTs        <- achillesTs[,"PROPORTION_WITHIN_YEAR"]
#'       # Method 2: Create the time series in a single step
#'         achillesTs   <- getAchillesTs(connectionDetails, cdmSchema, resultsSchema, conceptId)
#'         prevTs       <- achillesTs[,"PREVALENCE"]
#'         countTs      <- achillesTs[,"COUNT_VALUE"]
#'         pwyTs        <- achillesTs[,"PROPORTION_WITHIN_YEAR"]
#'
#'@details As the name suggests, this function was designed with Achilles in mind.  An Achilles time series is a multivariate
#'         time series object consisting of three types of time series: prevalence, count, and proportion within year.  The object
#'         returned by this function should not be used in your analyses.  Instead, you should access the individual time series
#'         as per the exaples above.
#'         NB: If you supply one or more concept_ids, the data are retrieved from Achilles analysis ids 202,402,602,702,802,1802, 
#'         and 2102 (corresponding to your concept ids).
#'         If you supply a data frame, then it need not come from Achilles as per the example above.  It could be any data 
#'         frame in the correct format.
#'
#'@param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#'@param cdmSchema A fully qualified CDM schema name.
#'@param resultsSchema A fully qualified results schema name.
#'@param conceptId One more more valid concept_ids.
#'@param resultSet A dataframe in the proper format (e.g., one returned by \cr\code{getAchillesMonthlyData})
#'
#'@return A multivariate time series object
#'
#'@export


getAchillesTs <- function(connectionDetails = NULL, cdmSchema = NULL, resultsSchema = NULL, conceptId = NULL, resultSet = NULL)
{

	# Stop processing if insufficient information is given to create a time series.
	if (is.null(resultSet) & is.null(connectionDetails)) {
		stop("Must supply either database connection information to retrieve data or supply a dataframe of results") 
	}
	
	# If a data frame of results is not supplied, connect to a database and retrieve data for the given concept_ids.
	if (is.null(resultSet)) {
		resultSetData <- getAchillesMonthlyData(connectionDetails, cdmSchema, resultsSchema, conceptId)
	} else {
		resultSetData <- resultSet
	}
		
	# If the database and concept_id combination returns no rows or the supplied data frame is empty, stop processing.
    if (nrow(resultSetData) == 0) {
		stop ("Cannot create time series from an empty data frame")
	}
	
    # Convert YYYYMMDD string into a valid date
    resultSetData$START_DATE <- as.Date(resultSetData$START_DATE,"%Y%m%d")

    # Create a vector of dense dates to capture all dates between the start and end of the time series
    lastRow <- nrow(resultSetData)

    denseDates <- seq.Date(
	                from = as.Date(resultSetData$START_DATE[1],"%Y%m%d"),
	                to   = as.Date(resultSetData$START_DATE[lastRow],"%Y%m%d"),
	                by   = "month"
	             )

    # Find gaps, if any, in data (e.g., dates that have no data, give that date a 0 count and 0 prevalence)
    denseDatesDf <- data.frame(START_DATE=denseDates, CNT=rep(0,length(denseDates)))

    joinResults <- dplyr::left_join(denseDatesDf,resultSetData,by=c("START_DATE" = "START_DATE"))

    joinResults$COUNT_VALUE[which(is.na(joinResults$COUNT_VALUE))] <- 0
    joinResults$PREVALENCE[which(is.na(joinResults$PREVALENCE))]   <- 0
    joinResults$PROPORTION_WITHIN_YEAR[which(is.na(joinResults$PROPORTION_WITHIN_YEAR))]   <- 0

    # Now that we no longer have sparse dates, keep only necessary columns and build the time series
    joinResults <- joinResults[,c("START_DATE","COUNT_VALUE","PREVALENCE","PROPORTION_WITHIN_YEAR")]

	# Find the end of the dense results
    lastRow <- nrow(joinResults)

	# Create the multivariate time series
	tsData <- data.frame(
		COUNT_VALUE=joinResults$COUNT_VALUE,
		PREVALENCE=joinResults$PREVALENCE,
		PROPORTION_WITHIN_YEAR=joinResults$PROPORTION_WITHIN_YEAR
		)

    resultSetDataTs <- ts(
	  data      = tsData,
	  start     = c(as.numeric(substring(joinResults$START_DATE[1],1,4)),as.numeric(substring(joinResults$START_DATE[1],6,7))),
	  end       = c(as.numeric(substring(joinResults$START_DATE[lastRow],1,4)),as.numeric(substring(joinResults$START_DATE[lastRow],6,7))),
	  frequency = 12
    )

    return (resultSetDataTs)

}
