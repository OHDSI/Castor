#'@title Build a univariate time series of counts (or distinct counts) from a specified table and columns
#'
#'@description Build a univariate time series object from a specified table within a given data range.
#'
#'@usage  
#'
#'@param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#'@param dbSchema A fully qualified CDM or Results schema name.
#'@param tableName A  valid table name.
#'@param dateColumnName A valid date column in the specified table.
#'@param startDate A string date in the "YYYY-MM-DD" format
#'@param endDate A string date in the "YYYY-MM-DD" format
#'@param dataColumnName The column in the specified table to count.
#'@param isCountDistinct A boolean indicating whether or not to count distinct rows of the specified data column.
#'@param frequency A string indicating the number of observations per unit of time in the time series.
#'                 Acceptable values are "day","week","month","quarter", and "year".
#'
#'@return A univariate time series object
#'
#'@export


getCountTs <- function(
	connectionDetails,
	dbSchema,
	tableName,
	dateColumnName,
	startDate,
	endDate,
	dataColumnName,
	isCountDistinct,
	frequency)
{

	if (isCountDistinct) {
		countClause <- paste0("count(distinct ",dataColumnName,")")
	} else {
		countClause <- paste0("count(",dataColumnName,")")
	}	
	
	query <- "
		select @date_column_name as start_date, @count_clause as count_value 
		  from @db_schema.@table_name
		 where @date_column_name >= '@start_date' and @date_column_name <= '@end_date'	  
		 group by @date_column_name 
		 order by @date_column_name;"
	
	query <- SqlRender::render(
		sql              = query,
		date_column_name = dateColumnName,
		count_clause     = countClause,
		db_schema        = dbSchema,
		table_name       = tableName,
		start_date       = startDate,
		end_date         = endDate)

	query <- SqlRender::translate(query, targetDialect = connectionDetails$dbms)

	conn <- DatabaseConnector::connect(connectionDetails)
	
	resultSetData <- DatabaseConnector::querySql(conn,query)
	
    if (nrow(resultSetData) == 0) stop ("Cannot create time series from an empty data frame")
	
	freqString <- tolower(frequency)
	
	# Find the correct starting point for the first element in the time series
	# to form the c(startYear,startPos) vector given to the "start" argument of the time series

	startYear <- as.integer(strftime(resultSetData$START_DATE[1], format = "%Y"))

    if (freqString == "day") {
		freqNum  <- 365
		startPos <- as.integer(strftime(resultSetData$START_DATE[1], format = "%j"))
	} else if (freqString ==  "week") {
		freqNum  <- 52
		startPos <- as.integer(strftime(resultSetData$START_DATE[1], format = "%W"))
	} else if (freqString ==  "month") {
		freqNum  <- 12
		startPos <- as.integer(strftime(resultSetData$START_DATE[1], format = "%m"))
	} else if (freqString ==  "quarter") {
		freqNum  <- 4
		startPos <- ceiling(as.integer(strftime(resultSetData$START_DATE[1], format = "%m"))/12)
	} else if (freqString ==  "year") {
		freqNum  <- 1
		startPos <- 1 
	} else {
		stop("Invalid frequency string: Acceptable values are \"day\", \"week\", \"month\", \"quarter\", and \"year\"")
	}

    # Create a vector of dense dates to capture all dates between the start and end of the time series
    lastRow <- nrow(resultSetData)

    denseDates <- seq.Date(
	                from = as.Date(resultSetData$START_DATE[1],"%Y-%m-%d"),
	                to   = as.Date(resultSetData$START_DATE[lastRow],"%Y-%m-%d"),
	                by   = freqString
	             )

    # Find gaps, if any, in data (e.g., dates that have no data, give that date a 0 count)
    denseDatesDf <- data.frame(START_DATE=denseDates, CNT=rep(0,length(denseDates)))

    joinResults <- dplyr::left_join(denseDatesDf,resultSetData,by=c("START_DATE" = "START_DATE"))

    joinResults$COUNT_VALUE[which(is.na(joinResults$COUNT_VALUE))] <- 0

    # Now that we no longer have sparse dates, keep only necessary columns and build the time series
    joinResults <- joinResults[,c("START_DATE","COUNT_VALUE")]

    resultSetDataTs <- ts(
	  data      = joinResults$COUNT_VALUE,
	  start     = c(startYear,startPos),
	  frequency = freqNum
    )
	
	on.exit(DatabaseConnector::disconnect(conn))

    return (resultSetDataTs)

}
