#! /usr/bin/env Rscript
# ishares_metadata_NAV_selection.R
# Daniel Raff, November 2017

# This script reads in cleaned data from results/etf_metadata_ishares_clean.csv, 
# and creates a dataframe comparing how much NAV data is lost with increasing 
# length of time that the monthly NAV spans (eg: Year to Date vs. 1 Year, vs. 10 years)

# The greater the length of time each NAV spans the better, 5 years will be more 
# accurate than 1 year of the overall NAV (think of this as return) of the ETF. 
# There are more missing values with a greater time span as well. 
# This script produces a table comparing the amount of data lost (missing values)

# Usage: Rscript src/ishares_metadata_NAV_selection.R results/etf_metadata_ishares_clean.csv results/ishares_nav_values_not_missing.csv

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(forcats))


# Read in Command Line Arguments
args <- commandArgs(trailingOnly = TRUE)
input_file <- as.character(args[1])
output_file <- as.character(args[2])

main <- function(){
  
  ishares <- read_csv(input_file)
  
  names(ishares)
  
  ishares_nav_values_not_missing <- tibble(time_elapse = c("total", "year_to_date",
  "1_year", "3_years", "5_years", "10_years"),
         num_etfs_remaining = map_dbl(names(ishares), 
                                      function (x) sum(!is.na(ishares[[x]]))),
         prop_etfs_remaining = map_dbl(names(ishares), 
                                       function (x){
                                         sum(!is.na(ishares[[x]]))/
                                           sum(!is.na(ishares[[1]]))
                                    }))
  ishares_nav_values_not_missing$time_elapse <- factor(ishares_nav_values_not_missing$time_elapse)
  
  
  
  write_csv(ishares_nav_values_not_missing, output_file)
}

main()