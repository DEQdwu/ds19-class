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
  select(country, population = pop, lifeExp, gdp = gdpPercap)
str(subset_3)

# using filter()
africa <- gapminder %>%
  filter(continent == "Africa") %>%
  select(country, population = pop, lifeExp)
  
table(africa$country)
