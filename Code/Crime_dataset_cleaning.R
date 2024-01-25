#220126_PujendraThapa

library(tidyverse)
library(dplyr)
library(lubridate)

# Define the path to the main directory containing all the year-month folders
main_dir <- "C:/Users/lucif/Desktop/220126_Pujendra_Thapa/Obtained Data/Crime Dataset"

# Create a list of all CSV file paths
file_paths <- list.files(main_dir, pattern = "\\.csv$", full.names = TRUE, recursive = TRUE)

# Read and combine all CSV files into one dataframe
combined_crime_dataset <- file_paths %>%
  set_names() %>% # Ensure each element in file_paths is named
  map_df(~read_csv(.x)) %>%   # Apply read_csv to each file path
  as_tibble() # Converting into tibble

# Importing cleaned postcode to LSOA csv into R
cleaned_postcode_to_LSOA <- read_csv("C:/Users/lucif/Desktop/220126_Pujendra_Thapa/Cleaned Data/Cleaned Postcode To LSOA Code.csv")

# Cleaning the combined crime dataset
combined_crime_dataset <- combined_crime_dataset %>%
  select(Month, `Falls within`, `Crime type`, `LSOA code`) %>%
  rename(`Date of crime` = Month, `LSOA Code` = `LSOA code`) %>%
  right_join(cleaned_postcode_to_LSOA, by = c(`LSOA Code` = "LSOA Code")) %>%
  select(`Date of crime`, `Falls within`, `Crime type`, `LSOA Code`, Postcode, `Short Postcode`, `Town/City`) %>%
  na.omit() %>%
  mutate(S_No = row_number()) %>%
  select(S_No, everything())

# Defining path to save the cleaned dataset
file_path <- "C:/Users/lucif/Desktop/220126_Pujendra_Thapa/Cleaned Data/Cleaned Crime Dataset.csv"

# Saving the cleaned dataset
write.csv(combined_crime_dataset, file_path, row.names = FALSE)

