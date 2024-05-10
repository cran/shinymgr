#' @name qry_insert
#' @aliases qry_insert
#' @title Insert a row into a table from the shinymgr.sqlite database
#' @description Inserts a record(s) to a specified table in the shinymgr 
#' database. Used internally as all database tables are populated by shinymgr
#' functions.
#' @param tableName The name of a table from the shinymgr database to append.
#' @param rowValues The values of a row to be inserted into the specified table.
#' Note: this must be passed as a data frame whose columns match exactly the
#' table being appended to.
#' @param shinyMgrPath  File path to the main shiny manager project directory
#' @usage qry_insert(tableName, rowValues, shinyMgrPath)
#' @inheritSection rerun_analysis Tutorials
#' @inherit rerun_analysis references
#' @importFrom DBI dbConnect
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbAppendTable
#' @importFrom RSQLite dbClearResult
#' @importFrom DBI dbDisconnect
#' @return integer, number of rows appended
#' @family qry
#' @keywords internal
#' @export

qry_insert <- function(tableName, rowValues, shinyMgrPath) {

  # connect to database
  conx <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = paste0(shinyMgrPath, "/database/shinymgr.sqlite"))
  
  # disconnect from database on function exit
  on.exit(expr = {
    DBI::dbDisconnect(conx)
  })

  # Turn on SQLite foreign key constraints
  rs <- DBI::dbSendQuery(conx, statement = "PRAGMA foreign_keys = ON;")
  DBI::dbClearResult(rs)

  # Add new row to table "tableName" or return an error message
  dbw <- tryCatch(
    {
      DBI::dbAppendTable(
        conn = conx,
        name = tableName,
        value = rowValues,
        row.names = NULL
      )
    },
    error = function(e) {
      e$message
    }
  )

  # return result
  return(dbw)
}
