FROM gcr.io/deeplearning-platform-release/r-cpu

# install dependencies
RUN apt-get update && \
    apt-get install -y \
        autoconf \
        automake \
        g++ \
        gcc \
        cmake \
        gfortran \
        make \
        nano \
        liblapack-dev \
        liblapack3 \
        libopenblas-base \
        libopenblas-dev \
    && apt-get clean all \
    && rm -rf /var/lib/apt/lists/*
 
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile 
RUN Rscript -e "install.packages('remotes');"
RUN Rscript -e "remotes::install_github('facebookexperimental/Robyn/R');"



RUN Rscript -e "install.packages('reticulate');"
RUN Rscript -e "library(reticulate)"

## Install Nevergrad

RUN Rscript -e "reticulate::use_python('/opt/conda/bin/python')"
RUN Rscript -e "reticulate::py_config()"
RUN Rscript -e "reticulate::py_install('nevergrad', pip = TRUE)"

##Install BigQuery client
RUN Rscript -e "install.packages('bigrquery');"


WORKDIR /root
EXPOSE 8080