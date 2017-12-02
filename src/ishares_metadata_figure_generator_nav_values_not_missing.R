#! /usr/bin/env Rscript
# ishares_metadata_figure_generator_nav_values_not_missing.R
# Daniel Raff Nov, 2017

# This script reads in data from results/ishares_nav_values_not_missing.csv, 
# and generates a plot to show the amount of data lost. 

# Usage: Rscript src/ishares_metadata_figure_generator_nav_values_not_missing.R results/ishares_nav_values_not_missing.csv results/ishares_nav_3_year.png

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(forcats))

args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_figure <- args[2]

main <- function(){
  nav_values_remaining <- read_csv(input_file)
  
  # Remove total from time_elapse variable, as redundant when visualizing
  # proprtion of total 
  nav_values_remaining <- nav_values_remaining[!nav_values_remaining$time_elapse == "total",]
  
  # Convert time_elapse to factor for better visualization
  # and order levels so they are increasing in duration
  nav_values_remaining$time_elapse <- fct_inorder(nav_values_remaining$time_elapse)
  
  
  # I'd like to choose the NAV with 3 years of data, as I think ~75% of the ETFs
  # is enough data to work with, and 3 years will mean better quality results.  
  
  # This vector will communicate which time_elapse I want to choose
  area_fill_select_3 <- c("no", "no", "yes", "no", "no")
  area_fill_select_3
  
  nav_values_remaining <- cbind(nav_values_remaining, area_fill_select_3)
  nav_values_remaining <- as_data_frame(nav_values_remaining)
  
  p<- ggplot(nav_values_remaining, 
         aes(x = time_elapse, 
             y = prop_etfs_remaining,
             fill = area_fill_select_3)) +
    geom_bar(stat = "identity",
             colour = "#000000") +
    labs(title = "Proportion of ETF Data Available by Years of Measurement",
         x = "Years", 
         y = "Proportion of ETFs \n without Missing Information") +
    scale_x_discrete(labels = c("Since January", "1", "3", "5", "10")) +
    scale_fill_manual(values = c("no" = "#ABDDDE", 
                                 "yes" = "#ECCBAE"),
                      name = "Choice") + 
    cowplot::theme_cowplot() + 
    theme(plot.title = element_text(hjust = 0.5, size = 16, face = "bold")) 
  
  ggsave(filename = output_figure, plot = p)
}

main()