#' @name check_mod_info
#' @aliases check_mod_info
#' @title Compares mod header information to the database
#' @description This function checks that mod header information matches what's in
#' the database to ensure that modules will be called and stitched correctly.
#' @param modName The name of the module
#' @param shinyMgrPath The path to the shinymgr folder.
#' @param verbose Whether to print updates to the console (default = TRUE)
#' @usage check_mod_info(modName, shinyMgrPath, verbose = TRUE)
#' @return A list containing dataframes of logicals indicating whether fields are 
#' consistent between the module script header and the database. These include:
#'   1. Data for the modules table
#'   2. Data for the modFunctionArguments table
#'   3. Data for the modFunctionReturns table
#' A value of TRUE indicates that the fields match, and FALSE indicates a mismatch.
#' @section More Info:
#' The check_mod_info() function is described in the "shinymgr_modules" tutorial.
#' @inheritSection rerun_analysis Tutorials
#' @family module
#' @export
#' @examples
#'
#' # establish shinyMgrPath
#' parentPath <- tempdir()
#' shinyMgrPath <- paste0(parentPath, '/shinymgr')
#' 
#' # Create a demo database
#' shinymgr_setup(parentPath = parentPath, demo = TRUE)
#'
#' #check info for different modules
#' check_mod_info(modName = "subset_rows", shinyMgrPath = shinyMgrPath)
#'   
#' check_mod_info(modName = "add_noise", shinyMgrPath = shinyMgrPath)
#'   
#' # Remove demo database
#' unlink(shinyMgrPath, recursive = TRUE)
#' 

check_mod_info <- function(modName, shinyMgrPath, verbose = TRUE) {
  
  #get mod header
  modHeader <- mod_header_parser(
    paste0(
      shinyMgrPath,
      "/modules/",
      modName,
      ".R"
    )
  )
  
  #check mod header against mod info
  modInfo <- qry_row(
    tableName = "modules",
    rowConditions = list(pkModuleName = modName),
    shinyMgrPath = shinyMgrPath
  )
  
  if (nrow(modInfo) == 0) {
    stop("This module is not in the database.")
  }
  
  modInfo_check <- modHeader[[1]][,-which(names(modHeader[[1]]) == "dateCreated")] == 
    modInfo[,-which(names(modInfo) == "dateCreated")]
  
  if (verbose) {
    if (nrow(modHeader[[1]]) == 0) {
      print("There is no module header information")
    } else if (sum(modInfo_check, na.rm = TRUE) == (ncol(modInfo) - 1 - sum(is.na(modInfo)))) {
      print("Everything in the modules table matches.")
    } else {
      print("There is a mismatch in the module information (See output for details).")
    }
  }
  
  #check arguments
  modArgs <- qry_row(
    tableName = "modFunctionArguments",
    rowConditions = list(fkModuleName = modName),
    shinyMgrPath = shinyMgrPath
  )
  
  modArgs_check <- modHeader[[2]] == 
    modArgs[, -which(names(modArgs) %in% c("pkModArgID", "fkModuleName"))]
  
  if (verbose) {
    if (nrow(modHeader[[2]]) == 0 & nrow(modArgs) == 0) {
      print("This module has no arguments.")
    } else if (sum(modArgs_check, na.rm = TRUE) == ((ncol(modArgs) - 2) * nrow(modArgs) - sum(is.na(modArgs)))) {
      print("Everything in the modFunctionArguments table matches.")
    } else {
      print("There is a mismatch in the module arguments (See output for details).")
    }
  }
  
  #check returns
  modReturns <- qry_row(
    tableName = "modFunctionReturns",
    rowConditions = list(fkModuleName = modName),
    shinyMgrPath = shinyMgrPath
  )
  
  modReturns_check <- modHeader[[3]] == 
    modReturns[, -which(names(modReturns) %in% c("pkModReturnID", "fkModuleName"))]
  
  if (verbose) {
    if (nrow(modHeader[[3]]) == 0 & nrow(modReturns) == 0) {
      print("This module has no returns.")
    } else if (sum(modReturns_check, na.rm = TRUE) == ((ncol(modReturns) - 2) * nrow(modReturns) - sum(is.na(modReturns)))) {
      print("Everything in the modFunctionReturns table matches.")
    } else {
      print("There is a mismatch in the module returns (See output for details).")
    }
  }
 
  return(
    list(
      modInfo = modInfo_check,
      modArgs = modArgs_check,
      modRtrns = modReturns_check
    )
  )
}
