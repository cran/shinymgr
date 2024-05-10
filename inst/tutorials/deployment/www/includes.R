
# load required shiny framework packages
# these should come with package so may not be needed
library(shinymgr)
library(learnr)
library(devtools)
library(renv)
library(cachem)
library(fs)

# set knitr options
knitr::opts_chunk$set(echo = TRUE, class.source = "bg-success", error = TRUE, comment = '##')

# display.brewer.all(colorblindFriendly = TRUE)
palette <- "YlOrRd"


# set the directory path that will house the shinymgr project
parentPath <- tempdir()

# set up raw directories and fresh database
shinymgr_setup(
  parentPath = tempdir(), 
  demo = TRUE
)

# add package

if (dir.exists(paste0(tempdir(), "/myPackage")) == TRUE) {
  unlink(paste0(tempdir(), "/myPackage"), recursive = TRUE)
}

f <- function(x, y) x + y
g <- function(x, y) x - y

package.skeleton(
  path = tempdir(), 
  name = "myPackage",
  list = c("f", "g", "cars"),
  force = TRUE
)
