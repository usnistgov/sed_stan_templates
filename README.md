# Stan Template Files for Bayesian data analysis

This repository holds Stan template files for common Bayesian models (see the next section "Stan Files Explained" for more detail). Additionally, there is a Docker image provided for users to use Stan (specifically the `cmdstanr` R package) via Docker instead of having to go through local system installations with stan, the c++ toolchain, etc.

## Stan Files Explained

* `univariate_models` contains simple location-scale models, for example $X_i \sim N(\mu,\sigma)$ and $X_i \sim t_4(\mu,\sqrt{2}\sigma)$.
* `hierarchical_models` contains several types of hierarchical models:
  * `interlab_type1` contains models for interlaboratory studies where each lab's data is summarized by a mean $X_i$ and standard deviation $u_i$. The general form of the likelihoods is (using the normal distribution as an example):
$$\lambda_i \sim N(\mu, \tau)$$ 
$$X_i \sim N(\lambda_i,\sigma_i)$$
$$u_i^2 \sim \text{Gamma}(\nu/2,\nu/(2\sigma_i^2) )$$
  * `interlab_type2` contains models for interlaboratory studies where the individual values, $Y_{ij}$, from each lab (lab $i$) are available. 
$$\lambda_i \sim N(\mu, \tau)$$ 
$$Y_{ij} \sim N(\lambda_i,\sigma_i)$$

## Instructions for using the Docker image

Question: Why would I want to use Docker, can't I just install Stan on my own system? 

Answer: Yes, if you have Stan working on your local system, then you might not need or want to use Docker. Occasionally there can be difficulties with installations, especially on Windows, so Docker provides a clean way to use Stan, where all necessary installations are abstracted away from the user. Also, Docker provides a way to ensure consistency accross OS's, if desired.

Prerequisites: Docker must be installed locally on the user's computer, and the Docker engine must be running.

To initialize a containerized R environment with `cmdstanr` pre-installed, download the Dockerfile from this repository. Then using a terminal with `docker` available in the path, and the terminal in the same directory of the Dockerfile, run the command
```
docker build -t stan_env .
```
This may take a moment, but will install R, Stan, the c++ toolchain, etc., as needed to run stan. The command `docker images` should then show the newly created image. To run the container with the local directory available for reading and writing, run
```
docker run -it -v ${pwd}:/code stan_env /bin/bash
```
This will give the user a shell inside the Docker container where the user can run stan models with the stan interface `cmdstanr`.

## Acknowledgements
We acknowledge the following (in alphabetical order by last name) for their contributions to this repository: 
* Amanda Koepke
* David Newton
* Antonio Possolo
