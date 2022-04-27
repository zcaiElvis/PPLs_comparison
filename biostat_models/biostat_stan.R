library(rstan)

write("
data {
 int<lower = 0> N_obs; 
 int<lower = 0> N_mis;
 int<lower = 1, upper = N_obs + N_mis> ii_obs[N_obs];
 int<lower = 1, upper = N_obs + N_mis> ii_mis[N_mis];
 
 int xstr[N_obs + N_mis];
 int y[N_obs + N_mis];
 int x_obs[N_obs];

}

transformed data {
  int<lower = 0> N = N_obs + N_mis;
}

parameters {
 int x_mis[N_mis];

 real gamma_0;
 real gamma_1;
 real sn0;
 real sp0;
 real sn1;
 real sp1;

}

transformed parameters {
 int x[N];
 x[ii_obs] = x_obs;
 x[ii_mis] = x_mis;
}

model {
 gamma_0 ~ uniform(0, 1);
 gamma_1 ~ uniform(0, 1);
 sn0 ~ uniform(0.5, 1);
 sp0 ~ uniform(0.5, 1);
 sn1 ~ uniform(0.5, 1);
 sp1 ~ uniform(0.5, 1);

 
 for(i in 0:N){
    x[i] ~ bernoulli((1-y[i])*gamma_0 + y[i]*gamma_1);
    xstr[i] ~ bernoulli((1-y[i])*((1-x[i])*(1-sp0) + x[i]*sn0) +
                            y[i]*((1-x[i])*(1-sp1) + x[i]*sn1));
 }
 
}

generated quantities {
}",

"stan_model.stan")

stan_loc <- "stan_model.stan"
stanc(stan_loc)

stan_data <- list(N_obs=dim(dta)[1] - sum(is.na(dta$x)), 
                  N_mis= sum(is.na(dta$x)),
                  ii_mis = which(is.na(dta$x)),
                  ii_obs = which(!is.na(dta$x)),
                  x_obs=na.omit(dta)$x, 
                  xstr=dta$xstr, 
                  y=dta$y)

fit <- stan(file = stan_loc, data = stan_data, warmup = 500, iter = 1000, chains = 4, cores = 2, thin = 1)