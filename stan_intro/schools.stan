data {
  int<lower=0> J;
  real y[J];
  real<lower=0> sigma[J];
}

parameters {
  real mu;
  real<lower=0> tau;
  real lambda[J];
}

model {
  mu ~ normal(0, 5);
  tau ~ cauchy(0, 5);
  lambda ~ normal(mu, tau);
  y ~ normal(lambda, sigma);
}