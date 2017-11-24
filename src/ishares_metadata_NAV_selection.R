#! /usr/bin/env Rscript
# ishares_metadata_NAV_selection.R
# Daniel Raff, November 2017

# This script reads in cleaned data from results/etf_metadata_ishares_clean.csv, 
# and creates a dataframe comparing how much NAV data is lost with increasing 
# length of time that the monthly NAV spans (eg: Year to Date vs. 1 Year, vs. 10 years)

# Usage: Rscript ishares_metadata_NAV_selection.R

library(tidyverse)

ishares <- read_csv("results/etf_metadata_ishares_clean.csv")

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


write_csv(ishares_nav_values_not_missing, "results/ishares_nav_values_not_missing.csv")
