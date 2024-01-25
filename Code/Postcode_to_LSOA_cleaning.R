#220126_Pujendra

library(tidyverse)
library(dplyr)
library(lubridate)

# Importing cleaned house price dataset
cleaned_houseprices <- read_csv("C:/Users/lucif/Desktop/220126_Pujendra_Thapa/Cleaned Data/Cleaned House Prices.csv") 

# Cleaning and joining data using the pipe operator
postcode_to_lsoa <- read_csv("C:/Users/lucif/Desktop/220126_Pujendra_Thapa/Obtained Data/Postcode to LSOA.csv") %>% 
  # Importing Postcode to LSOA csv file
  select(pcd7, lsoa11cd) %>% 
  # Selecting only required columns
  rename(Postcode = pcd7, `LSOA Code` = lsoa11cd) %>% 
  # Renaming columns
  right_join(cleaned_houseprices, by = "Postcode") %>% 
  # Joining with the cleaned house price dataset by matching Postcode
  select(`LSOA Code`, Postcode, `Short Postcode`, `Town/City`, District, County) %>% 
  # Selecting only required columns
  mutate(S_No = row_number()) %>% 
  # Adding a new serial number column
  select(S_No, everything()) # Moving the serial number column at first

# Defining path to save the cleaned dataset
file_path <- "C:/Users/lucif/Desktop/220126_Pujendra_Thapa/Cleaned Data/Cleaned Postcode to LSOA.csv"

# Saving the cleaned dataset
write.csv(postcode_to_lsoa, file_path, row.names = FALSE) 
