# intro to dplyr (dee-plier)
library(dplyr)

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
