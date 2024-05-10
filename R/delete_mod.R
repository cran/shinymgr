#' @name delete_mod
#' @aliases delete_mod
#' @title Deletes a module from the database
#' @description Deletes a module (and associated files if requested) from the 
#' shinymgr.sqlite database
#' @param modName The name of the module to be deleted, character string.
#' @param shinyMgrPath The path to the shinymgr project. Typically the working 
#' directory.
#' @param fileDelete TRUE/FALSE, whether the module script should also be 
#' deleted - defaults to FALSE.
#' @param verbose Whether to print updates to the console (default = TRUE)
#' @usage delete_mod(modName, shinyMgrPath, fileDelete = FALSE, 
#' verbose = TRUE)
#' @section More Info:
#' The delete_mod() function is described in the "shinymgr_modules" tutorial.
#' @inheritSection rerun_analysis Tutorials
#' @inherit rerun_analysis references
#' @return An integer value with the total number of rows deleted (including 
#' cascades)
#' @family delete
#' @export


delete_mod <- function(modName, shinyMgrPath, fileDelete = FALSE, verbose = TRUE) {
  
  #connect to database and turn on foreign keys
  conx <- DBI::dbConnect(RSQLite::SQLite(), dbname = paste0(shinyMgrPath, "/database/shinymgr.sqlite"))
  rs <- DBI::dbSendQuery(conn = conx, statement = "PRAGMA foreign_keys = ON;")
  DBI::dbClearResult(rs)
  
  # disconnect from database on function exit
  on.exit(expr = {
    DBI::dbDisconnect(conx)
  })
  
  #delete mod
  deletedMod <- DBI::dbExecute(
    conn = conx,
    statement = paste0(
      "DELETE FROM modules WHERE pkModuleName = '",
      modName,
      "';"
    )
  )
  
  #delete file if true
  if (fileDelete == T) {
    if (file.exists(paste0(shinyMgrPath, "/modules/", modName, ".R"))) {
      file.remove(paste0(shinyMgrPath, "/modules/", modName, ".R"))
      if (verbose) {print("File removed successfully")}
    } else {
      if (verbose) {print("File not found, is it already deleted?")}
    }
  }
  
  
  #return number of rows 
  return(deletedMod)
  
}
