#! /usr/bin/env Rscript
# ishares_metadata_etfs_beat_s_and_p.R
# Daniel Raff Nov, 2017

# This script reads in data from results/ishares_nav_values_not_missing.csv, 
# and generates a plot to show the amount of data lost. 

# Usage: Rscript ishares_metadata_etfs_beat_s_and_p.R

library(tidyverse)

# Read in clear ishares metadata
ishares <- read_csv("results/etf_metadata_ishares_clean.csv")


# From analysis generated in src/ishares_metadata_figure_generator_nav_values_not_missing.R
# choosing nav_monthly_3_year as the returns to look at.
ishares <- ishares %>% select(Ticker, nav_monthly_3_year)

# Now to exclude all the missing data (i.e. exclude ETFs that don't have data
# from all of the last 3 years)  
ishares <- ishares[!is.na(ishares$nav_monthly_3_year),]

# New variable comparing each ETF to the s_and_p
ishares <- ishares %>% mutate(compare_s_and_p = nav_monthly_3_year/10.72)

beats_s_and_p <- ishares[ishares$compare_s_and_p > 1.0,]

write_csv(beats_s_and_p, "results/ishares_beat_s_and_p.csv")

