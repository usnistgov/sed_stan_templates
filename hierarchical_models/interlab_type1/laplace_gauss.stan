data {
  int<lower=1> N;  // Number of labs
  vector[N] x;  // Lab means
  vector<lower=0>[N] u; // Lab uncertainties
  vector<lower=1>[N] dof; // Degrees of freedom for each lab
  real<lower=0> tau_prior_scale; 
  real<lower=0> sigma_prior_scale;
}

transformed data { 
    vector[n] u2;
    for (j in 1:n) { 
        u2[j] = u[j]^2; 
    } 
 
}

parameters {
  real mu; // true mean 
  real<lower=0> tau; // lab effect standard deviation 
  real lambda[N];  // (latent) lab effects
  real<lower=0> sigma[N]; // true lab standard deviatinos
}

model {
  
  // priors
  mu ~ normal(0,10^5); 
  tau ~ cauchy(0,tau_prior_scale);

  sigma ~ cauchy(0,sigma_prior_scale);
  lambda ~ double_exponential(mu,tau/sqrt(2)); // lab effects here assumed to be Laplace
  
  for(ii in 1:N) {

    // likelihood
    u2[ii] ~ gamma(dof[ii]/2,dof[ii]/(2*sigma[ii]^2) ); // observed sample var
    x[ii] ~ normal(lambda[ii],sigma[ii]);               // observed sample mean
    
  }
}
