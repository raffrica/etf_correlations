#! /usr/bin/env Rscript
# ishares_daily_data_to_corr.R
# Daniel Raff Nov, 2017

# This script reads in a tidy df of daily closing prices and calculates the correlation between each
# then outputs a tidy and tall df without redundancy of the correlation between each. 

# Usage: Rscript src/ishares_daily_data_to_corr.R results/ishares_daily.csv results/ishares_daily_corr.csv

suppressPackageStartupMessages(library(tidyverse))

args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_file <- args[2]

main <- function(){
  # import tidy df of daily closing prices generated in src/ishares_metadata_to_daily_data.R
  daily_df <- read_csv(input_file)
  
  # generate correlation matrix
  correlation_matrix <- cor(daily_df, use = "na.or.complete")
  
  # convert correlation to tall df
  corr_df <- as_data_frame(as.table(correlation_matrix))
  
  # filter out redundancies and change name
  corr_df <- corr_df %>% 
    filter(Var1 > Var2) %>% 
    rename(etf_1 = Var1, etf_2 = Var2, corr = n)
  
  write_csv(corr_df, output_file)
}

main()