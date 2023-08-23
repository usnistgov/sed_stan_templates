FROM r-base:4.3.1

# install cmdstanr
RUN R -e 'install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))'

# install cmdstan (note that c++ toolchain comes pre-installed on the r-base image)
RUN R -e 'cmdstanr::install_cmdstan()' 

RUN mkdir /code
WORKDIR /code
COPY . /code
