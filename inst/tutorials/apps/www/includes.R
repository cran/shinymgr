# load required packages
library(shinymgr)
library(learnr)
library(ggplot2)

# https://www.w3schools.com/charsets/ref_emoji_skin_tones.asp
# https://unicode.org/emoji/charts/full-emoji-list.html
# https://www.w3schools.com/charsets/ref_emoji_smileys.asp

# set knitr options
knitr::opts_chunk$set(echo = TRUE, class.source = "bg-success", error = TRUE, comment = '##')

# display.brewer.all(colorblindFriendly = TRUE)
palette <- "YlOrRd"

# get the database path
db_path <- paste0(tempdir(), "/shinymgr/database/shinymgr.sqlite")


# source the iris_cluster module
fp <- system.file("shinymgr/modules/iris_cluster.R",
                  package = "shinymgr")
source(fp)

# source the subset_rows modules
fp <- system.file("shinymgr/modules/subset_rows.R",
                  package = "shinymgr")
source(fp)

fp <- system.file("shinymgr/modules/iris_intro.R",
                        package = "shinymgr")

source(fp)

fp <- system.file("shinymgr/modules_app/iris_explorer.R",
                  package = "shinymgr")
source(fp)

# source in module
fp <- system.file("shinymgr/modules/single_column_plot.R",
                  package = "shinymgr")
source(fp)

# source in module
fp <- system.file("shinymgr/modules_mgr/save_analysis.R",
                  package = "shinymgr")
source(fp)

# set the directory path that will house the shinymgr project
parentPath <- tempdir()

# set up raw directories and fresh database
shinymgr_setup(
  parentPath = parentPath, 
  demo = TRUE
)
