require(rjags)
require(MCMCvis)



run_jag <- function(file_loc){
  rocket <- read.table(file_loc, header=TRUE, sep=",")
  model.loc <- "models/rocket_jags.txt"
  jagsscript <- cat("
  model {  
  # Priors
  a ~ dexp(1)
  b ~ dexp(1)
  # Modeling
  for (i in 1:n) {
    fail_prob[i] ~ dbeta(a, b)
    num_fail[i] ~ dbin(fail_prob[i], num_launch[i])
  }

}  
",  file = model.loc)
  
  mod_jag <- jags.model(model.loc,
                        data=list(num_fail = rocket$numberOfFailures, num_launch = rocket$numberOfLaunches, 
                                  n = dim(rocket)[1]),                            
                                  n.chains=3)
  opt.JAGS <- coda.samples(mod_jag, n.iter=10000, 
                           variable.names=c("fail_prob", "a", "b"))
  return(opt.JAGS)
}

run_jag_time <- function(file_loc){
  rocket <- read.table(file_loc, header=TRUE, sep=",")
  model.loc <- "models/rocket_jags.txt"
  jagsscript <- cat("
  model {  
  # Priors
  a ~ dexp(1)
  b ~ dexp(1)
  # Modeling
  for (i in 1:n) {
    fail_prob[i] ~ dbeta(a, b)
    num_fail[i] ~ dbin(fail_prob[i], num_launch[i])
  }

}  
",  file = model.loc)
  
  mod_jag <- jags.model(model.loc,
                        data=list(num_fail = rocket$numberOfFailures, num_launch = rocket$numberOfLaunches, 
                                  n = dim(rocket)[1]),                            
                        n.chains=3)
  start <- Sys.time()
  opt.JAGS <- coda.samples(mod_jag, n.iter=10000, 
                           variable.names=c("fail_prob", "a", "b"))
  end <- Sys.time()
  # return(difftime(time1=end, time2=start, units="secs"))
  return(as.numeric(end) - as.numeric(start))
}

fit_jags <- run_jag("failure_counts.csv")


