#' @name appReports
#' @title Sample data for the shinymgr.sqlite table, "appReports"
#' @description Sample data imported to the shinymgr SQLite database
#'  by the function \code{\link{shiny_db_populate}}.
#' @docType data
#' @usage data(demo_data)
#' @format  A data frame with 3 observations on the following 3 variables.
#' @field fkAppName  References an appName from the "apps" table.
#' @field fkReportName Reference a report from the "reports" table.
#' @field notes Notes about a report for a given app.
#' @family data
#' @details Reports are added to the shinymgr.sqlite database via the "Add
#' "Reports" menu in shinymgr's Developer section.
#' @examples
#' 
#' # read in the demo data
#' data("demo_data")
#' 
#' # look at the structure
#' str(appReports)
#' 
NULL
#' -----------------------------------------------------------
#' @name appStitching
#' @title Sample data for the shinymgr.sqlite table, "appStitching"
#' @description Sample data imported to the shinymgr SQLite database
#'  by the function \code{\link{shiny_db_populate}}.
#' @docType data
#' @usage data(demo_data)
#' @format  A data frame with 30 observations on the following 6 variables.
#' @field pkStitchID  Auto-number primary key.
#' @field fkAppName References pkAppName in the "apps" table.
#' @field fkInstanceID References pkInstanceID in the "tabModules" table.
#' @field fkModArgID  Reference pkModArgID in the "modFunctionArguments" table.
#' @field fkModReturnID Reference pkModReturnID in the "modFunctionReturns" 
#' table.
#' @field fkStitchID  References the stitch that preceeds a given stitch 
#' (record).
#' @family data
#' @details appSTitching records are added to the shinymgr.sqlite database 
#' via the "App Builder" interface within shinymgr's Developer section.
#' @examples
#' 
#' # read in the demo data
#' data("demo_data")
#' 
#' # look at the structure
#' str(appStitching)
#' 
NULL
#' -----------------------------------------------------------
#' @name appTabs
#' @title Sample data for the shinymgr.sqlite table, "appTabs"
#' @description Sample data imported to the shinymgr SQLite database
#'  by the function \code{\link{shiny_db_populate}}.
#' @docType data
#' @usage data(demo_data)
#' @format  A data frame with 9 observations on the following 3 variables.
#' @field fkTabName  References pkTabName in the "tabs" table.
#' @field fkAppName References pkAppName in the "apps" table.
#' @field tabOrder Specifies the order of tabs as presented to user.
#' @family data
#' @details Records to the "appTabs" table are added to the shinymgr.sqlite 
#' database via the "App Builder" interface within shinymgr's Developer section.
#' @examples
#' 
#' # read in the demo data
#' data(demo_data)
#' 
#' # look at the structure
#' str(appTabs)
#' 
NULL

#' -----------------------------------------------------------
#' @name apps
#' @title Sample data for the shinymgr.sqlite table, "apps"
#' @description Sample data imported to the shinymgr SQLite database
#'  by the function \code{\link{shiny_db_populate}}.
#' @docType data
#' @usage data(demo_data)
#' @format  A data frame with 3 observations on the following 10 variables.
#' @field pkAppName Name of the app; primary key.
#' @field appDisplayName Name that is displayed on app.
#' @field appDescription A description of the app.
#' @field appVideoURL A link to a video if desired.
#' @field appCSS The css file to style the app.
#' @field appNotes Developer notes about the app.
#' @field appActive Logical. Is the app active?
#' @field fkParentAppName References previous version of app.
#' @field appCitation The official citation of the app.
#' @family data
#' @details New records to the "apps" table are added to the shinymgr.sqlite 
#' database 
#' via the "App Builder" interface within shinymgr's Developer section.
#' @examples
#' 
#' # read in the demo data
#' data(demo_data)
#' 
#' # look at the structure
#' str(apps)
#' 
NULL

#' -----------------------------------------------------------
#' @name modFunctionArguments
#' @title Sample data for the shinymgr.sqlite table, "modFunctionArguments"
#' @description Sample data imported to the shinymgr SQLite database
#'  by the function \code{\link{shiny_db_populate}}.
#' @docType data
#' @usage data(demo_data)
#' @format  A data frame with 6 observations on the following 5 variables.
#' @field pkModArgID  Auto-number primary key.
#' @field fkModuleName References pkModuleName in the "modules" table.
#' @field functionArgName Name of the argument.
#' @field functionArgClass Class of the argument (e.g., data.frame)
#' @field description Description of the argument.
#' @family data
#' @details New records to "modFunctionArguments" table are added to the 
#' shinymgr.sqlite database via the  \code{\link{mod_register}} function.
#' @examples
#' 
#' # read in the demo data
#' data(demo_data)
#' 
#' # look at the structure
#' str(modFunctionArguments)
#' 
NULL

#' -----------------------------------------------------------
#' @name modFunctionReturns
#' @title Sample data for the shinymgr.sqlite table, "modFunctionReturns"
#' @description Sample data imported to the shinymgr SQLite database
#'  by the function \code{\link{shiny_db_populate}}.
#' @docType data
#' @usage data(demo_data)
#' @format  A data frame with 6 observations on the following 5 variables.
#' @field pkModReturnID  References pkModuleName in the "modules" table.
#' @field fkModuleName References pkModuleName in the "modules" table.
#' @field functionReturnName Name of the return.
#' @field functionReturnClass Class of the return (e.g., data.frame)
#' @field description Description of the return.
#' @details New records to "modFunctionReturns" table are added to the 
#' shinymgr.sqlite database via the  \code{\link{mod_register}} function.
#' @family data
#' @examples
#' 
#' # read in the demo data
#' data(demo_data)
#' 
#' # look at the structure
#' str(modFunctionReturns)
#' 
NULL

#' -----------------------------------------------------------
#' @name modPackages
#' @title Sample data for the shinymgr.sqlite table, "modPackages"
#' @description Sample data imported to the shinymgr SQLite database
#'  by the function \code{\link{shiny_db_populate}}.
#' @docType data
#' @usage data(demo_data)
#' @format  A data frame with 2 observations on the following 4 variables.
#' @field fkModuleName  References pkModuleName in the "modules" table.
#' @field packageName Name of the R package
#' @field version Version of the package.
#' @field notes Notes about the package.
#' @details New records to "modPackages" table are added to the 
#' shinymgr.sqlite database via the  \code{\link{mod_register}} function.
#' @family data
#' @examples
#' 
#' # read in the demo data
#' data(demo_data)
#' 
#' # look at the structure
#' str(modPackages)
#' 
NULL

#' -----------------------------------------------------------
#' @name modules
#' @title Sample data for the shinymgr.sqlite table, "modules"
#' @description Sample data imported to the shinymgr SQLite database
#'  by the function \code{\link{shiny_db_populate}}.
#' @docType data
#' @usage data(demo_data)
#' @format  A data frame with 8 observations on the following 7 variables.
#' @field pkModuleName Name of a module; primary key.
#' @field modDisplayName Name displayed on the module.
#' @field modDescription Description of the module.
#' @field modCitation Citation of the module.
#' @field modNotes Notes on the module.
#' @field modActive Logical. Is the module still active?
#' @field dateCreated Date the module was created.
#' @details New records to "modules" table are added to the 
#' shinymgr.sqlite database via the  \code{\link{mod_register}} function.
#' @family data
#' @examples
#' 
#' # read in the demo data
#' data(demo_data)
#' 
#' # look at the structure
#' str(modules)
#' 
NULL

#' -----------------------------------------------------------
#' @name reports
#' @title Sample data for the shinymgr.sqlite table, "reports"
#' @description Sample data imported to the shinymgr SQLite database
#'  by the function \code{\link{shiny_db_populate}}.
#' @docType data
#' @usage data(demo_data)
#' @format  A data frame with 3 observations on the following 3 variables.
#' @field pkReportName Name of the report; primary key.
#' @field displayName Display name of the report.
#' @field reportDescription Description of the report.
#' @family data
#' @details Reports are added to the shinymgr.sqlite database via the "Add
#' "Reports" menu in shinymgr's Developer section.
#' @examples
#' 
#' # read in the demo data
#' data(demo_data)
#' 
#' # look at the structure
#' str(reports)
#' 
NULL

#' -----------------------------------------------------------
#' @name tabModules
#' @title Sample data for the shinymgr.sqlite table, "tabModules"
#' @description Sample data imported to the shinymgr SQLite database
#'  by the function \code{\link{shiny_db_populate}}.
#' @docType data
#' @usage data(demo_data)
#' @format  A data frame with 10 observations on the following 4 variables.
#' @field pkInstanceID Auto-number primary key.
#' @field fkTabName References pkTabID from the "tabs" table.
#' @field fkModuleName References pkModuleID from the "module" table.
#' @field modOrder Integer. Gives the order in which a module appears in a tab.
#' @family data
#' @details New records to the "tabModules" table are added to the 
#' shinymgr.sqlite database 
#' via the "App Builder" interface within shinymgr's Developer section.
#' @examples
#' 
#' # read in the demo data
#' data(demo_data)
#' 
#' # look at the structure
#' str(tabModules)
#' 
NULL

#' -----------------------------------------------------------
#' @name tabs
#' @title Sample data for the shinymgr.sqlite table, "tabs"
#' @description Sample data imported to the shinymgr SQLite database
#'  by the function \code{\link{shiny_db_populate}}.
#' @docType data
#' @usage data(demo_data)
#' @format  A data frame with 10 observations on the following 4 variables.
#' @field pkTabName The name of the tab; primary key.
#' @field tabDisplayName The name displayed on the tab.
#' @field tabInstructions Instructions for the tab.
#' @field tabNotes Notes on the tab.
#' @details New records to the "tabs" table are added to the shinymgr.sqlite 
#' database 
#' via the "App Builder" interface within shinymgr's Developer section.
#' @family data
#' @examples
#' 
#' # read in the demo data
#' data(demo_data)
#' 
#' # look at the structure
#' str(tabs)
#' 
NULL
