#' @name mod_init
#' @aliases mod_init
#' @title Creates an R script that contains a framework for developing a new 
#' module
#' @description Creates an R script that contains a framework for developing a 
#' new module
#' @param modName The name of the module to be added to the modules table of
#'  the shinymgr.sqlite database. The function will write an R script as 
#'  modName.R
#' @param author A string with the author's name, formatted as "Lastname, 
#' Firstname".
#' @param shinyMgrPath The path to the shinymgr project. Typically the 
#' working directory.
#' @usage mod_init(modName, author, shinyMgrPath)
#' @section More Info:
#' The mod_init() function is described in the "shinymgr_modules" tutorial.
#' @inheritSection rerun_analysis Tutorials
#' @inherit rerun_analysis references
#' @return  Invisible. The function will write an R script with the name 
#' modName.R and store the file in the shinymgr project's modules folder.
#' @family module
#' @export
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#'
#' # set the file path to the main shinymgr directory
#' parentPath <- tempdir()
#' shinyMgrPath <- paste0(parentPath, '/shinymgr')
#' 
#' shinymgr_setup(parentPath = parentPath, demo = FALSE)
#' 
#' mod_init(
#'   modName = "my_test_mod", 
#'   author = "Baggins, Bilbo", 
#'   shinyMgrPath = shinyMgrPath
#' )
#'
#' # the file should be located in the shinymgr/modules directory
#' fp <- paste0(shinyMgrPath, "/modules/my_test_mod.R")
#'
#' # determine if the file exists
#' file.exists(fp)
#'
#' # show the file info
#' file.info(fp)
#'
#' # show the file
#' file.show(fp)
#' 
#' # remove demo
#' unlink(shinyMgrPath, recursive = TRUE)
#' 
#' }
#'
mod_init <- function(modName, author, shinyMgrPath) {

  # check if the module exists in the database.
  mrs <- qry_row(
    tableName = "modules",
    rowConditions = list(pkModuleName = modName),
    colConditions = c("pkMOduleName"),
    shinyMgrPath = shinyMgrPath
  )

  if (nrow(mrs) > 0) {
    stop(
      paste0(
        "The modName is present in the shinymgr modules table.", "\n",
        "Please choose a new name or delete the existing one from the database."
      )
    )
  }

  # establish the file name and filepath
  fn <- paste0(modName, ".R")
  fp <- paste0(shinyMgrPath, "/modules/", fn)

  # create key-value lines
  headerLines <- c(
    paste0("#!! ModName = ", modName),
    "#!! ModDisplayName = Enter your module shiny display name here.",
    "#!! ModDescription = Enter your module description here.",
    paste0(
      "#!! ModCitation = ", author, ".  (",
      substr(Sys.Date(), 1, 4), "). ", modName, ". [Source code]."
    ),
    "#!! ModNotes = Enter your module notes here.",
    "#!! ModActive = 1/0",
    "#!! FunctionArg = argName1 !! argDescription !! argClass",
    "#!! FunctionArg = argName2 !! argDescription !! argClass",
    "#!! FunctionReturn = returnName1 !! returnDescription !! returnClass",
    "#!! FunctionReturn = returnName2 !! returnDescription !! returnClass",
    "",
    "",
    "# the ui function",
    paste0(modName, "_ui <- function(id) {"),
    "  ns <- NS(id)",
    "  tagList(",
    "  ",
    "  )",
    "}",
    "",
    "",
    "# the server function",
    paste0(modName, "_server <- function(id, argName1, argName2) {"),
    "  moduleServer(id, function(input, output, session) {",
    "    ns <- session$ns",
    "    ",
    "    return(",
    "      reactiveValues(",
    "        returnName1 = reactive(returnName1()),",
    "        returnName2 = reactive(returnName2())",
    "      )",
    "    )",
    "  })",
    "}"
  )

  # write the file to the modules folder
  writeLines(
    text = headerLines,
    con = fp,
    sep = "\n"
  )

  # return
  return(invisible())
}
