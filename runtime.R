source("rocket_jags.R")
source("rocket_stan.R")

size_100 <- "synt_data/size_100.csv"
size_200 <- "synt_data/size_200.csv"
size_300 <- "synt_data/size_300.csv"
size_400 <- "synt_data/size_400.csv"
size_500 <- "synt_data/size_500.csv"


### Jags and Stan runtime ###
jags_rt <- sapply(c(size_100, size_200, size_300, size_400, size_500), FUN= run_jag_time)
stan_rt <- sapply(c(size_100, size_200, size_300, size_400, size_500), FUN= run_stan_time)


### Blang runtime, retrieved from the blang summary page ###
blang_rt <- c(47.554, 91.301, 133.726, 170.983, 213.563)

rt <- data.frame(data_size = seq(100,500,100), JAGS = jags_rt, Stan = stan_rt, Blang = blang_rt)
rownames(rt) <- NULL
rt <- t(rt)


knitr::kable(rt, format = "latex")