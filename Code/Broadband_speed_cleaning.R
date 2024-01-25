#220126_Pujendra

library(tidyverse)
library(dplyr)
library(lubridate)

# Importing cleaned postcode to LSOA csv into R
cleaned_postcode_to_LSOA <- read_csv("C:/Users/lucif/Desktop/220126_Pujendra_Thapa/Cleaned Data/Cleaned Postcode to LSOA.csv")

# Cleaning and joining data through the use of pipe operator
broadband_speed <- read_csv("C:/Users/lucif/Desktop/220126_Pujendra_Thapa/Obtained Data/Broadband Speed.csv") %>% 
  # Importing broadband speed csv into R
  as_tibble() %>% 
  # Converting into tibble 
  select(`Average download speed (Mbit/s)`, postcode_space) %>%  
  # Selecting only columns that are required 
  rename(Postcode = postcode_space) %>% 
  # Renaming the post_space column to Postcode
  right_join(cleaned_postcode_to_LSOA, by = "Postcode") %>% 
  # Joining with the cleaned house price dataset by matching Postcode
  select(`Average download speed (Mbit/s)`, Postcode, `Short Postcode`, `Town/City`, District, County) %>% 
  # Selecting only required columns
  na.omit() %>%  
  # Removing rows with null value
  mutate(`Short Postcode` = substr(Postcode, 1, 5)) %>% 
  # Filling missing short code values
  mutate(S_No = row_number()) %>% 
  # Adding a new serial number column
  select(S_No, everything()) # Moving the serial number column at first

# Defining path to save the cleaned dataset
file_path <- "C:/Users/lucif/Desktop/220126_Pujendra_Thapa/Cleaned Data/Cleaned Broadband Speed Dataset.csv"

# Saving the cleaned dataset
write.csv(broadband_speed, file_path, row.names = FALSE) 
