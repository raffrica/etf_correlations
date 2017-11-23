# README

Data analysis for etf_correlations.
Created by Daniel Raff daniel18raff@gmail.com.

Started on November 22nd, 2017.

`data` directory: Only raw data and metadata. These files are *not* to
be modified.

`doc` directory: text documents (eg: manuscripts, documentation, record of experiments)

`results` directory: intermediate results, cleaned data, final results, etc.

`src` directory: project source code

`misc` directory: Anything that is of poor quality and/or doesn't fit in above directories.


---------
---------

## Project Overview

### Background
I'm currently reading the book [Principles by Ray Dalio](https://www.principles.com/). In it he describes his method to successful investing, which largely involves writing 'principle'-based algorithms for trading. He extends this to principle-based algorithms for an idea meritocracy which is largely why I am reading the book. In one part of the book, Mr. Dalio describes a eureka moment in which he realizes he can invest in higher risk assets as long as they have low correlation with one another. Thus he is able to diversify his portfolio by means of correlation - if a risky investment fails, at least it won't be correlated with his other riskier investments and he will be able to leverage that risk for a higher overall return. 

As someone with almost no investment knowledge but a growing statistical knowledge, I found this eureka moment fascinating. While my knowledge is very limited, I have been reading more about ETFs as a less risky asset class - although I won't go into detail about them. My thought was if I could create a portfolio of ETFs that minimize correlation among them, I could choose ETFs with higher risk (and reward).  

### Goal
My goal is to find a set of 5 High-Return / High-Risk ETFs that minimize the sum correlation between each ETF in the set. Ideally I will do this with exclusively Canadian ETFs (this makes sense with my Canadian Dollar for various reasons).  

#### Get the Data

Firstly, I need to find the ETF Ticker's so that I can look up the historical data associated with each. For American Tickers I can use [MasterData](http://www.masterdata.com/helpfiles/etf_list.htm) and for Canadian Tickers [TMX](https://app.tmxmoney.com/etp/directory/). 

Second, I can use the `quantmod` package in R to load the historical data for each ETF in and save it as a variable. 

#### Questions for the Data

Once I've read in the data, I will look only at ETFs with an annual return of greater than a certain amount. This will act as my surrogate for high-risk/high-reward (although I do understand that it's much [more nuanced](http://www.quantext.com/RiskandReturn.pdf). 

My first question is: what is a reasonable annual return to set as a threshold for ETFs (i.e. to only look at ETFs with an annual return of higher than that value). My hypothesis is that 10% annual return will be reasonable, in that I can still have a large enough proportion of total ETFs to work with - large enough being at least 1/3 of the total.  

My second question is: will there be low correlations between a set of 5 of the above high-risk ETFs. My hypothesis is that I will be able to find a set of 5 high-risk ETFs with a total correlation (between all) of less than 0.5 (this is somewhat arbitrary - I know a good target between any two assets is between -0.1 and 0.1.  

#### Visualizations and Summaries

To aid in choosing an annual return, I'll visualize all annual return percentages a histogram. This will help me decide where the cut off should be so that there are still a significant count of ETFs above the threshold. The threshold can be added as a vertical line onto the histogram with aesthetic mappings of x = percentage annual return, and y = counts.  

To understand overall correlations, I will generate a correlation matrix of the ETF subset above the certain threshold. I will generate two. One for computational purposes (see below), and the second for communication purposes - i.e. to show a matrix of 5 given etfs (as an example of what a set could look like). This kind of analysis is available for american ETFs at websites like: [Portfolio Visualizer - Asset Correlations](https://www.portfoliovisualizer.com/asset-correlations). At this website, I can add ETFs that I've already chosen and the program will return a correlation matrix.    

#### Pipeline

**Step 1**:   
My first step is to get the data. Specifically I want a list of all ETFs and their corresponding tickers, so that I can then look up the historical prices for each ETF. I will get ETFs and their corresponding ticker names at [MasterData](http://www.masterdata.com/HelpFiles/ETF_List_Downloads/AllETFs.csv) (non-Canadian), [TMX](https://www.tmxmoney.com/en/pdf/ETF_List.xls) (Canadian), and even from ETF Funds themselves such as [iShares by BlackRock](https://www.ishares.com/us/products/etf-product-list#).  

**Step 2**:   
Next I will use a library for R called [quantmod](https://cran.r-project.org/web/packages/quantmod/quantmod.pdf) which communicates with the API of google finance (among others such as alpha vantage) to get the historical price data for each ETF.  

**Step 3**:  
I will calculate the annual return manually for each ETF, or I will use the metadata already provided from the iShares data (although this would restrict me to just iShares ETFs).  

**Step 4**:  
Once I have the data for each ETF and the associated annual return, I will visualize the distribution of annual returns and choose a threshold. I will then subset the ETF tickers and only include those above that threshold.  

**Step 5**:  
With the ETF tickers that remain, I will use `quantmod` to create a vector of daily closing prices over the past 6 months for each ETF. I will then use these to generate a correlation matrix. With the goal in mind of generating a portfolio/set of 5 low correlation ETFs, I will show a correlation matrix of a random 5 ETFs that are not low correlation (as a 'before' for the next step). 

**Step 6**:  
Write a linear programming algorithm to minimize the sum of correlations in a set of 5. The objective function will be to minimize the sum of correlations between 5 ETFs. I will create a correlation matrix with the optmial solution to minimizing correlation. This will compare well with the random result from Step 5. 

### Potential Problems

A lot of this project is ambitious for me, so instead of pursuing the idealized version, I may have to do a smaller, less ambitious version. These are potential problems I may run into (or already have run into) and what I can do about it so that I still have a project.   

* Canadian ETF data is *less* available. With initial experimentation with `quantmod` it appears the google finance hidden API (based on a url for a csv download) doesn't work well for getting the Canadian ETF historical data. I may have to restrict the project to American ETFs (for the time being). If I have enough time, I could learn websraping to get the existing data from google finance without using their hidden API.  
* Calculating Annual Rate of Return manually is more work than just using the already calculated data set from iShares complete with metadata. As a starting point it makes more sense to just work with this data set.  
* Linear Programming may be an ambitious addition within the time constraints. This project still has validity in just generating the correlation matrix and running some visualizations and analyses on returns for lower correlation ETFs as they relate to well correlated.  


### Future Ideas

Quantitative correlation is not the whole picture. After completing the project above (including the linear programming) for all of Canadian ETFs, there are a few directions I could take it in. 

1) I could tweak the constrains in the linear program to get different sets of 5, and then take this short list to people with financial experience and understanding to pick the best ETFs within them. 

2) I could make a webapp for Canadian ETF correlations as it's an unmet need, even if it's just to generate the correlation matrix.  