#' @name shiny_db_create
#' @aliases shiny_db_create
#' @title Create an empty *shinymgr* SQLite database, and populate with 
#' demo data if desired.
#' @description Create an empty *shinymgr* SQLite database for managing
#' multiple apps and scripts in a common framework.  This function is
#' typically not called; instead use \code{\link{shinymgr_setup}}
#' @param db_path  Filepath that will house the sqlite database
#' @param demo Logical. Should demo data be included?
#' @usage shiny_db_create(db_path, demo)
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbDriver
#' @importFrom DBI dbConnect
#' @importFrom DBI dbDisconnect
#' @importFrom DBI dbSendQuery
#' @importFrom DBI dbClearResult
#' @importFrom DBI dbListTables
#' @importFrom utils read.csv
#' @inheritSection rerun_analysis Tutorials
#' @inherit rerun_analysis references
#' @export
#' @return Returns a *shinymgr* SQLite database.
#' @details The *shinymgr* database is a SQLite database.  The function uses
#' the R package, RSQLite, to connect the database with R (the package
#' itself contains SQLite, so no external software is needed.  Once the
#' connection is made, the function uses database functions
#' from the package, DBI, which in turn can be used to query the database,
#' add records, etc.) This function is not intended to be used. 
#' Rather, users should use \code{\link{shinymgr_setup}} to create the
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
#' # create the database (to be deleted):
#' db_dir <- tempdir()
#' db_path <- paste0(db_dir, "/shinymgr.sqlite")
#' shiny_db_create(
#'   db_path  = db_path,
#'   demo = TRUE)
#' 
#' # verify that the database exists in your current working directory
#' file.exists(db_path)
#'
#' # to work with a database *outside* of a *shinymgr* function, 
#' # load the DBI package first and use RSQLite to set the driver
#' conx <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = db_path)
#'
#' # look at the overall schema
#' DBI::dbReadTable(conn = conx, "sqlite_master")
#' 
#' # look at the tables in the database
#' DBI::dbListTables(conx)
#'
#' # look at fields in table apps
#' DBI::dbListFields(conx, "apps")
#' 
#' # get more detailed information with a query
#' DBI::dbGetQuery(conx, 
#'   statement = "PRAGMA table_info('apps');"
#'   )
#'
#' # disconnect from database
#' DBI::dbDisconnect(conx)
#'
#' # Delete the test database and remove it from your working directory
#' unlink(db_path)
#' 

shiny_db_create <- function(db_path, demo = FALSE){
  
  # stop if database already exists
  if (file.exists(db_path) == TRUE)
    stop("An existing database with the same name already exists. 
    Set up a new shinymgr project elsewhere on your machine?")
  
  # set the driver; use RSQLite because the package itself contains SQLite; 
  # no external software is needed
  sqlite <- RSQLite::SQLite()
  
  # create new database and connect to it
  conx <- DBI::dbConnect(drv = sqlite, dbname = db_path)

  # read in the db instructions
  fpath <- system.file("extdata", "dictionary.csv", package = "shinymgr")
  dictionary <- utils::read.csv(fpath, na.strings = "")
  
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
    
    # get table and foreign key info for the table
    tableInfo <- dictionary[dictionary$pkTableName == dbTables[i], ]
    fkInfo <- tableInfo[!is.na(tableInfo$foreignKeyTable), ]
    
    # logicals indicating whether the table has a foreign key or compount primary key
    compoundPk <- sum(tableInfo$pk != 0) > 1
    hasFk <- nrow(fkInfo) != 0
    
    # begin the query statement (stmnt will be concatenated to to build the query)
    stmnt <- paste("CREATE TABLE", dbTables[i], "(")
    
    # loop through each field in the table
    for (j in 1:nrow(tableInfo)) {
      
      # add Field name and data type
      stmnt <- paste(
        stmnt, 
        tableInfo$pkFieldName[j],
        tableInfo$varType[j]
      )
      
      # add NOT NULL clause
      if (!is.na(tableInfo$notNullClause[j])) {
        stmnt <- paste(stmnt, tableInfo$notNullClause[j])
      }
      
      # add default value
      if (!is.na(tableInfo$defaultValue[j])) {
        stmnt <- paste(stmnt, "DEFAULT", tableInfo$defaultValue[j])
      }
      
      # indicator for non-compound primary keys
      if (tableInfo$pk[j] & !compoundPk) {
        stmnt <- paste(stmnt, "PRIMARY KEY")
      }
      
      if (j != nrow(tableInfo) | compoundPk) { # | hasFk) {
        stmnt <- paste0(stmnt, ",")
      }
      
      # add the field description (as a comment)
      if (!is.na(tableInfo$description[j])) {
        stmnt <- paste(stmnt, "--", tableInfo$description[j], " ")
      }
    }
    
    # add compound primary key
    if (compoundPk) {
      stmnt <- paste(
        stmnt, 
        "PRIMARY KEY (",
        paste(
          tableInfo$pkFieldName[tableInfo$pk != 0], 
          collapse = ", "
        ), 
        ")"
      )
    }
    
    # add foreign keys
    if (hasFk) {
      stmnt <- paste0(stmnt, ", ")
      for (j in 1:nrow(fkInfo)) {
        stmnt <- paste0(
          stmnt,
          " FOREIGN KEY (", 
          fkInfo$pkFieldName[j],
          ") REFERENCES ",
          fkInfo$foreignKeyTable[j], "(",
          fkInfo$foreignKeyField[j],
          ") ON UPDATE ",
          fkInfo$on_update[j],
          " ON DELETE ",
          fkInfo$on_delete[j]
        )
      }
    }
    
    # close off the query statement
    stmnt <- paste0(stmnt, ");")
    
    # execute the query
    rs <- tryCatch({
      DBI::dbSendQuery(
        conn = conx,
        statement = stmnt
      )
    },
    error = function(cond) {
      # Pause execution if there is an error (for debugging)
      # Ultimately we'll probably want to do something if more
      # useful than going into browser mode.
      DBI::dbDisconnect(conx)
      browser()
    },
    warning = function(cond) {
      # For debugging purposed... probably just let warnings generate w/o catching
      DBI::dbDisconnect(conx)
      browser()
    })
    
    # clear the result
    DBI::dbClearResult(rs)
  }
  
  if (demo == TRUE) {
    shiny_db_populate(conx)
    message(paste0(
      "A demo shinymgr database has been created with the name 'shinymgr.sqlite',
    which consists of the following tables: "
    ))
    message(paste(DBI::dbListTables(conn = conx), sep = "", collapse = ", "))
  } else
    
  {
    # send a user message:
    message(paste0(
      "A new shinymgr database has been created with the name 'shinymgr.sqlite',
    which consists of the following tables: "
    ))
    message(paste(DBI::dbListTables(conn = conx), sep = "", collapse = ", ")) 
  }
 
  # disconnect from database
  DBI::dbDisconnect(conx)
}


