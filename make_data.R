create_data <- function(siz){
  types <- sapply(seq(1,siz,1), FUN = toString)
  launch <- sample(seq(1,12,1), siz, replace=TRUE)
  fail <- sapply(launch, FUN = function(a){return(a-sample(seq(1,a), 1, replace=TRUE))})
  df <- data.frame(LV.type = types, numberOfLaunches = launch, numberOfFailures = fail)
  return(df)
}


write.table(create_data(100), "synt_data/size_100.csv", row.names = FALSE, sep=",")
write.table(create_data(200), "synt_data/size_200.csv", row.names = FALSE, sep=",")
write.table(create_data(300), "synt_data/size_300.csv", row.names = FALSE, sep=",")
write.table(create_data(400), "synt_data/size_400.csv", row.names = FALSE, sep=",")
write.table(create_data(500), "synt_data/size_500.csv", row.names = FALSE, sep=",")

write.table(create_data(100), "synt_data/blang_100.csv", row.names = TRUE, sep=",")
write.table(create_data(200), "synt_data/blang_200.csv", row.names = TRUE, sep=",")
write.table(create_data(300), "synt_data/blang_300.csv", row.names = TRUE, sep=",")
write.table(create_data(400), "synt_data/blang_400.csv", row.names = TRUE, sep=",")
write.table(create_data(500), "synt_data/blang_500.csv", row.names = TRUE, sep=",")




