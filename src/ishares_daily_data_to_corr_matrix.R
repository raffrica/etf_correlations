#! /usr/bin/env Rscript
# ishares_daily_data_to_corr_matrix.R
# Daniel Raff Nov, 2017

# This script reads in a tidy df of daily closing prices and calculates the correlation between each
# then outputs a csv of the correlation matrix

# Usage: Rscript src/ishares_daily_data_to_corr_matrix.R results/ishares_daily.csv results/ishares_daily_corr_matrix.csv

suppressPackageStartupMessages(library(tidyverse))

args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_file <- args[2]

main <- function(){
  # import tidy df of daily closing prices generated in src/ishares_metadata_to_daily_data.R
  daily_df <- read_csv(input_file)
  
  # generate correlation matrix
  correlation_matrix <- cor(daily_df, use = "na.or.complete")
  correlation_matrix <- as.data.frame(correlation_matrix)
  write.csv(x = correlation_matrix, file = output_file, row.names = TRUE, col.names = TRUE)
}

main()