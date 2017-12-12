# Driver Script
# Daniel Raff Dec 2017
# Runs a Docker Container
#
# usage: docker run -it --rm -v YOUR_LOCAL_DIRECTORY_OF_CLONED_REPO/:/home/etf_correlations raffrica/etf_docker  /bin/bash



# Using tidyverse Rocker image as a base
FROM rocker/tidyverse

# Looked at Peter Gensler's medium post (peterjgensler@gmail.com) for
# trouble-shooting tidyquant's rJava dependency
# https://medium.com/@peterjgensler/creating-sandbox-environments-for-r-with-docker-def54e3491a3

# Install required packages
RUN apt-get update -qq \
    && apt-get -y --no-install-recommends install \
    liblzma-dev \
    libbz2-dev \
    clang  \
    ccache \
    default-jdk \
    default-jre \
    && R CMD javareconf \
    && install2.r --error \
        quantmod timetk ezknitr cowplot forcats tidyquant
