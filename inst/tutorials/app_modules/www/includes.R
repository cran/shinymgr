# load required packages
library(learnr)
library(shinymgr)
library(shiny)
library(reactable)


# set knitr options
knitr::opts_chunk$set(echo = TRUE, class.source = "bg-success", error = TRUE, comment = '##')

# display.brewer.all(colorblindFriendly = TRUE)
palette <- "YlOrRd"


# source the iris_cluster module
fp <- system.file("shinymgr/modules/iris_cluster.R",
                  package = "shinymgr")
source(fp)

# source the subset_rows modules
fp <- system.file("shinymgr/modules/subset_rows.R",
                  package = "shinymgr")
source(fp)

