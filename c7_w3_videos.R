View(diamonds)
data("diamonds")
head(diamonds)
str(diamonds)
colnames(diamonds)
library(tidyverse)
mutate(diamonds, carat_2 = carat*100)
as_tibble(diamonds)
data(mtcars)
mtcars
read_csv(readr_example("mtcars.csv"))
readr_example()

# ###CLEANING UP WITH THE BASICS###
library("skimr")
library("here")
library("janitor")
library("dplyr")
library("palmerpenguins")
skim_without_charts(penguins)
View(penguins)
glimpse(penguins)
head(penguins)

# using SELECT 
penguins %>% 
  select(-species)

# renaming a column
penguins %>% 
  rename(island_new = island)

# changing all column names to uppercase
rename_with(penguins, toupper)

# changing back to lowercase
rename_with(penguins, tolower)
# Clean names function
clean_names(penguins)

####  ORGANIZE YOUR DATA #####
library(tidyverse)
penguins %>% arrange(-bill_length_mm)
penguins2 <- penguins %>% arrange(-bill_length_mm)
View(penguins2)

# Group by clause
penguins %>% 
  group_by(island) %>% 
  drop_na() %>% 
  summarise(mean_bill_length = mean(bill_length_mm))

# find the maximum bill length
penguins %>% 
  group_by(island) %>% 
  drop_na() %>% 
  summarise(max_bill_length = max(bill_length_mm))

# Group by island and species and them calculate both mean and max
penguins %>% 
  group_by(species, island) %>% 
  drop_na() %>% 
  summarize(max_bl= max(bill_length_mm), mean_bl = mean(bill_length_mm))

# Filter results using filter function
penguins %>% filter(species == 'Adelie')
