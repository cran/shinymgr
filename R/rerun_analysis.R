#' @name rerun_analysis
#' @aliases rerun_analysis
#' @title Re-run an previously executed shinymgr analysis 
#' @description Re-run an previously executed shinymgr analysis given an RDS file
#' input from a previously saved analysis.
#' @param analysis_path File path to the RDS file that stores a previously
#' executed analysis. 
#' @usage rerun_analysis(analysis_path)
#' @return No return value, function launches shiny app
#' @importFrom shinyjs disable
#' @importFrom shinyjs enable
#' @importFrom shinyjs disabled
#' @importFrom shinyjs hide
#' @importFrom shinyjs useShinyjs
#' @importFrom shinyjs extendShinyjs
#' @importFrom shinyjs inlineCSS
#' @importFrom shinyjs delay
#' @importFrom shinyjs js
#' @importFrom shiny fluidPage
#' @importFrom shiny tabsetPanel
#' @importFrom shiny tabPanel
#' @importFrom shiny tags
#' @importFrom shiny wellPanel
#' @importFrom shiny verbatimTextOutput
#' @importFrom shiny renderText
#' @importFrom shiny shinyApp
#' @importFrom reactable renderReactable
#' @importFrom reactable reactableOutput
#' @importFrom reactable reactable
#' @importFrom utils capture.output
#' @importFrom utils str
#' @family analysis
#' @references \url{https://code.usgs.gov/vtcfwru/shinymgr}
#' @details The function accepts a single argument that defines the file path to 
#' a saved shinymgr analysis (RDS file). This function will launch a shiny app, 
#' so can only be run during an interactive R session, in an R session with no other 
#' shiny apps running. 
#' 
#' The app that is launched contains 2 tabs. The first tab is called "The App" and 
#' will be visible when the re-run function is called. It contains a header with 
#' the app's name and a subheading of "Analysis Rerun". Below that, a disclaimer 
#' appears, indicating the app was produced from a saved analysis. You may need 
#' to scroll down using the vertical scroll bar in the rendering betlow to see that 
#' below this disclaimer is a fully functioning, identical copy of the shiny app 
#' used to generate the saved analysis.
#' 
#' The second tab, called "Analysis Summary", simply displays the structure of the 
#' saved analysis, excluding any saved source code. The structure of the analysis 
#' gives a high-level summary, including the values that can be entered in the app 
#' to reproduce results.
#' 
#' @section More Info:
#' The rerun_analysis() function is described in the "analyses" tutorial.
#' 
#' @section Tutorials:
#' The shinymgr learnr tutorials include, in order:
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
#' 
#' @export
#' @examples 
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#'
#'   # -----------------------------------------------------------------
#'   # Load the sample analysis from the shinymgr package and re-run it. 
#'   # -----------------------------------------------------------------
#'

#'   # Get the path for the sample analysis from shinymgr
#'   analysis_path <- paste0(
#'     find.package('shinymgr'), 
#'     '/shinymgr/analyses/iris_explorer_Gandalf_2023_06_05_16_30.RDS'
#'   )
#' 
#'   # Re-run the sample analysis
#'   rerun_analysis(analysis_path)
#'   
#' }


rerun_analysis <- function(analysis_path) {

metadata <- readRDS(analysis_path)

source(
  paste0(find.package('shinymgr'), '/shinymgr/modules_mgr/save_analysis.R')
)

# Source in any module package dependencies
modPackages <- sapply(
  metadata$metadata[grep('mod*', names(metadata$metadata))], 
  function(x) {x['modPackages'][[1]]}
)

mod_meta <- sapply(
  metadata$metadata[grep('mod*', names(metadata$metadata))], 
  function(x) {x[c('modName', 'modPackages')]}
)
mod_code <- metadata[paste(mod_meta['modName',], 'code', sep = '_')]

for (i in 1:ncol(mod_meta)) {
  # Read in the module functions
  eval(parse(text = mod_code[i],))
  
  # Load any package dependencies
  mod_packages <- mod_meta['modPackages',i][[1]]
  if (is.data.frame(mod_packages)) {
    for (j in 1:nrow(mod_packages)) {
      library(mod_packages$name[j], character.only = TRUE)
    }
  }
}

# Load the main app's UI and server functions
eval(parse(text = metadata$app_code))

# "Rerun" app UI
ui <- fluidPage(
  tabsetPanel(
    tabPanel(
      "The App", 
      tags$h1(metadata$app),
      tags$h2('Analysis Rerun'),
      wellPanel(
        tags$p(paste0(
          'This app is generated from a shinymgr analysis performed by ',
          metadata$username, ' on ',
          format(metadata$timestamp, ' %Y-%m-%d'), '. ', 
          'A technical summary of this analysis can be viewed on the next tab.'
        ))
      ),
      wellPanel(
        # Evaluate app UI code
        eval(parse(text = paste(metadata$app, '_ui("local_app")', sep = "")))
      )
    ),
    tabPanel(
      "Analysis Summary", 
      verbatimTextOutput("analysis_sum")
    )
  )
)

# "Rerun" app server
server <- function(input, output){
  # Evaluate app server code
  eval(parse(text = paste(metadata$app, '_server("local_app")', sep = "")))
  
  # Display the structure of the saved analysis (sans source code)
  output$analysis_sum <- renderText({
    paste(
      utils::capture.output(
        utils::str(
          metadata[!grepl('_code', names(metadata)) & !grepl('Code', names(metadata))]
        )
      ),
      collapse = '\n'
    )
  })
}

shinyApp(ui = ui, server = server)

}
