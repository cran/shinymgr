#' @name qry_row
#' @aliases qry_row
#' @title Retrieve one or more rows from a specified table from the 
#' shinymgr.sqlite. Used internally.
#' database given a set of conditions on one or more columns.
#' @description Returns dataframe containing specified columns and rows from the
#' shinymgr database based on specified conditions.
#' @param tableName The name of the table of the shinymgr database (e.g. 
#' people, apps, etc.).
#' @param rowConditions A dataframe where the keys correspond to columns of the
#' specified dataframe and key values correspond to the equality condition that
#' must be satisfied by any returning rows, else returns all rows (default 
#' returns all rows).
#' @param colConditions A vector specifying the names of columns to be returned 
#' from the query (default returns all columns).
#' @param shinyMgrPath  File path to the main shiny manager project directory
#' @usage qry_row(tableName, rowConditions, colConditions, shinyMgrPath)
#' @inheritSection rerun_analysis Tutorials
#' @inherit rerun_analysis references
#' @importFrom DBI dbConnect
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbReadTable
#' @importFrom DBI dbDisconnect
#' @return  Dataframe consisting of the specified rows and columns
#' @family qry
#' @export
#' @examples
#' # set the file path to the main shinymgr directory
#' parentPath <- tempdir()
#' shinyMgrPath <- paste0(parentPath, '/shinymgr')
#' 
#' shinymgr_setup(parentPath = parentPath, demo = TRUE)
#' 
#' # use the default database path
#' qry_row(
#'   tableName = 'apps', 
#'   rowConditions = data.frame(pkAppName = 'iris_explorer'), 
#'   colConditions = c('appDisplayName', 'appDescription'),
#'   shinyMgrPath = shinyMgrPath
#' )
#' 
#' # remove demo
#' unlink(shinyMgrPath, recursive = TRUE)
#' 
qry_row <- function(tableName, rowConditions = NA, colConditions = '*', shinyMgrPath){
  
  # connect to database
  conx <- DBI::dbConnect(
    drv = RSQLite::SQLite(),
    dbname = paste0(shinyMgrPath, "/database/shinymgr.sqlite")
  )
  
  # disconnect from database on function exit
  on.exit(expr = {
    DBI::dbDisconnect(conx)
  })
  
  stmnt <- paste("SELECT", paste(colConditions, collapse = ', '))
  stmnt <- paste(stmnt, 'FROM', tableName)
  
  if (is.list(rowConditions)) {
    for (i in 1:length(rowConditions)) {
      if (i == 1) {
        stmnt <- paste(stmnt, 'WHERE')
      } else {
        stmnt <- paste(stmnt, 'AND')
      }
      if (is.numeric(rowConditions[[i]])) {
        stmnt <- paste0(
          stmnt,
          " (((", 
          tableName,
          ".", 
          names(rowConditions)[i],
          ")=", 
          rowConditions[[i]],
          "))"
        )
      } else {
        stmnt <- paste0(
          stmnt,
          " (((", 
          tableName,
          ".", 
          names(rowConditions)[i],
          ")='", 
          rowConditions[[i]],
          "'))"
        )
      }
    }
  }
  stmnt <- paste0(stmnt, ';')
  
  # run query
  rs <- DBI::dbGetQuery(
    conx,
    statement = stmnt
  )
  
  # return result
  return(rs)
}
