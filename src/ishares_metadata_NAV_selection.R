#! /usr/bin/env Rscript
# etf_select_risk_metric.R

# This script reads in data from data/etf_metadata_ishares.csv, chooses an
# appropriate Net Asset Value and generates Betas as they relate to the
# iShares Core S&P 500 ETF (IVV)

library(tidyverse)
library(quantmod)

ishares <- read_csv("data/etf_metadata_ishares.csv")

# Look at data
View(ishares)

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

ishares
