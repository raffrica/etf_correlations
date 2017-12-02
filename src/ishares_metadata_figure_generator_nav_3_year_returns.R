#! /usr/bin/env Rscript
# ishares_metadata_figure_generator_nav_3_year_returns.R
# Daniel Raff Nov, 2017

# This script reads in clean ishares metadata and then looks generates
# a histogram of the distribution of 3 year NAVs. 

# Usage: Rscript src/ishares_metadata_figure_generator_nav_3_year_returns.R results/etf_metadata_ishares_clean.csv results/ishares_hist_etfs.png

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(forcats))
suppressPackageStartupMessages(library(scales))


args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_figure <- args[2]

main <- function(){
  # Read in clear ishares metadata
  ishares <- read_csv("results/etf_metadata_ishares_clean.csv")
  
  
  # From analysis generated in src/ishares_metadata_figure_generator_nav_values_not_missing.R
  # choosing nav_monthly_3_year as the returns to look at.
  ishares <- ishares %>% select(Ticker, nav_monthly_3_year)

  # Now to exclude all the missing data (i.e. exclude ETFs that don't have data
  # from all of the last 3 years)  
  ishares <- ishares[!is.na(ishares$nav_monthly_3_year),]
  
  ishares <- ishares %>% mutate(colour = factor(ifelse(nav_monthly_3_year > 10.72,
                                     "Outperformed the S&P 500",
                                     "Underperformed the S&P 500")))
  
  ishares$colour <- fct_infreq(ishares$colour)
  ishares
  # Histogram of the NAVs monthly over past 3 years
  ggplot(ishares, 
         aes(x = nav_monthly_3_year / 100,
             fill = colour)) +
    geom_histogram(bins = 30, colour = "black") +
    labs(x = "Performance per ETF of Net Asset Value Compounded Monthly over the last 3 Years", 
         y = "Count", 
         title = "Distribution of ETFs based on NAV data") + 
    scale_fill_manual(values = c("Outperformed the S&P 500" = "#ECCBAE", 
                                 "Underperformed the S&P 500" = "#ABDDDE"),
                      limits = c("Outperformed the S&P 500", 
                                 "Underperformed the S&P 500"),
                      name = "") +
    scale_x_continuous(labels = percent) +
    cowplot::theme_cowplot() + 
    theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold")) 
  
  ggsave(output_figure)
}

main()



