#! /usr/bin/env Rscript
# ishares_daily_data_figure_generator_corr.R
# Daniel Raff Dec, 2017

# This script reads in ETF correlations from /results/ishares_daily_corr.csv
# which are correlations between ETFs, and outputs figures 

# Usage: Rscript src/ishares_daily_data_figure_generator_corr.R results/ishares_daily_corr.csv results/ishares_corr_hist.png


suppressPackageStartupMessages(library(tidyverse))

args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_figures <- args[2]

main <- function(){
  # read in daily corrlations between ETFs that beat the S&P 500 (using daily closing 
  # prices since Jan 1 2016
  daily_corr <- read_csv(input_file)
  
  # Generate Figure
  ggplot(daily_corr) +
    geom_histogram(aes(x = corr), 
                   fill = "#ABDDDE", 
                   colour = "black",
                   bins = 30) +
    labs(x = "Correlation between Unique ETF Tickers that Outperformed the S&P 500",
         y = "Count",
         title = "Distribution of Correlations between ETF Tickers that Outperformed the S&P 500")
  
  ggsave(output_figures)
}


main()