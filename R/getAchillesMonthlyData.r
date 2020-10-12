#'@title Get Achilles monthly data by concept_id or set of concept_ids
#'
#'@description Return monthly count, prevalence, and proportion within year data from ACHILLES_RESULTS
#'             for a specified concept_id or set of concept_ids.
#'
#'@usage AchillesResultSet <- getAchillesMonthlyData (connectionDetails, cdmSchema, resultsSchema, conceptId)
#'
#'@param connectionDetails  An R object of type\cr\code{connectionDetails} created using the
#'                                     function \code{createConnectionDetails} in the
#'                                     \code{DatabaseConnector} package.
#'@param cdmSchema A fully qualified CDM schema name.
#'@param resultsSchema A fully qualified results schema name.
#'@param conceptId One more more valid concept_ids.
#'
#'@details 
#' \preformatted{Currently supported Achilles monthly analyses are:
#' 202  - Visit Occurrence
#' 402  - Condition occurrence
#' 602  - Procedire Occurrence
#' 702  - Drug Exposure
#' 802  - Observation
#' 1802 - Measurement
#' 2102 - Device}
#'
#'@return A dataframe of query results.
#'
#'@export


getAchillesMonthlyData <- function(connectionDetails, cdmSchema, resultsSchema, conceptId)
{

    translatedSql <- SqlRender::loadRenderTranslateSql(
	  sqlFilename     = "achilles_monthly_data.sql",
	  packageName     = "Castor",
	  dbms            = connectionDetails$dbms,
	  cdm_schema      = cdmSchema,
	  results_schema  = resultsSchema,
	  conceptIds      = conceptId)

	conn <- DatabaseConnector::connect(connectionDetails)

    queryResults <- DatabaseConnector::querySql(conn,translatedSql)

    on.exit(DatabaseConnector::disconnect(conn))

	return(queryResults)

}
