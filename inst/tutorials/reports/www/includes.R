
# load required shiny framework packages
# these should come with package so may not be needed
library(shinymgr)
library(learnr)



# set knitr options
knitr::opts_chunk$set(echo = TRUE, class.source = "bg-success", error = TRUE, comment = '##')

# display.brewer.all(colorblindFriendly = TRUE)
palette <- "YlOrRd"

# set the directory path that will house the shinymgr project
parent_path <- tempdir()

# set up raw directories and fresh database
shinymgr_setup(
  parentPath = parent_path, 
  demo = TRUE
)

fp <- paste0(find.package("shinymgr"), '/shinymgr/analyses/')
ps <- readRDS(paste0(fp, "iris_explorer_Gandalf_2023_06_05_16_30.RDS"))



rmd_fp <- paste0(find.package("shinymgr"), '/shinymgr/reports/iris_explorer/iris_explorer_report.Rmd')







