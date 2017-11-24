#! /usr/bin/env Rscript
# ishares_metadata_to_daily_data.R
# Daniel Raff Nov, 2017

# This script reads in data from results/ishares_beat_s_and_p.csv.
# These data are the ETFs that beat the S&P 500 ETF Monthly NAV over
# the past 3 years. 
# From these data, this script gathers daily closing price data from Google Finance

# Usage: Rscript ishares_metadata_to_daily_data.R

library(tidyverse)
library(quantmod)
library(timetk)
library(tidyquant)

beat_sp <- read_csv("results/ishares_beat_s_and_p.csv")

beat_sp$Ticker

# Function that looks up the historical closing price of the specific ETF
# since January 1st, 2016. Returns a vector of closing prices.  
# In the case the data is not available, the function will return the character
# error message instead of a numeric vector. 
vector_of_daily_closing <- function(x) {
  try({tk_tbl(getSymbols(beat_sp$Ticker[x],
                    src = "google",
                    auto.assign = FALSE,
                    from = "2016-01-01"),
         preserve_index = TRUE) %>% 
    select(1, 5) %>%
    .[[2]]})
}


## Tests to see if code works before querying for all 40
# test_vector <- beat_sp$Ticker[1:3]
# test_daily_closing <- map(seq_along(test_vector), vector_of_daily_closing)
# test_df_daily_closing <- data_frame(test_vector, test_daily_closing)
# test_df_daily_closing

# Generates a list of numeric vectors with the closing prices per ETF
daily_closings <- map(seq_along(beat_sp$Ticker), vector_of_daily_closing)
View(daily_closings)

# Now join this back with the original ETF Tickers into a df
df_daily_closings <- data_frame(beat_sp$Ticker, daily_closings)

# Subset the df to include only those that got price data
df_daily_closings <- df_daily_closings[map_lgl(df_daily_closings$daily_closings, is.double),]

# tidy up the names
df_daily_closings <- df_daily_closings %>% rename(ticker = `beat_sp$Ticker`)
df_daily_closings

# Test to see if can get correlation between two ETFs
cor(x = unlist(df_daily_closings$daily_closings[1]),
    y = unlist(df_daily_closings$daily_closings[2]))



# When try to unnest and spread data it doesn't work. Come back to this
#%>% spread(key = ticker, value = daily_closings)

# Figure out how to make a correlation matrix from above.  