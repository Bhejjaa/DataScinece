#220126_Pujendra

library(tidyverse)
library(dplyr)
library(lubridate)
library(stringr)

# Importing cleaned postcode to LSOA csv into R
cleaned_postcode_to_LSOA <- read_csv("C:/Users/lucif/Desktop/220126_Pujendra_Thapa/Cleaned Data/Cleaned Postcode to LSOA.csv")

# Importing population dataset and managing the postcode column
population <- read_csv("C:/Users/lucif/Desktop/220126_Pujendra_Thapa/Obtained Data/Population Dataset.csv") %>%
  rename(`Short Postcode` = Postcode) %>% # Renaming postcode to short postcode
  mutate(`Short Postcode` = gsub(" ", "", `Short Postcode`),  # Remove all spaces
         `Short Postcode` = if_else(nchar(`Short Postcode`) == 5, 
                                    paste0(substr(`Short Postcode`, 1, 4), " ", substr(`Short Postcode`, 5, 6)), 
                                    paste0(substr(`Short Postcode`, 1, 3), " ", substr(`Short Postcode`, 4, 5)))) %>% # Fixing inconsistent spacing in postcode column
  as_tibble() %>% # Converting into tibble
  right_join(cleaned_postcode_to_LSOA, by = "Short Postcode") %>%  # Joining with the cleaned Postcode to LSOA dataset by matching Postcode
  na.omit() %>%  # Removing null values
  select(S_No, everything()) # Moving the serial number column at first

# Defining path to save the cleaned dataset
file_path <- "C:/Users/lucif/Desktop/220126_Pujendra_Thapa/Cleaned Data/Cleaned Population.csv"

# Saving the cleaned dataset
write.csv(population, file_path, row.names = FALSE) 
