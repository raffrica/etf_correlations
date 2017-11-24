#! /usr/bin/env Rscript
# ishares_metadata_figure_generation_nav_3_year_returns.R
# Daniel Raff Nov, 2017

# This script reads in data from results/ishares_nav_values_not_missing.csv, 
# and generates a plot to show the amount of data lost. 

# Usage: Rscript ishares_metadata_figure_generation_nav_3_year_returns.R

library(tidyverse)
library(forcats)

# Read in clear ishares metadata
ishares <- read_csv("results/etf_metadata_ishares_clean.csv")


# From analysis generated in src/ishares_metadata_figure_generator_nav_values_not_missing.R
# choosing nav_monthly_3_year as the returns to look at.
ishares <- ishares %>% select(Ticker, nav_monthly_3_year)

# Now to exclude all the missing data (i.e. exclude ETFs that don't have data
# from all of the last 3 years)  
ishares <- ishares[!is.na(ishares$nav_monthly_3_year),]

# Histogram of the NAVs monthly over past 3 years
# should add something to highlight bin with S&P 500
ggplot(ishares, 
       aes(x = nav_monthly_3_year)) +
  geom_histogram()



sum(ishares$compare_s_and_p > 1)
