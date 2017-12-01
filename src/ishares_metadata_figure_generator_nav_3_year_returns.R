#! /usr/bin/env Rscript
# ishares_metadata_figure_generator_nav_3_year_returns.R
# Daniel Raff Nov, 2017

# This script reads in clean ishares metadata and then looks generates
# a histogram of the distribution of 3 year NAVs. 

# Usage: Rscript ishares_metadata_figure_generator_nav_3_year_returns.R

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

ishares <- ishares %>% mutate(colour = factor(ifelse(nav_monthly_3_year == 10.72,
                                   "S & P 500",
                                   "Others")))

ishares$colour <- fct_inorder(ishares$colour)

# Histogram of the NAVs monthly over past 3 years
# should add something to highlight bin with S&P 500
ggplot(ishares, 
       aes(x = nav_monthly_3_year,
           fill = colour),
       colour = "black") +
  geom_histogram() +
  labs(x = "Monthly NAV over past 3 Years", 
       y = "Count", 
       title = "Histogram of ETFs based on NAV data",
       legend = "S & P 500") + 
  scale_fill_manual(values = c("S & P 500" = "#ECCBAE", 
                               "Others" = "#ABDDDE"),
                    name = "")

ggsave("results/ishares_hist_etfs.png")




