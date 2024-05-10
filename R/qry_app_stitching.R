#' @name qry_app_stitching
#' @aliases qry_app_stitching
#' @title Retrieve structure of an app module
#' @description Returns a dataframe showing how outputs from one module are
#' "stitched" as inputs to downstream modules in a shinymgr app 
#' @param appName The name of the app in the shinymgr database 
#' (e.g. iris_explorer)
#' @param shinyMgrPath  File path to the main shiny manager project directory
#' @usage qry_app_stitching(appName, shinyMgrPath)
#' @importFrom DBI dbConnect
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbReadTable
#' @importFrom DBI dbDisconnect
#' @return  Dataframe consisting of the specified rows and columns
#' @inheritSection rerun_analysis Tutorials
#' @inherit rerun_analysis references
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
#' qry_app_stitching(appName = "iris_explorer", shinyMgrPath = shinyMgrPath)
#' 
#' # remove demo
#' unlink(shinyMgrPath, recursive = TRUE)
#' 

qry_app_stitching <- function(appName, shinyMgrPath){
  
  # connect to database
  conx <- DBI::dbConnect(
    drv = RSQLite::SQLite(),
    dbname = paste0(shinyMgrPath, "/database/shinymgr.sqlite")
  )
  
  rs <- DBI::dbGetQuery(
    conn = conx,
    statement = paste0(
      "SELECT appStitching.fkAppName, 
      tabModules.fkTabName, 
      appTabs.tabOrder, 
      tabModules.fkModuleName, 
      tabModules.modOrder, 
      modFunctionArguments.functionArgName, 
      modFunctionArguments.functionArgClass, 
      modFunctionReturns.
      functionReturnName, 
      modFunctionReturns.functionReturnClass
      FROM (tabModules INNER JOIN appTabs ON tabModules.fkTabName = appTabs.fkTabName) 
      INNER JOIN ((appStitching 
        LEFT JOIN modFunctionArguments ON appStitching.fkModArgID = modFunctionArguments.pkModArgID) 
        LEFT JOIN modFunctionReturns ON appStitching.fkModReturnID = modFunctionReturns.pkModReturnID) 
      ON tabModules.pkInstanceID = appStitching.fkInstanceID
      WHERE (((appStitching.fkAppName)='", appName, "'))
      ORDER BY appTabs.tabOrder, tabModules.modOrder;"
    )
  )
  
  # disconnect from database
  DBI::dbDisconnect(conx)
  
  # return result
  return(rs)
}
