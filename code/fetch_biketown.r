# functions to fetch public biketown trip data
# see: https:// www.biketownpdx.com/system-data
# subfolder: https://s3.amazonaws.com/biketown-tripdata-public/

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
# but don't run pacman *and* these lines at the same time
# pkgs <- c("lubridate", "dplyr", "string", "readr")
# install.packages("pkgs")

# takes start and end mm/yyyy format and tries to 
# download files fr biketownpdx.com
get_data <- function(start="7/2016", end=NULL,
                     base_url="https://s3.amazonaws.com/biketown-tripdata-public/",
                     outdir="data/biketown/") {
  
  #if no end date given, set to now
  end <- ifelse(is.null(end), format(now(), "%m/%Y"), end)
  
  
  # make url function only available within get_data bc of base_url reference
  make_url <- function(date, base_url) {
    url <-paste0(base_url, format(date, "%Y_%m"), ".csv")
    return(url)
  }
  
  # parse date range
  start_date <- myd(start, truncated = 2)
  end_date <- myd(end, truncated = 2)
  date_range <- seq(start_date, end_date, by="months")
  
  # lapply(a,b) applies function b to sequence a
  # and returns a list of the modified sequence
  # urls <- lapply(date_range, make_url, base_url = base_url)
  
  # 3 ways to write the files
  
  # 1) for loops can be easier for early development of code
  # for (u in urls)
  #   download.file(u, destfile = paste0(outdir, 
  #                                      str_sub(u, -11)))
  
  # 2) replace for-loop with lapply, use an inline function
  # result <- lapply(urls, function(u) {
  #   download.file(u, destfile = paste0(outdir, 
  #    str_sub(u, -11)))
  # })
  
  # 3) as one tidy piked version that combines generating 
  # the url with downloading it
  urls <-  lapply(date_range, make_url, base_url = base_url) %>%
     lapply(function(u) {
      download.file(u, destfile = paste0(outdir, 
                                         str_sub(u, -11)))
     })
  
  
  
  
}
## manual run ##

## params
start <- "6/2018"
end <- "12/2018"

get_data(start, end)


  