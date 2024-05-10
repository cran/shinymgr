library(shiny)
source("irisCluster.R")

UI <- fluidPage(
  
  # add a level 1 header
  h1("Master App"),
            
  # call irisClusterUI; set the namespace to hello
  irisClusterUI(id = "hello")
  
) # end of fluidPage

# create the R server function
SF <- function(input, output, session, ...){
  
  # add output from the module that has hello as its namespace
  irisClusterServer("hello")
  
} # end of server function


# Run the application 
shinyApp(ui = UI, server = SF)
