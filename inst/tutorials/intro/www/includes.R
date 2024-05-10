# load required packages
library(learnr)
library(shinymgr)
library(dplyr)
library(knitcitations)


# https://www.w3schools.com/charsets/ref_emoji_skin_tones.asp
# https://unicode.org/emoji/charts/full-emoji-list.html
# https://www.w3schools.com/charsets/ref_emoji_smileys.asp

# set knitr options
knitr::opts_chunk$set(
  echo = TRUE, 
  class.source = "bg-success", 
  error = TRUE, 
  comment = '##')

# display.brewer.all(colorblindFriendly = TRUE)
palette <- "YlOrRd"
