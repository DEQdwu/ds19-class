# functions to fetch public biketown trip data
# see: https:// www.biketownpdx.com/system-data
# subfolder: https://s3.amazonaws.com/biketown-tripdata-public/index.html

# pacman allows checking for and installing missing packages 
# by checking if pacman is installed yet and if not, installing it
if(!require("pacman")) {install.packages("pacman")}
  library(pacman)
# use pload to install 4 packages
pacman::p_load("lubridate")
pacman::p_load("dplyr")
pacman::p_load("stringr")
pacman::p_load("readr")

# another way to install multiple packages at once
pkgs <- c("lubridate", "dplyr", "string", "readr")
install.packages("pkgs")

# takes start and end mm/yyyy format and tries to 
# download files fr biketownpdx.com
get_data <- function(start, end,
                     base_url="https://s3.amazonaws.com/biketown-tripdata-public/",
                     outdir="data/biketown/") {
  # make url function only available within get_data bc of base_url reference
  make_url <- function(date, base_url) {
    url <-paste0(base_url, format(date, "%Y_%m"), ".csv")
    return(url)
  }
  
  # parse date range
  start_date <- myd(start, truncated = 2)
  end_date <- myd(end, truncated = 2)
  date_range <- seq(start_date, end_date, by="months")
  
  # lapply(a,b) applies function bo to sequence a
  # and returns a list of the modified sequence
  urls <- lapply(date_range, make_url, base_url = base_url)
  
  # for loops can be easier for early development of code
  for (u in urls)
    download.file(u, destfile = paste0(outdir, 
                                       str_sub(u, -11)))
}
## manual run ##
## params
start <- "06/2018"
end <- "08/2018"

get_data(start, end)
  