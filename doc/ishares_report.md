---
title: "iShares ETF Analysis"
author: "Daniel Raff"
date: "December 1st, 2017"
output: github_document
---






# iShares ETF Analysis  

## Background
I'm currently reading the book [Principles by Ray Dalio](https://www.principles.com/). In it he describes his method to successful investing, which largely involves writing 'principle'-based algorithms for trading. He extends this to principle-based algorithms for an idea meritocracy which is largely why I am reading the book. In one part of the book, Mr. Dalio describes a eureka moment in which he realizes he can invest in higher risk assets as long as they have low correlation with one another. Thus he is able to diversify his portfolio by means of correlation - if a risky investment fails, at least it won't be correlated with his other riskier investments and he will be able to leverage that risk for a higher overall return. 

As someone with almost no investment knowledge but a growing statistical knowledge, I found this eureka moment fascinating. While my knowledge is very limited, I have been reading more about Exchanged Traded Funds (ETFs) as a less risky asset class - although I won't go into detail about them. My thought was if I could create a portfolio of ETFs that minimize correlation among them, I could choose ETFs with higher risk (and reward).  

## Hypothesis

My hypothesis is that among ETFs that outperform the market (approximated by iShares S&P 500 ETF with ticker IVV) there will be significant variation in correlation. The reason this is a significant question is that choosing ETFs with different correlations between them but that all have high returns will create a better a more balanced portolio with less overall risk. 

The caveat here is that 1) I mostly don't know what I'm talking about. 2) These are just ETFs that are performing well in the current market. If the market were to significantly change these ETFs may all change as well. What I am *not* doing is calculating beta compared to the S&P 500 (which is a future direction that I'll describe below). 


## Analysis

To begin my analysis, I read in the metadata the ETF from iShares by Blackrock. This had useful fields such as the ETF tickers, and corresponding performance as measured by Net Asset Value of the ETF either compounded monthly, or quarterly with data extending back as far as 10 years. Since I wanted to compare ETFs performance to the S&P 500 ETF (with ticker IVV), I needed to choose a performance metric. First I arbitrarily chose compounding monthly. 

I can choose the NAVs per ETF with data extending back to the beginning of the year, 1 year ago, 3 years ago, 5 years ago, or 10 years ago. The problem here is that ETFs are quite new, so if I extend too far back, I won't be able to compare many ETFs. On the other hand, 1 year may not be enough information to actually know if a given ETF outperforms the market.

![plot of chunk unnamed-chunk-2](../results/ishares_nav_3_year.png)

The above figure shows the proportion of the ETF data as it relates to the complete data set (i.e. the Year to Date - or the data since January). ETF performance as measured by NAV compounded monthly over the past **3 years** seems to be a healthy medium, keeping approximately 75% of the available data, while being enough time to get a sense for how well the ETF performs.  

### Filtering for ETFs that Outperformed the S&P 500 


![plot of chunk unnamed-chunk-3](../results/ishares_hist_etfs.png)

### Correlations between Pairs of High Growth ETFs


```
## Error: '../results/ishares_daily_corr_matrix.csv' does not exist in current working directory ('/Users/danielraff/Masters of Data Science/Projects/etf_correlations').
```



![plot of chunk unnamed-chunk-5](../results/ishares_corr_hist.png)

