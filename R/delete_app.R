#' @name delete_app
#' @aliases delete_app
#' @title Deletes an app from the database
#' @description Deletes an app (and associated files if requested) from the 
#' shinymgr.sqlite database
#' @param appName The name of the app to be deleted
#' @param shinyMgrPath The path to the shinymgr project. Typically the working 
#' directory.
#' @param fileDelete TRUE/FALSE, whether the app script should also be deleted 
#' - defaults to FALSE.
#' @usage delete_app(appName, shinyMgrPath, fileDelete = FALSE)
#' @section More Info:
#' The delete_app() function is described in the "app_modules" tutorial.
#' @inheritSection rerun_analysis Tutorials
#' @inherit rerun_analysis references
#' @return An integer value with the total number of rows deleted (including 
#' cascades)
#' @family delete
#' @export


delete_app <- function(appName, shinyMgrPath, fileDelete = FALSE) {
  
  #get tab names
  tabNames <- qry_row(
    tableName = "appTabs", 
    rowConditions = list(fkAppName = appName),
    colConditions = "fkTabName",
    shinyMgrPath = shinyMgrPath
  )$fkTabName
  
  #connect to database and turn on foreign keys
  conx <- DBI::dbConnect(RSQLite::SQLite(), dbname = paste0(shinyMgrPath, "/database/shinymgr.sqlite"))
  rs <- DBI::dbSendQuery(conn = conx, statement = "PRAGMA foreign_keys = ON;")
  DBI::dbClearResult(rs)
  
  # disconnect from database on function exit
  on.exit(expr = {
    DBI::dbDisconnect(conx)
  })
  
  #delete tabs
  deletedTabs <- DBI::dbExecute(
    conn = conx,
    statement = paste0(
      "DELETE FROM tabs WHERE pkTabName IN ('",
      paste(tabNames, collapse = "','"),
      "');"
    )
  )
  
  #delete app
  deletedApp <- DBI::dbExecute(
    conn = conx,
    statement = paste0(
      "DELETE FROM apps WHERE pkAppName = '",
      appName,
      "';"
    )
  )
  
  #delete file if true
  if (fileDelete == T) {
    if (file.exists(paste0(shinyMgrPath, "/modules_app/", appName, ".R"))) {
      file.remove(paste0(shinyMgrPath, "/modules_app/", appName, ".R"))
      print("File removed successfully")
    } else {
      print("File not found, is it already deleted?")
    }
  }
  
  return(deletedTabs + deletedApp)
}
