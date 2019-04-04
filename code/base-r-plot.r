# base r - plotting biketown data

install.packages("tidyverse")
library(tidyverse)
library(lubridate)


# import this dataset
biketown <- read.csv("data/biketown-2018-trips.csv")
str(biketown)
summary(biketown)

# adds a column w the hour and month of the starttime (in tidyverse)
biketown$hour <-
  hms(biketown$StartTime) %>%
  hour()

biketown$month <-
  mdy(biketown$StartDate) %>%
  month (label = T, abbr = T)

#adds the same in base
stime <- hms(biketown$StartTime)
biketown$hour <- hour(stime)

# assigns a dataframe freq_by_hour to the table for hour and then plots a histogram
freq_by_hour <- table(biketown$hour)

barplot(freq_by_hour)

# histogram, investigate by 3-h bins
hist(biketown$hour, breaks = seq(0, 24, 3))

# focus on AM peak
am_peak <- subset(biketown, hour >= 7 & hour < 10)
hist(am_peak$hour, breaks = seq(7, 10, 1))
barplot(table(am_peak$hour))

# month
freq_by_month <- table(biketown$month)
barplot(freq_by_month)

# import this dataset and plot gdppercap by lifeexp w points
str(gapminder_data)
summary(gapminder_data)
ggplot(data = gapminder_data, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point()
