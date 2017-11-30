#! /usr/bin/env Rscript
# ishares_metadata_cleaner.R
# Daniel Raff Nov, 2017

# This script reads in data from data/etf_metadata_ishares.csv, and cleans it
# This involves selecting just monthly Net Asset Values for the past 10 years
# and then making those variables workable (getting appropriate NAs and changing types)

# Usage: Rscript src/ishares_metadata_cleaner.R https://github.com/raffrica/etf_correlations/blob/master/data/etf_metadata_ishares.csv results/etf_metadata_ishares_clean.csv


# Import libraries and packages
options(warn=-1)
suppressMessages(library(tidyverse))
suppressMessages(library(purrr))

# Read in Command Line Arguments
args <- commandArgs(trailingOnly = FALSE)
input_file <- as.character(args[1])
output_name <- as.character(args[2])



# main function is to clean dataset

main <- function(){
  # read in data
  ishares <- read_csv("https://raw.githubusercontent.com/raffrica/etf_correlations/master/data/etf_metadata_ishares.csv")
  
  # Due to the nature of the csv, the 1st row (after header) is still a subheader
  # with important information.
  # Looking through this, I've renamed the variables and kept monthly 
  # Net Asset Values (NAV) over a given time frame.
  
  ishares <- ishares %>% 
    rename(nav_monthly_ytd = X23, # NAV of year to date
           nav_monthly_1_year = X24, # past year
           nav_monthly_3_year = X25, # past 3 years
           nav_monthly_5_year = X26, 
           nav_monthly_10_year = X27) %>% 
    select(Ticker, Name, nav_monthly_ytd, nav_monthly_1_year, nav_monthly_3_year,
           nav_monthly_5_year,nav_monthly_10_year)
  
  
  # Now I can remove the first (non-header) row which has NAs
  ishares <- ishares[!is.na(ishares$Ticker),]
  
  
  
  # Converting "-" for missing data into NA for missing Data
  ishares <- ishares %>% 
    mutate(nav_monthly_ytd = as.numeric(replace(nav_monthly_ytd, 
                                                nav_monthly_ytd == "-",
                                                NA))) %>% 
    mutate(nav_monthly_1_year = as.numeric(replace(nav_monthly_1_year, 
                                                   nav_monthly_1_year == "-",
                                                   NA))) %>% 
    mutate(nav_monthly_3_year = as.numeric(replace(nav_monthly_3_year, 
                                                   nav_monthly_3_year == "-",
                                                   NA))) %>% 
    mutate(nav_monthly_5_year = as.numeric(replace(nav_monthly_5_year, 
                                                   nav_monthly_5_year == "-",
                                                   NA))) %>% 
    mutate(nav_monthly_10_year = as.numeric(replace(nav_monthly_10_year, 
                                                    nav_monthly_10_year == "-",
                                                    NA))) %>% 
    select(-Name)
  
  # write the clean data to the output_name argument provided
  write_csv(ishares, path = "results/etf_metadata_ishares_clean.csv")

}

main()
