#! /usr/bin/env Rscript
# ishares_metadata_to_daily_data.R
# Daniel Raff Nov, 2017

# This script reads in data from results/ishares_beat_s_and_p.csv.
# These data are the ETFs that beat the S&P 500 ETF Monthly NAV over
# the past 3 years. 
# From these data, this script gathers daily closing price data from Google Finance since January 1st, 2016
# and brings them together into a tidy dataframe

# Usage: Rscript src/ishares_metadata_to_daily_data.R results/ishares_beat_s_and_p.csv results/ishares_daily.csv

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(quantmod))
suppressPackageStartupMessages(library(timetk))
suppressPackageStartupMessages(library(tidyquant))


args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_file <- args[2]

main <- function(){
  writeLines("\n \n \n Warnings are expected when data for a specific ETF Ticker is unavailable \n \n \n")
  
  # Read in data on Tickers that beat the S and P
  beat_sp <- read_csv(input_file)
  
  # Function that looks up the historical closing price of the specific ETF
  # since January 1st, 2016. Returns a vector of closing prices from Google Finance.  
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

  
  # Generates a list of numeric vectors with the closing prices per ETF from Google Finance
  daily_closings <- suppressWarnings(map(seq_along(beat_sp$Ticker), vector_of_daily_closing))
  
  # Now join this back with the original ETF Tickers into a complete df
  df_daily_closings <- data_frame(beat_sp$Ticker, daily_closings)
  
  # Subset the df to include only those which successfully queried price data from Google Finance
  df_daily_closings <- df_daily_closings[map_lgl(df_daily_closings$daily_closings, is.double),]
  
  # tidy up the names
  df_daily_closings <- df_daily_closings %>% rename(ticker = `beat_sp$Ticker`)
  df_daily_closings
  
  # Because diffferent amount of daily closing prices exist per ETF ticker (Google Finance is not perfect)
  # our data is currently not tabular. We need the data to be tabular in order to get the correlation.
  # Since we need the length of all daily closing vectors to be equal, we need to find the maximum length
  # of a single daily closing vector among all of the daily closing vectors
  # Then we can fill in the vectors with less data with NAs so that the data can be tabular
  
  # maximum length out of all daily closing vectors
  maximum_daily_data <- max(map_dbl(df_daily_closings$daily_closings, length))
  
  # Number of tickers 
  num_tickers <- length(df_daily_closings$ticker)
  
  # map over all daily closings prices and pad with NAs where length is not equal to maximum_daily_data
  df_daily_closings$daily_closings <- map(df_daily_closings$daily_closings, function(x) {c(x, rep(NA, maximum_daily_data - length(x)))})
  
  # convert data to tall dataframe
  df_daily_closings_tall <- df_daily_closings %>% unnest()
  
  # add ids so can spread data
  df_daily_closings_tall$id <- rep(1:maximum_daily_data, num_tickers)
  
  # spread data
  df_spread <- df_daily_closings_tall %>% spread(key = ticker, value = daily_closings)
  
  # remove index column (that was added for spreading data)
  df_spread <- df_spread[,-1]
  
  # write to csv 
  write_csv(df_spread, output_file)
}

main()