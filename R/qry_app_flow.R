#' @name qry_app_flow
#' @aliases qry_app_flow
#' @title Retrieve structure of an app module
#' @description Returns a dataframe showing the ordered layout of a
#' shinymgr app (e.g., tabs, modules, and the order of presentation). 
#' @param appName The name of the app in the shinymgr database 
#' (e.g. iris_explorer)
#' @param shinyMgrPath  File path to the main shiny manager project directory
#' @usage qry_app_flow(appName, shinyMgrPath)
#' @importFrom DBI dbConnect
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbReadTable
#' @importFrom DBI dbDisconnect
#' @section More Info:
#' The qry_app_flow() function is described in the "app_modules" tutorial.
#' @inheritSection rerun_analysis Tutorials
#' @inherit rerun_analysis references
#' @return  Dataframe consisting of the specified rows and columns
#' @family qry
#' @export
#' @examples
#' 
#' # set the file path to the main shinymgr directory
#' parentPath <- tempdir()
#' shinyMgrPath <- paste0(parentPath, '/shinymgr')
#' 
#' shinymgr_setup(parentPath = parentPath, demo = TRUE)
#' 
#' # get the structure of the iris_explorer app
#' qry_app_flow(appName = "iris_explorer", shinyMgrPath = shinyMgrPath)
#' 
#' # remove demo
#' unlink(shinyMgrPath, recursive = TRUE)
#' 

qry_app_flow <- function(appName, shinyMgrPath){
  
  # connect to database
  conx <- DBI::dbConnect(
    drv = RSQLite::SQLite(),
    dbname = paste0(shinyMgrPath, "/database/shinymgr.sqlite")
  )
  
  rs <- DBI::dbGetQuery(
    conn = conx,
    statement = paste0(
      "SELECT appTabs.fkAppName, 
      appTabs.fkTabName, 
      appTabs.tabOrder, 
      tabModules.fkModuleName, 
      tabModules.modOrder
      FROM appTabs INNER JOIN tabModules ON appTabs.fkTabName = tabModules.fkTabName
      WHERE (((appTabs.fkAppName)='", appName, "'))
      ORDER BY appTabs.tabOrder, tabModules.modOrder;"
    )
  )
  
  # disconnect from database
  DBI::dbDisconnect(conx)
  
  # return result
  return(rs)
}
