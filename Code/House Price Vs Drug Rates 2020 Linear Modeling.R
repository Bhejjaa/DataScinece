#220126_Pujendra

# Load necessary libraries
library(tidyverse)
library(lubridate)
library(ggplot2)

# Importing population dataset
population_dataset <- read_csv("C:/Users/lucif/Desktop/220126_Pujendra_Thapa/Cleaned Data/Cleaned Population.csv")

# Importing the cleaned house prices
cleaned_houseprices <- read_csv("C:/Users/lucif/Desktop/220126_Pujendra_Thapa/Cleaned Data/Cleaned House Prices.csv") 

# Importing the cleaned crime dataset
cleaned_crime_dataset <- read_csv("C:/Users/lucif/Desktop/220126_Pujendra_Thapa/Cleaned Data/Cleaned Crime Dataset.csv") 

# Grouping house prices by town and county and finding the average price for each group
grouped_house_prices <- cleaned_houseprices %>%
  filter(`Date of Transfer` == "2020") %>%
  group_by(`Town/City`, County) %>%
  summarise(Price = mean(Price))

# Modifying the crime dataset to show drug offence rate and crime count  
crime_dataset_drugs2 <- cleaned_crime_dataset %>% 
  mutate(`Date of crime` = substr(`Date of crime`, 1, 4)) %>% 
  group_by(`Short Postcode`, `Crime type`, `Date of crime`, `Falls within`) %>% 
  select(`Short Postcode`, `Crime type`, `Date of crime`, `Falls within`) %>% 
  na.omit() %>% 
  tally() %>% 
  rename(`Crime Count` = n) %>%  
  right_join(population_dataset, by = "Short Postcode") %>% 
  select(`Short Postcode`, `Crime type`, `Crime Count`, `Population`, `Date of crime`, `Falls within`, `Town/City`, District) %>% 
  na.omit() %>% 
  filter(`Crime type` == "Drugs") %>% 
  mutate(`Drug Offence Rate` = (`Crime Count` / Population))

# Grouping the drug crime dataset by county and town and showing the rate for each group for the year 2020
grouped_drug_crime <- crime_dataset_drugs2 %>% 
  filter(`Date of crime` == "2020") %>% 
  group_by(`Falls within`, `Town/City`) %>% 
  summarise(`Drug Offence Rate` = mean(`Drug Offence Rate`))

# Joining house price data and drug crime rate data in a single table
house_price_drug_crime_data <- grouped_house_prices %>% 
  left_join(grouped_drug_crime, by = "Town/City") %>% 
  na.omit() # Removing null values

# Creating a linear model 
l_model <- lm(data = house_price_drug_crime_data, Price ~ `Drug Offence Rate`) 

# Showing summary of the Linear Model
summary(l_model) 

# Creating the linear model graph
ggplot(house_price_drug_crime_data, aes(x = `Drug Offence Rate`, y = Price)) +
  scale_y_continuous(limits = c(0, 1000000), breaks = seq(0, 1000000, 200000)) + 
  geom_point(data = filter(house_price_drug_crime_data, County == "KENT"), aes(color = "Kent")) + 
  geom_point(data = filter(house_price_drug_crime_data, County == "SURREY"), aes(color = "Surrey")) + 
  geom_smooth(method = lm, se = FALSE, color = "lightgreen") + 
  labs(x = "Drug Offence Rate", y = "Price", title = "2020 House Prices vs Drug Offence Rate", color = "County")
