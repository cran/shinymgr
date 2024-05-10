#' @name shinymgr_setup
#' @aliases shinymgr_setup
#' @title Sets up a new *shinymanager* directory structure and database
#' @description Create a new *shinymgr* directory structure, database, and 
#' master app.  If demo == TRUE,  the database includes sample data and sample 
#' modules are also provided.
#' @param parentPath  Path to the parent directory that will house the 
#' *shinymgr* file system.  A folder called "shinymgr" will be created under 
#' this parent directory.  If desired, create an RStudio project associated
#'  with the "shinymgr" folder, enabling use of the renv package.
#' @param demo TRUE or FALSE. Should the demo modules and demo database be 
#' included?
#' @usage shinymgr_setup(parentPath, demo = FALSE)
#' @return Returns a file structure, database, and master app called app.R
#' @details shinymgr_setup is the primary function to use when starting your 
#' own  *shinymgr* project.  The function's has two arguments: parentPath 
#' is the path to a folder that will house the *shinymgr* project (a directory 
#' called "shinymgr").  The function will create the main directory,
#' plus 9 sub directories ("analyses", "data", "database", "tests",
#' "modules", "modules_app", modules_mgr","reports",  "www").  Directory 
#' definitions are provided below.  If demo = TRUE, these directories will be 
#' populated with sample modules and a sample database that can be used to 
#' explore the package's functionality.  Once you understand the general 
#' *shinymgr* framework, you can create as many *shinymgr* projects as you 
#' wish by setting demo = FALSE. 
#'
#' The parentPath argument points to a directory that will house the main 
#' *shinymgr* directory,
#' plus  9 subdirectories, along with the main *shinymgr* master app.R 
#' (or server.R and ui.R) shiny scripts.  
#'
#' Directories of *shinymgr* include:
#' 
#' analyses = stores previously run "app" results as RDS file.  
#' data - holds datasets (RData, csv) that are used by "apps".
#' database - holds the shinymgr sqlite database, named "shinymgr.sqlite".
#' modules - holds stand-alone modules that are combined into shinymgr "apps".
#' modules_mgr - holds modules that are used in the shinymgr main app framework.
#' modules_app - stores app modules; i.e., a series of modules that are linked 
#' into a tabbed workflow.
#' reports - holds Rmd files that call in previously run analyses to produce 
#' an Rmarkdown report.
#' tests - holds unit testing of modules to ensure everything works.
#' www - stores all images and css files that are rendered in shiny.
#' @section More Info:
#' The shinymgr_setup() function is described in the "shinymgr" tutorial.
#' @inheritSection rerun_analysis Tutorials
#' @inherit rerun_analysis references
#' @concept shinymgr
#' @concept database
#' @seealso \code{\link{shiny_db_create}}
#' @export
#' @examples 
#'
#' # ------------------------------------------------------------
#' # Set up an shinymgr framework in a parent directory 
#' # ------------------------------------------------------------
#'
#' # set the directory path that will house the shinymgr project
#' parentPath <- tempdir()
#' shinyMgrPath <- paste0(parentPath, '/shinymgr')
#'
#' # set up raw directories and fresh database
#' shinymgr_setup(parentPath, demo = FALSE)
#'
#' # verify that the folder structure exists in your specified directory
#' list.dirs(
#'   path = shinyMgrPath, 
#'   full.names = FALSE, 
#'   recursive = TRUE)
#' 
#' # look at the files 
#' list.files(
#'   path = shinyMgrPath, 
#'   full.names = FALSE, 
#'   recursive = TRUE)
#'   
#' # Remove demo database
#' unlink(shinyMgrPath, recursive = TRUE)
#' 

shinymgr_setup <- function(parentPath, demo = FALSE) {
 
  # create the shinymgr path and directory
  shinyMgrPath <- paste0(parentPath, "/shinymgr")
  dir.create(shinyMgrPath)
  
  # copy the specified package contents to specified directory
  filesToCopy <- dir(paste0(system.file("shinymgr", package = "shinymgr")))
  
  # demo == TRUE
  if (demo == TRUE) {
    
    for (i in 1:length(filesToCopy)) {
      dirPathFrom <- paste0(system.file("shinymgr", package = "shinymgr"), "/", filesToCopy[i])
      file.copy(
        from = dirPathFrom,
        to = shinyMgrPath,
        recursive = TRUE)
    }
  }
  
  # adjust if demo = FALSE
  if (demo == FALSE) {
    
    # copy the specified package contents to specified directory
    emptyFolders <- c("analyses", "data", "database", "modules", "modules_app", "reports", "tests", "tests/testthat", "tests/shinytest")
    filesToCopy <- filesToCopy[!filesToCopy %in% emptyFolders]
    
    for (i in 1:length(filesToCopy)) {
      dirPathFrom <- paste0(system.file("shinymgr", package = "shinymgr"), "/", filesToCopy[i])
      file.copy(
        from = dirPathFrom,
        to = shinyMgrPath,
        recursive = TRUE)
    }
    
    # create folders
    for (j in 1:length(emptyFolders)) {
      dir.create(paste0(shinyMgrPath, "/", emptyFolders[j]))
    }
    
    # create blank database
    shiny_db_create(db_path  = paste0(shinyMgrPath, "/database/shinymgr.sqlite"),  demo = FALSE)
    
  } # end of demo = FALSE
  
  return(invisible())
} # end of function
