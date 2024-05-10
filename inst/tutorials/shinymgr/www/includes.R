
# load required shiny framework packages
# these should come with package so may not be needed
library(shinymgr)
library(learnr)



# set knitr options
knitr::opts_chunk$set(echo = TRUE, class.source = "bg-success", error = TRUE, comment = '##')

# display.brewer.all(colorblindFriendly = TRUE)
palette <- "YlOrRd"

source(paste0(find.package("shinymgr"), "/shinymgr/modules/iris_cluster.R"))
source(paste0(find.package("shinymgr"), "/shinymgr/modules/subset_rows.R"))

# set the directory path that will house the shinymgr project
parentPath <- tempdir()

# set up raw directories and fresh database
shinymgr_setup(
  parentPath = parentPath, 
  demo = TRUE
)
