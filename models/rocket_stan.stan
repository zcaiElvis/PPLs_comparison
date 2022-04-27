
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
    }
