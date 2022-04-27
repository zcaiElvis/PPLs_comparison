library(rstan)

run_stan <- function(file_loc){
  rocket <- read.table(file_loc, header=TRUE, sep=",")
  write("
    data {
      int<lower=1> n;
      int<lower=0> num_launch[n];
      int<lower=0> num_fail[n];
    }
  
    parameters {
     real<lower=0> a;
     real<lower=0> b;
     real<lower=0, upper=1> fail_prob[n];
    }
    
    model {
        a ~ exponential(1);
        b ~ exponential(1);
        
      for(i in 1:n){
        fail_prob[i] ~ beta(a,b);
        num_fail[i] ~ binomial(num_launch[i], fail_prob[i]);
      }
    }
    
    generated quantities {
    }", "models/rocket_stan.stan")
  
  stan_loc <- "models/rocket_stan.stan"
  
  stan_data <- list(num_launch = rocket$numberOfLaunches, num_fail = rocket$numberOfFailures, n = dim(rocket)[1])
  fit <- stan(file = stan_loc, data = stan_data, iter = 10000, chains = 4, init = 0)
  return(fit)
}

run_stan_time <- function(file_loc){
  rocket <- read.table(file_loc, header=TRUE, sep=",")
  write("
    data {
      int<lower=1> n;
      int<lower=0> num_launch[n];
      int<lower=0> num_fail[n];
    }
  
    parameters {
     real<lower=0> a;
     real<lower=0> b;
     real<lower=0, upper=1> fail_prob[n];
    }
    
    model {
        a ~ exponential(1);
        b ~ exponential(1);
        
      for(i in 1:n){
        fail_prob[i] ~ beta(a,b);
        num_fail[i] ~ binomial(num_launch[i], fail_prob[i]);
      }
    }
    
    generated quantities {
    }", "rocket_stan.stan")
  
  stan_loc <- "rocket_stan.stan"
  
  stan_data <- list(num_launch = rocket$numberOfLaunches, num_fail = rocket$numberOfFailures, n = dim(rocket)[1])
  start <- Sys.time()
  fit <- stan(file = stan_loc, data = stan_data, iter = 10000, chains = 4, init = 0)
  end <- Sys.time()
  return(as.numeric(end)-as.numeric(start))
}


fit_stan <- run_stan("failure_counts.csv")
