#' @name qry_mod_info
#' @aliases qry_mod_info
#' @title Retrieve general information about a module
#' @description Returns a dataframe showing a given module's arguments,
#' returns, and package dependencies. 
#' @param modName The name of the mod in the shinymgr database 
#' (e.g. subset_rows)
#' @param shinyMgrPath  File path to the main shiny manager project directory
#' @usage qry_mod_info(modName, shinyMgrPath)
#' @importFrom DBI dbConnect
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbReadTable
#' @importFrom DBI dbDisconnect
#' @inheritSection rerun_analysis Tutorials
#' @inherit rerun_analysis references
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
#' # get the details of the "subset_rows" modules
#' qry_mod_info(modName = "subset_rows", shinyMgrPath = shinyMgrPath)
#' 
#' #' # get the details of the "add_noise" modules
#' qry_mod_info(modName = "add_noise", shinyMgrPath = shinyMgrPath)
#' 
#' # remove demo
#' unlink(shinyMgrPath, recursive = TRUE)
#' 

qry_mod_info <- function(modName, shinyMgrPath){
  
  # connect to database
  conx <- DBI::dbConnect(
    drv = RSQLite::SQLite(),
    dbname = paste0(shinyMgrPath, "/database/shinymgr.sqlite")
  )
  
  # disconnect from database on function exit
  on.exit(expr = {
    DBI::dbDisconnect(conx)
  })
  
  # run the query
  rs <- DBI::dbGetQuery(
    conn = conx,
    statement = paste0(
      "SELECT modFunctionArguments.fkModuleName, 
          'argument' AS type,  
          modFunctionArguments.functionArgName AS name, 
          modFunctionArguments.functionArgClass AS class, 
          modFunctionArguments.description
      FROM modFunctionArguments
      WHERE (((modFunctionArguments.fkModuleName)= '", modName,"'))
      UNION
      SELECT modFunctionReturns.fkModuleName, 
        'return' AS type, 
        modFunctionReturns.functionReturnName AS name, 
        modFunctionReturns.functionReturnClass AS class,
        modFunctionReturns.description
      FROM modFunctionReturns
      WHERE (((modFunctionReturns.fkModuleName)= '", modName, "' ));"
    )
  )

  # return result
  return(rs)
}
