source("rocket_jags.R")
source("rocket_stan.R")


### Retrieve Blang information
blang_ess_loc <- "blang/workspace/blangExample/results/latest/ess/failureProbabilities-ess.csv"
blang_ess <- read.table(blang_ess_loc, header=TRUE, sep=",")

blang_trace_loc <- "blang/workspace/blangExample/results/latest/samples/failureProbabilities.csv"
blang_trace <- read.table(blang_trace_loc, header=TRUE, sep=",")

blang_trace%>%
  filter(lv.type == "Aerobee") %>%
  ggplot(aes(x=sample, y = value))+
    geom_line()


### Make visualization
df_ess <- data.frame(name = rocket$LV.Type ,n = rocket$numberOfLaunches, Stan = sum_stan$n.eff[3:12], JAGS = sum_jags$n.eff[3:12], Blang = blang_ess$value)
df_ess <- t(df_ess)

knitr::kable(df_ess, format = "latex")

MCMCtrace(fit_jags, params="fail_prob[1]", pdf=F, iter = 10000, ISB = FALSE, type="trace")
MCMCtrace(fit_jags, params="fail_prob[7]", pdf=F, iter = 10000, ISB = FALSE, type="trace")
MCMCtrace(fit_stan, params="fail_prob[1]", pdf=F, iter = 10000, ISB = FALSE, type="trace")





