#' @name restore_analysis
#' @aliases restore_analysis
#' @title Re-store a previously executed shinymgr analysis by regenerating an R 
#' project from an renv lockfile
#' @description Re-run an previously executed shinymgr analysis given an RDS file
#' input from a previously saved analysis.
#' @param analysis_path File path to the RDS file that stores a previously
#' executed analysis. 
#' @usage restore_analysis(analysis_path)
#' @return No return value, restores an R environment from a saved analysis
#' @importFrom renv init
#' @importFrom renv restore
#' @family analysis
#' @references \url{https://code.usgs.gov/vtcfwru/shinymgr}
#' @details The function accepts a single argument that defines the file path to 
#' a saved shinymgr analysis (RDS file). This function will find the lockfile
#' and use it to create a new renv-enabled R project (a folder), that includes 
#' the full R library used by the developer when creating the app.  The function 
#' creates this new project, copies the original RDS file to it, and copies a 
#' script that the user can run in an attempt to restore an old shinymgr 
#' analysis utilizing the R version and all package versions that the developer 
#' used when creating the app.  
#' 
#' @section More Info:
#' The restore_analysis() function is described in the "analyses" tutorial.
#' 
#' @section Tutorials:
#' The shinymgr learnr tutorials include, in order.
#' \enumerate{
#'   \item {\code{learnr::run_tutorial(name = "intro", package = "shinymgr")}} 
#'   \item {\code{learnr::run_tutorial(name = "shiny", package = "shinymgr")}}
#'   \item {\code{learnr::run_tutorial(name = "modules", package = "shinymgr")}} 
#'   \item {\code{learnr::run_tutorial(name = "app_modules", package = "shinymgr")}}
#'   \item {\code{learnr::run_tutorial(name = "tests", package = "shinymgr")}}
#'   \item {\code{learnr::run_tutorial(name = "shinymgr", package = "shinymgr")}}
#'   \item {\code{learnr::run_tutorial(name = "database", package = "shinymgr")}}
#'   \item {\code{learnr::run_tutorial(name = "shinymgr_modules", package = "shinymgr")}} 
#'   \item {\code{learnr::run_tutorial(name = "apps", package = "shinymgr")}} 
#'   \item {\code{learnr::run_tutorial(name = "analyses", package = "shinymgr")}}
#'   \item {\code{learnr::run_tutorial(name = "reports", package = "shinymgr")}}
#'   \item {\code{learnr::run_tutorial(name = "deployment", package = "shinymgr")}}
#' }
#' @export
#' @examples 
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#'
#' # -----------------------------------------------------------------
#' # Load the sample analysis from the shinymgr package and restore it. 
#' # -----------------------------------------------------------------
#'
#'   # Get the path for the sample analysis from shinymgr
#'   analysis_path <- paste0(
#'     find.package('shinymgr'), 
#'     '/shinymgr/analyses/iris_explorer_Gandalf_2023_06_05_16_30.RDS'
#'   )
#'   
#'   # confirm file exists
#'   file.exists(analysis_path)
#' 
#'   dir_current <- getwd()
#' 
#'   # Re-run the sample analysis
#'   restore_analysis(analysis_path)
#'   
#'   # A new project will created in the temporary directory that
#'   # includes a script to run within the new renv project
#'   # Rerun the saved analysis from the restored environment:
#'   rerun_analysis('renv_iris_explorer_Gandalf_2023_06_05_16_30.RDS')
#'   
#'   # Reset directory and clean-up
#'   setwd(dir_current)
#'   unlink(
#'     file.path(tempdir(), paste0('renv_', basename(analysis_path))), 
#'     recursive = TRUE
#'   )
#' }


restore_analysis <- function(analysis_path) {
  
# read in the RDS
analysis <- readRDS(analysis_path)

# extract the lockfile
lf <- analysis$metadata$lockfile

# remove shinymgr for now ---- need to figure this out!
index <- which(names(lf$Packages) == "shinymgr")
lf$Packages[index] <- NULL    

# set the class
class(lf) <- "renv_lockfile"

# initiate new renv project
renv::init(
  project = paste0(tempdir(), "/renv_", analysis$analysisName),
  bare = TRUE, 
  force = TRUE,
  restart = FALSE
)

# run renv restore
renv::restore(
  project = paste0(tempdir(), "/renv_", analysis$analysisName),
  lockfile = lf, 
  clean = TRUE,
  prompt = FALSE
)

# copy analysis to new project
file.copy(
  from = analysis_path,
  to =  paste0("renv_", analysis$analysisName)
)

# delete lockfile
unlink("renv.lock")

}
