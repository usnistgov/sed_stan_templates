functions {
    real skew_student_t_lpdf(real x, real nu, real xi, real omega, real alpha) {
        // nu = Number of degrees of freedom of Student's t
        // xi, omega, alpha = Location, Scale, and Skewness parameters
        real z; 
        real zc;
        if (omega <= 0) reject(omega);
        z = (x-xi)/omega; zc = alpha*z*sqrt((nu+1)/(nu+square(z)));
        return log(2) - log(omega) + student_t_lpdf(z | nu, 0, 1) + student_t_lcdf(zc | nu+1, 0, 1); 
    }

    // Azzalini & Capitanio (2014, (2.6), (4.15)-(4.17))
    real delta_fn (real alpha) {
        return alpha/sqrt(1+square(alpha));
    }

    real bnu_fn (real nu) {
        return sqrt(nu/pi()) * exp(lgamma((nu-1)/2) - lgamma(nu/2));
    }
    real omega_fn (real tau, real nu, real alpha) {
        return tau / sqrt(nu/(nu-2) - square(bnu_fn(nu)*delta_fn(alpha))); 
    } 
}

data { 
    int n; // Number of participants
    vector[n] x; // Measured values
    vector[n] u; // Std. uncertainties associated with measured values
    vector[n] dfu; // Degrees of freedom of the {u[j]}
    real alphaPriorSD; // Prior SD for skewness parameter alpha
    real<lower=0> nuPriorShape; // Prior gamma shape for nu
    real<lower=0> nuPriorRate; // Prior gamma rate for nu
    real<lower=0> sigmaPriorMedian; // Prior median for the {sigma[j]}
    real<lower=0> tauPriorMedian; // Prior median for tau
} 

transformed data { 
    vector[n] u2;
    for (j in 1:n) { 
        u2[j] = u[j]^2; 
    } 
 
}

parameters { 
    real mu; // Measurand
    real theta[n]; // Means of measured values
    real<lower=0> tau; // Std. dev. of random effects
    real<lower=0> sigma[n]; // Std. deviations of measurement errors
    real<lower=3> nu; // Tail heaviness for random effects distribution
    real alpha; 
} // Skewness parameter of random effects distribution

model { 
    mu ~ normal(0.0, 1.0e5);  // Prior for measurand
    tau ~ cauchy(0, tauPriorMedian); // Half Cauchy prior for standard deviation of participants' effects
    nu ~ gamma(nuPriorShape, nuPriorRate); // Prior for Skew-t DF
    alpha ~ normal(0, alphaPriorSD); // Prior for skewness parameter
    
    // Half Cauchy priors for the {sigma[j]}
    for (j in 1:n) { // Azzalini & Capitanio (2014, (2.6), (4.15)-(4.17))
        theta[j] ~ skew_student_t(nu, mu - omega_fn(tau, nu, alpha) * bnu_fn(nu) * delta_fn(alpha), omega_fn(tau, nu, alpha), alpha);
        sigma[j] ~ cauchy(0, sigmaPriorMedian);
        u2[j] ~ gamma(dfu[j]/2, dfu[j]/(2*(sigma[j])));
    }
}