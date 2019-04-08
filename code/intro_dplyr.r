# intro to dplyr (dee-plier)
library(dplyr)
library(ggplot2)

install.packages("sp")
install.packages("sf")
install.packages("mapview")
library(sp)
library(sf)
library(mapview)

# load gapminder data s sampel dataset
gapminder <- read.csv("data/gapminder_data.csv",
                      stringsAsFactors = F)

mean(gapminder[gapminder$continent == "Africa", "gdpPercap"])

# can choose what kind of data type to import data as
gapminder$continent <- as.factor(gapminder$continent)
gapminder$continent <- as.character(gapminder$continent)

# This is a pipe: %>% 
# Functions we will learn today from dplyr
# 1. select()
# 2. filter()
# 3. group_by()
# 4. summarize()
# 5. mutate()

# what attributes in gapminder:
str(gapminder)
colnames(gapminder)
subset_1 <- gapminder %>%
  select(country, continent, lifeExp)

# select every attribute except 2
subset_2 <- gapminder %>%
  select(-lifeExp, -pop)

str(subset_2)

# select some attributes but rename some for clarity
subset_3 <- gapminder %>%
  select(country, year, population = pop, lifeExp, gdp = gdpPercap)
str(subset_3)

# using filter()
africa <- gapminder %>%
  filter(continent == "Africa") %>%
  select(country, year, population = pop, lifeExp)
  
table(africa)


# select europe
europe <- gapminder %>%
  filter(continent == "Europe") %>%
  select(country, year, population = pop)
table(europe)

# working with group_by() & summarize()
str(gapminder %>% group_by(continent))

# summarize mean GDP per continent
gdp_continent <- gapminder %>%
  group_by(continent) %>%
  summarize(mean_gdp = mean(gdpPercap))


# plot
library(ggplot2)
summary_plot <- gdp_continent %>%
  ggplot(aes(x = mean_gdp, y = mean_lifeExp)) +
  geom_point(stat = "identity") +
  theme_bw()

# calculate mean population for all the continents
pop_continent <- gapminder %>%
  group_by(continent) %>%
  summarize(mean_pop = mean(pop))

# count() and n()
gapminder %>%
  filter(year == 2002) %>%
  count(continent, sort = TRUE)

gapminder %>%
  group_by(continent) %>%
  summarize(se = sd(lifeExp)/sqrt(n()))

# mutate() 
# creates a column added to the data frame
xy <- data.frame(x = rnorm(100),
                 y = rnorm(100))
head(xy)
xyz <- xy %>%
  mutate(z =  x * y)
head(xyz)

# add column GDP = gdppercap * pop then aggregate continent
gdp_country <- gapminder %>%
  mutate(total_gdp = gdpPercap * pop)
head(gdp_country)

gdp_continent <- gdp_country %>%
  group_by(continent) %>%
  summarize(cont_gdp = sum(total_gdp))
gdp_continent  

# install tidyr
install.packages("tidyr")
library(tidyr)
library(readr)
library(stringr)
str(gapminder)

# pull data
bikenet <- read_csv("ds19-class/data/bikenet-change.csv")
head(bikenet)
summary(bikenet)
summary(factor(bikenet$facility2013))

# gather facility columns into single year variable
colnames(bikenet)
bikenet_long <- bikenet %>%
  gather(key = "year", value = "facility",
         facility2008:facility2013, na.rm = T) %>%
  mutate(year = stringr::str_sub(year, start = -4))

head(bikenet_long)
         
# danger below, fname may have multiple wods
# unite()
bikenet_long <- bikenet_long %>%
  unite(col="street", c("fname", "ftype"), sep = " ")

# separate street and suffix
bikenet_long <- bikenet_long %>%
  separate(street, c("name", "suffix"))

# filter by a particulr bike ID
bikenet_long %>% filter(bikeid == 139730)

fac_lengths <- bikenet_long %>%
  filter(facility %in% c("BKE-LANE", "BKE-BLVD", "BKE-BUFF",
                         "BKE-TRAK", "PTH-REMU")) %>% 
  group_by(year, facility) %>%
  summarise(meters = sum(length_m)) %>%
  mutate(miles = meters/1609)
fac_lengths

p <- ggplot(fac_lengths, aes(x=year, y=miles, 
                             group = facility, 
                             color = facility))
p + geom_line()
p + geom_point()
p + geom_line() + scale_y_log10()
p + geom_line() + labs(title = "Change in bike facilities in Portland",
                       subtitle = "2008-2013",
                       caption = "Source: Portland Metro") +
  ylab("Total Miles") +
  xlab("Year")

p2 <- ggplot(fac_lengths, aes(x = year, y = miles,
                              group = facility))
p2 + geom_line(size = 1, color = "magenta") +
  facet_wrap(~facility) +
  scale_y_log10()


# mapview project
# Playing with mapping

library(dplyr)

# sp must be installed but no need to load

#install.packages("sp")

#install.packages("sf")

library(sf)

#install.packages("mapview")

library(mapview)



biketown <- read.csv("data/biketown-2018-trips.csv",
                     
                     stringsAsFactors = F)

head(biketown)



hubs_start_sf <- biketown %>%
  
  group_by(StartHub) %>%
  
  summarise(lat = mean(StartLatitude), lng = mean(StartLongitude),
            
            starts = n()) %>%
  
  filter(!is.na(lat)) %>%
  
  st_as_sf(coords = c("lng", "lat"), 
           
           crs = 4326, agr = "constant")



mapview(hubs_start_sf, zcol = "starts") # if basemap won't load in RStudio

# click "show in new window" button

#  in viewer pane (just right of sweep)

mapview(hubs_start_sf, cex = "starts", legend = T)

mapview(hubs_start_sf, zcol = "starts", cex = "starts")



hubs_end <- biketown %>%
  
  group_by(EndHub) %>%
  
  summarise(lat = mean(EndLatitude), lng = mean(EndLongitude),
            
            ends = n())

hubs_end_sf <- hubs_end %>%
  filter(!is.na(lat)) %>%
  st_as_sf(coords = c("lng", "lat"), 
           crs = 4326, agr = "constant")

mapview(hubs_end_sf, zcol = "ends", cex = "ends")

hubs_ratio_sf <- inner_join(hubs_start_sf, hubs_end,
                            by = c("StartHub" = "EndHub")) %>%
  mutate(starts_to_ends = starts / ends, ends_to_starts = ends / starts)

summary(hubs_ratio_sf)

mapview(hubs_ratio_sf, zcol = "starts_to_ends", cex = "starts_to_ends")
mapview(hubs_ratio_sf, zcol = "ends_to_starts", cex = "ends_to_starts")

m1 <- mapview(hubs_ratio_sf, zcol = "starts_to_ends", 
              cex = "starts_to_ends", legend = F)

m2 <- mapview(hubs_ratio_sf, zcol = "ends_to_starts", 
              cex = "ends_to_starts", legend = F)


sync(m1, m2)

# playing with PM data
library(ggplot2)
library(lubridate)
library(tidyr)

PM25 <- rawpm25data %>%
  mutate(date_l = mdy(Date), day=day(date_l))



p <- ggplot(PM25, aes(x=Date, y=FinePM, 
                             group = Monitor, 
                             color = MOnitor))
  theme_bw()
  
PM25 <- PM25 %>%
  separate(Date, c("month", "day", "year"), sep = "/") %>%
  unite(month_day, c("month", "day"), sep = "-")
  
test_fig <- PM25 %>%
  ggplot(aes(x = month_day, y = FinePM, color = year)) +
  geom_point() +
  geom_line() +
  facet_grid(Monitor ~ .)

test_fig  
