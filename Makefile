# Driver Script
# Daniel Raff Nov 2017
# Runs iShares Analysis
#
# usage: make all

all: doc/ishares_analysis.Rmd

##########################################################
# Data Wrangling
##########################################################

# Cleans ETF metadata from iShares
results/etf_metadata_ishares_clean.csv: src/ishares_metadata_cleaner.R
	Rscript src/ishares_metadata_cleaner.R https://github.com/raffrica/etf_correlations/blob/master/data/etf_metadata_ishares.csv results/etf_metadata_ishares_clean.csv

# Generates a summary of NAV values and the proportion of missing data
# for NAV selection
results/ishares_nav_values_not_missing.csv: src/ishares_metadata_NAV_selection.R results/etf_metadata_ishares_clean.csv
	Rscript src/ishares_metadata_NAV_selection.R results/etf_metadata_ishares_clean.csv results/ishares_nav_values_not_missing.csv

# Selects only ETFs and their NAVs that beat the S&P 500 ETF in the past 3 years
results/ishares_beat_s_and_p.csv: src/ishares_metadata_etfs_beat_s_and_p.R results/etf_metadata_ishares_clean.csv
	Rscript src/ishares_metadata_etfs_beat_s_and_p.R results/etf_metadata_ishares_clean.csv results/ishares_beat_s_and_p.csv

# Queries Google Finance API for each ETF ticker and generates tidy tall df
results/ishares_daily.csv: src/ishares_metadata_to_daily_data.R results/ishares_beat_s_and_p.csv
	Rscript src/ishares_metadata_to_daily_data.R results/ishares_beat_s_and_p.csv results/ishares_daily.csv

# Generates correlations between ETFs based on daily closing prices
results/ishares_daily_corr.csv: src/ishares_daily_data_to_corr.R results/ishares_daily.csv
	Rscript src/ishares_daily_data_to_corr.R results/ishares_daily.csv results/ishares_daily_corr.csv



###########################################################
# Figure Generation
###########################################################

results/ishares_nav_3_year.png: src/ishares_metadata_figure_generator_nav_values_not_missing.R results/ishares_nav_values_not_missing.csv
	Rscript src/ishares_metadata_figure_generator_nav_values_not_missing.R results/ishares_nav_values_not_missing.csv results/ishares_nav_3_year.png

results/ishares_hist_etfs.png: src/ishares_metadata_figure_generator_nav_3_year_returns.R results/etf_metadata_ishares_clean.csv
	Rscript src/ishares_metadata_figure_generator_nav_3_year_returns.R results/etf_metadata_ishares_clean.csv results/ishares_hist_etfs.png

results/ishares_corr_hist.png: src/ishares_daily_data_figure_generator_corr.R results/ishares_daily_corr.csv
	Rscript src/ishares_daily_data_figure_generator_corr.R results/ishares_daily_corr.csv results/ishares_corr_hist.png

###########################################################
# Docs
###########################################################

doc/ishares_analysis.Rmd: results/ishares_corr_hist.png results/ishares_hist_etfs.png results/ishares_nav_3_year.png
	Rscript -e 'ezknitr::ezknit("src/ishares_analysis.Rmd", out_dir = "doc")'

###########################################################
# Clean
###########################################################
clean:
	rm -f results/ishares_nav_values_not_missing.csv
	rm -f results/ishares_nav_values_not_missing.csv
	rm -f results/ishares_beat_s_and_p.csv
	rm -f results/ishares_daily.csv
	rm -f results/ishares_daily_corr.csv
	rm -f results/ishares_nav_3_year.png
	rm -f results/ishares_hist_etfs.png
	rm -f results/ishares_corr_hist.png



# make ishares_report (NEED TO MAKE Rmd first!)
#doc/ishares_report.md: src/count_report.Rmd results/figure/isles.png results/figure/abyss.png results/figure/last.png
#	Rscript -e 'ezknitr::ezknit("src/count_report.Rmd", out_dir = "doc")'
