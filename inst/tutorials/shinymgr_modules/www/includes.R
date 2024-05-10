
# load required shiny framework packages
# these should come with package so may not be needed
library(shinymgr)
library(learnr)
library(DBI)

# set knitr options
knitr::opts_chunk$set(echo = TRUE, class.source = "bg-success", error = TRUE, comment = '##')

# display.brewer.all(colorblindFriendly = TRUE)
palette <- "YlOrRd"

# set up raw directories and fresh database
shinymgr_setup(
  parentPath = tempdir(), 
  demo = TRUE
)

db_path <- paste0(tempdir(), "/shinymgr/database/shinymgr.sqlite")
