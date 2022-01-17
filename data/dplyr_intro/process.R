# Name: Nicolas Bolanos
# Assignment: 5.2 Exercise
# Description: dplyr intro - data exercise
# Date: 01/16/2022
# Instructor: Dr. Bushart

# import data
gapminder <- read.csv("https://raw.githubusercontent.com/resbaz/r-novice-gapminder-files/master/data/gapminder-FiveYearData.csv")
# ctrl + enter: execute from script 

# summarize data 
summary(gapminder)

# load the package
library(dplyr)
?filter

# 1.filter(): pick observations ----
# logical operators
1 == 1 # equality
1 == 2
1 != 3 # unequal
13 < 14 # smaller than 
12 > 12 # bigger than 
12 >= 0 # greater or equal
12 <= 12 # smaller or equal 
# only australia data
australia <- filter(gapminder,country == "Australia")
"this" == "that"
"this" == "this"
# only life expectancy higher than 81
life80 <- filter(gapminder, lifeExp > 81)

# 2. arrange(): reorder rows ----
# highest GDP per capita
arrange(gapminder, gdpPercap)
head(arrange(gapminder, gdpPercap)) # ascending order
head(arrange(gapminder, desc(gdpPercap))) # descending order

# 3. select(): pick variables ----
gap_small <- select(gapminder,
                    year, country, gdpPercap)

# combine operations
gap_small_97 <- filter(gap_small, year == 1997)
# same thing as nesting
gap_small_97 <- filter(select(gapminder, year, country, gdpPercap),
                       year == 1997)
# same thing, but with the pipe operator'%>%'
# pipe '%>%' operator reads as 'then'
gap_small_97 <- gapminder %>% 
  select(year, country, gdpPercap) %>%
  filter(year == 1997)

gapminder %>%
  summary()
#exactly the same as
summary(gapminder)

# challenge: 2002 life expectancy observation for Eritrea
eritrea_2002 <- gapminder %>%
  select(year, country, lifeExp) %>%
  filter(country == "Eritrea", year == 2002)

# 4. mutate(): create new variables ----
# pipe operator: ctrl + shift + M
gap_gdp <- gapminder %>% 
  mutate(gdp = gdpPercap * pop,
         gdpMil = gdp / 10^6)

# 5. summarize(): collapse to a single summary ----
gapminder %>% 
  summarise(meanLE = mean(lifeExp))

# 6. group_by(): change the scope ----
gapminder %>% 
  group_by(continent)


# mean life expectancy for each continent in 2007
gapminder %>% 
  filter(year == 2007) %>% 
  group_by(continent) %>% 
  summarise(meanLE = mean(lifeExp))
 

# challenge: max life expectancy for each country
maxLE <- gapminder %>% 
  group_by(country) %>% 
  summarise(maxLE = max(lifeExp))
maxLE

# challenge: max life expectancy for each country arrange function
maxLE <- gapminder %>% 
  group_by(country) %>% 
  summarise(maxLE = max(lifeExp)) %>% 
  arrange(maxLE)
maxLE

# using or merging starwars data
?starwars
starwars %>% 
  group_by(species) %>% 
  summarise(n = n(),
            mass = mean(mass, na.rm = TRUE)) %>% 
  filter(n > 1)

# associating dplyr with ggplot2
library(ggplot2)
gapminder %>% 
  filter(continent == "Europe") %>% 
  group_by(year) %>% 
  summarise(sum = sum(pop)) %>% 
  ggplot(aes(x = year,
             y = sum)) +
  geom_line()
