# load required packages
library(learnr)
library(shinymgr)
library(RSQLite)
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

# get the database path
db_path <- paste0(tempdir(), "/datatabase/shinymgr.sqlite")


