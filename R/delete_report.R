#' @name delete_report
#' @aliases delete_report
#' @title Deletes a report from the database
#' @description Deletes a report (and associated file if requested) from 
#' the shinymgr.sqlite database
#' @param reportName The name of the report to be deleted, character string.
#' @param shinyMgrPath The path to the shinymgr project. Typically the 
#' working directory.
#' @param fileDelete TRUE/FALSE, whether the report .Rmd file should also 
#' be deleted - defaults to FALSE.
#' @usage delete_report(reportName, shinyMgrPath, fileDelete = FALSE)
#' @return An integer value with the total number of rows deleted 
#' (including cascades)
#' @section More Info:
#' The delete_report() function is described in the "reports" tutorial.
#' @inheritSection rerun_analysis Tutorials
#' @inherit rerun_analysis references
#' @family delete
#' @export


delete_report <- function(reportName, shinyMgrPath, fileDelete = FALSE) {
  #connect to database and turn on foreign keys
  conx <- DBI::dbConnect(RSQLite::SQLite(), dbname = paste0(shinyMgrPath, "/database/shinymgr.sqlite"))
  rs <- DBI::dbSendQuery(conn = conx, statement = "PRAGMA foreign_keys = ON;")
  DBI::dbClearResult(rs)
  
  # disconnect from database on function exit
  on.exit(expr = {
    DBI::dbDisconnect(conx)
  })
  
  #delete report
  deletedReport <- DBI::dbExecute(
    conn = conx,
    statement = paste0(
      "DELETE FROM reports WHERE pkReportName = '",
      reportName,
      "';"
    )
  )
  
  #delete file if true
  if (fileDelete == T) {
    file.remove(
      list.files(
        path = paste0(shinyMgrPath, "/reports"),
        pattern = paste0(reportName, ".Rmd"),
        recursive = TRUE,
        full.names = TRUE
      )
    )
  }
  
  
  #return number of rows 
  return(deletedReport)
}
