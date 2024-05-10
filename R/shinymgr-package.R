#' @name shinymgr
#' @aliases shinymgr
#' @title A unifying framework for managing and deploying module-based Shiny 
#' applications for reproducible analyses and rapid reporting
#' @description 'shinymgr' provides a unifying framework for managing and 
#' deploying Shiny applications that consist of modules.  From the user's 
#' perspective, an "app” consists of a series of RShiny tabs that are presented 
#' in order, establishing an analysis workflow; results are saved as an RDS 
#' file that fully reproduces the analytic steps and can  be ingested into an 
#' RMarkdown report for rapid reporting. Modules are the basic element in the
#' 'shinymgr' framework; they can be used and re-used across different apps.  
#' New "apps" can be created with the 'shinymgr' app builder that "stitches" shiny 
#' modules together so that outputs from one module serve as inputs to the next, 
#' creating an analysis pipeline that is easy to implement and maintain. In short, 
#' developers use the 'shinymgr' framework to write modules and seamlessly combine 
#' them into shiny apps, and users of these apps can execute reproducible analyses 
#' that can be incorporated into reports for rapid dissemination.
#' @details
#' The 'shinymgr' learnr tutorials include, in order:
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
#' @author Laurence Clarfeld, Caroline Tang, and Therese Donovan
#' @references \url{https://code.usgs.gov/vtcfwru/shinymgr}
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#' # load shinymgr
#' library(shinymgr)
#' 
#' # set the directory path that will house the shinymgr project
#' parentPath <- tempdir()
#' shinyMgrPath <- paste0(parentPath, '/shinymgr')
#'
#' # set up raw directories and fresh database
#' shinymgr_setup(parentPath, demo = TRUE)
#' 
#' # look the file structure 
#' list.files(
#'   path = shinyMgrPath,
#'   recursive = FALSE
#' )
#' 
#' # launch the demo project
#' launch_shinymgr(shinyMgrPath = shinyMgrPath)
#' 
#' # remove demo
#' unlink(shinyMgrPath, recursive = TRUE)
#' 
#' }
"_PACKAGE"
