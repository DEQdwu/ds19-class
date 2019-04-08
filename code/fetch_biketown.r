#  functions to fetch public biketown trip data
# see: https:// www.biketownpdx.com/system-data
# https://s3.amazonaws.com/biketown-tripdata-public/index.html

# pacman allows checking for and installing missing packages 
# by checking if pacman is installed yet and if not, installing it
if(!require("pacman")) {install.packages("pacman")}
  library(pacman)

pacman::p_load("lubridate")
pacman::p_load("dplyr")
pacman::p_load("stringr")
pacman::p_load("readr")
