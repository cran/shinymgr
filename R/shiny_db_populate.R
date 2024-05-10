#' @name shiny_db_populate
#' @aliases shiny_db_populate
#' @title Populates an empty shinymgr.sqlite database with demo data
#' @description Populates empty shinymgr.sqlite database
#' with demo data. The learnr tutorials illustrate the shinymgr 
#' approach and utilize the demo data.  This function is
#' typically not called; instead use \code{\link{shinymgr_setup}}
#' @param conx  A connection to the shinymgr.sqlite database
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbDriver
#' @importFrom DBI dbConnect
#' @importFrom DBI dbDisconnect
#' @importFrom DBI dbWriteTable
#' @importFrom utils data
#' @inheritSection rerun_analysis Tutorials
#' @inherit rerun_analysis references
#' @export
#' @return Returns invisible, but the shinymgr.sqlite database will be 
#' populated.
#' @details The shinymgr database is a SQLite database.  The function uses
#' the R package, RSQLite, to connect the database with R (the package
#' itself contains SQLite, so no external software is needed.  Once the
#' connection is made, the function uses database functions
#' from the package, DBI, which in turn can be used to query the database,
#' add records, etc.) This function is not intended to be used. 
#' Rather, users should use \code{\link{shinymgr_setup}} to copy the
#' database  instance that comes with the package.  The function is
#' included here so users can inspect the code used to create the database.
#' @family database
#' @export
#' @examples
#'
#' # ------------------------------------------------------------
#' # Set up an empty database for demonstration and then delete it
#' # ------------------------------------------------------------
#'
#' # Create the database (to be deleted):
#' db_dir <- tempdir()
#' db_path <- paste0(db_dir, "/shinymgr.sqlite")
#' shiny_db_create(db_path = db_path)
#'
#' 
#' # Verify that the database exists in your current working directory
#' file.exists(db_path)
#' 
#' # function will populate an empty sqlite database with the RData files 
#' # in the package's data folder
#' conx <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = db_path)
#' shiny_db_populate(conx)
#' 
#' # look at some tables with R coding
#' DBI::dbReadTable(conx, "apps")
#' DBI::dbReadTable(conx, "modules")
#' 
#' # disconnect from database
#' DBI::dbDisconnect(conx)
#'
#' # Remove demo database
#' unlink(db_path)
#' 
shiny_db_populate <- function(conx) {
  
  # set up the vector of tables, primary tables first, then tables with foreign keys
  dbTables <- c(
    'apps',
    'reports',
    'appReports',
    'tabs',
    'modules',
    'appTabs',
    'tabModules',
    'modPackages',
    'modFunctionArguments',
    'modFunctionReturns',
    'appStitching'
  )
  
  # loop through tables and create them
  for (i in 1:length(dbTables)) {
    
    # get table name
    tableName <- dbTables[i]
    
    # get table values
    assign("tbl", get(tableName))
    
    # upload tables
    DBI::dbWriteTable(
      conn = conx, 
      name = tableName, 
      value = tbl, 
      append = TRUE
    )
  }
  
} # end of function
