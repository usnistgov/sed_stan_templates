data {
  int<lower=0> J;
  real y[J];
  real<lower=0> sigma[J];
}

parameters {
  real mu;
  real<lower=0> tau;
  real lambda_tilde[J];
}

transformed parameters {
  real lambda[J];
  for (j in 1:J)
    lambda[j] = mu + tau * lambda_tilde[j];
}

model {
  mu ~ normal(0, 5);
  tau ~ cauchy(0, 5);
  lambda_tilde ~ normal(0, 1);
  y ~ normal(lambda, sigma);
}