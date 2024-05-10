#' @name launch_shinymgr
#' @title Launch the master app for shinymgr
#' @aliases launch_shinymgr
#' @description Launches the master app for shinymgr
#' @param shinyMgrPath Filepath to the main shinymgr folder.
#' @param ... Additional arguments to be passed to the app.
#' @usage launch_shinymgr(shinyMgrPath, ...)
#' @return No return value, function launches shiny app
#' @keywords misc
#' @section More Info:
#' The launch_shinymgr() function is described in the "shinymgr" tutorial.
#' @inheritSection rerun_analysis Tutorials
#' @inherit rerun_analysis references
#' @export
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#'   
#'   # set the directory path that will house the shinymgr project
#'   parentPath <- tempdir()
#'   shinyMgrPath <- paste0(parentPath, '/shinymgr')
#'
#'   # set up raw directories and fresh database
#'   shinymgr_setup(parentPath, demo = TRUE)
#'   
#'   # The shiny app
#'   launch_shinymgr(shinyMgrPath)
#'
#'   # Accepts args to shiny::runApp
#'   launch_shinymgr(shinyMgrPath, quiet = TRUE)
#'   
#'   # remove demo
#'   unlink(shinyMgrPath, recursive = TRUE)
#' 
#' }
#'
launch_shinymgr <- function(shinyMgrPath, ...) {
  # browser()
  if (dir.exists(shinyMgrPath) == FALSE) stop("Could not find shinymgr path.")
  shinyMgrPath <<- shinyMgrPath
  shiny::runApp(shinyMgrPath, ...)
}
