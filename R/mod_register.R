#' @name mod_register
#' @aliases mod_register
#' @title Register (inserts) a new module into the shinymgr project
#' @description Insert a new record into the shinymgr.sqlite database table
#' "modules" and accompanying tables ("modFunctionArguments", 
#' "modFunctionReturns", "modPackages")
#' @param modName Name of the new module
#' @param shinyMgrPath  Directory that holds the main shinymgr project
#' @usage mod_register(modName, shinyMgrPath)
#' @importFrom renv dependencies
#' @importFrom utils packageVersion
#' @return Nothing.  Records are inserted into shinymgr.sqlite. 
#' @details This function reads in a module file created by 
#' \code{\link{mod_init}}
#' and parses the header using \code{\link{mod_header_parser}} to populate the 
#' modules, modFunctionArguments, modFunctionReturns, and modPackages tables of
#' the
#' shinymgr.sqlite  database. These tables are referenced in the app builder, 
#' so module headers must match the module functions exactly.
#' @family module
#' @section More Info:
#' The mod_register() function is described in the "shinymgr_modules" tutorial.
#' @inheritSection rerun_analysis Tutorials
#' @inherit rerun_analysis references
#' @export
#' @seealso \code{\link{mod_init}}
#'
mod_register <- function(modName, shinyMgrPath) {
  
  # check the module file exists in the module folder
  modFileName <- paste0(shinyMgrPath, "/modules/", modName, ".R")
  fe <- file.exists(modFileName)
  if (fe == FALSE) stop("The module does not exist in the modules directory.")

  # run query --
  rs <- shinymgr::qry_row(
    tableName = "modules",
    rowConditions = data.frame(pkModuleName = modName),
    shinyMgrPath = shinyMgrPath
  )

  if (nrow(rs) == 1) stop("The module has already been registered in the database. Perhaps
                         use mod_update() or mod_delete()?")

  # parse the module function to retrieve dataframes for uploading
  parsed_header <- shinymgr::mod_header_parser(modFileName)

  # insert the module
  new_module_rows <- data.frame(
    pkModuleName = parsed_header[[1]]$pkModuleName,
    modDisplayName = parsed_header[[1]]$modDisplayName,
    modDescription = parsed_header[[1]]$modDescription,
    modCitation = parsed_header[[1]]$modCitation,
    modNotes = parsed_header[[1]]$modNotes,
    modActive = parsed_header[[1]]$modActive,
    dateCreated = as.character(date())
  )
  rslt <- shinymgr::qry_insert("modules", new_module_rows, shinyMgrPath)

  if (is.na(as.numeric(rslt))) stop(paste("Error, module load failed:", rslt))

  # insert the modFunctionArguments table
  new_args_rows <- cbind(
    list(fkModuleName = rep(modName, nrow(parsed_header[[2]]))), 
    parsed_header[[2]]
  )
  rslt <- shinymgr::qry_insert("modFunctionArguments", new_args_rows, shinyMgrPath)
  if (is.na(as.numeric(rslt))) stop(paste("Error, module load failed:", rslt))

  # populate modFunctionReturns table
  new_returns_rows <- cbind(
    list(fkModuleName = rep(modName, nrow(parsed_header[[3]]))), 
    parsed_header[[3]]
  )
  rslt <- shinymgr::qry_insert("modFunctionReturns", new_returns_rows, shinyMgrPath)
  if (is.na(as.numeric(rslt))) stop(paste("Error, module load failed:", rslt))

  # insert the modPackages table
  dep <- renv::dependencies(modFileName, progress = FALSE)
  
  # remove renv from dep
  dep <- subset(dep, 'Package' != "renv")
  
  if (nrow(dep) != 0) {
    # loop through dependencies and add version number
    for (i in seq_len(nrow(dep))) {
      dep[i, "Version"] <- as.character(utils::packageVersion(dep[i, "Package"]))
    }
    
    newpackages <- data.frame(
      fkModuleName = modName, 
      packageName = dep[,"Package"], 
      version = dep[, "Version"]
    )
    
    # insert into database table modPackage table
    rslt <- shinymgr::qry_insert("modPackages", newpackages, shinyMgrPath)
    if (is.na(as.numeric(rslt))) stop(paste("Error, module load failed:", rslt))
  }
}
