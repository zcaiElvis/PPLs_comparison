require(rjags)
require(MCMCvis)


#### Data specification
dta <- rbind(
  matrix(rep(c(1,0,0),13), byrow=T, ncol=3),
  matrix(rep(c(1,0,1),3), byrow=T, ncol=3),
  matrix(rep(c(1,1,0),5), byrow=T, ncol=3),
  matrix(rep(c(1,1,1),18), byrow=T, ncol=3),
  matrix(rep(c(0,0,0),33), byrow=T, ncol=3),
  matrix(rep(c(0,0,1),11), byrow=T, ncol=3),
  matrix(rep(c(0,1,0),16), byrow=T, ncol=3),
  matrix(rep(c(0,1,1),16), byrow=T, ncol=3),
  matrix(rep(c(1,NA,0),318), byrow=T, ncol=3),
  matrix(rep(c(1,NA,1),375), byrow=T, ncol=3),
  matrix(rep(c(0,NA,0),701), byrow=T, ncol=3),
  matrix(rep(c(0,NA,1),535), byrow=T, ncol=3))        
colnames(dta) <- c("y","x","xstr")
dta <- as.data.frame(dta)
# dta$pat <- seq(1,dim(dta)[1])

write.table(dta, file="dta.csv", sep=",", row.names = TRUE, col.names=TRUE)

#### modeling

model.loc <- "jags_models/example.txt"

jagsscript <- cat("
model {  
  
  # Priors
  gamma.0 ~ dunif(0,1);
  gamma.1 ~ dunif(0,1);
  trgt <- logit(gamma.1) - logit(gamma.0)
  
  sn0 ~ dunif(0.5, 1);
  sp0 ~ dunif(0.5, 1);
  sn1 ~ dunif(0.5, 1);
  sp1 ~ dunif(0.5, 1);
  
  dl.sn <- sn1 - sn0;
  dl.sp <- sp1 - sp0;
  
  
  # Modeling
  for (i in 1:n) {
    x[i] ~ dbern((1-y[i])*gamma.0 + y[i]*gamma.1);
    xstr[i] ~ dbern((1-y[i])*((1-x[i])*(1-sp0)+x[i]*sn0) + 
    y[i]*((1-x[i])*(1-sp1)+x[i]*sn1))
  }

}  
",  file = model.loc)


mod0 <- jags.model(model.loc,
                   data=list(x=dta$x, y=dta$y, xstr=dta$xstr,       
                             n=dim(dta)[1]),                            
                   n.chains=3)

opt0.JAGS <- coda.samples(mod0, n.iter=10000, thin=10, 
                          variable.names=c("gamma.0","gamma.1","sn0","sp0",
                                           "sn1","sp1","dl.sn","dl.sp","trgt"))

MCMCsummary(opt0.JAGS)

MCMCtrace(opt0.JAGS, params="trgt", pdf=F)