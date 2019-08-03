library(mclust)

TS = TeamTimeSeries[1:16]

my_TS = data.frame()

for (ts in TS) {
  my_TS = rbind(my_TS, ts$win_pct)
}

rownames(my_TS) = names(TS)

mjr = Mclust(t(my_TS))
summary(mjr)
mjr$G
mjr$classification

my_TS = cbind(t(my_TS), 'class' = mjr$classification, 'time' = TS$`New York Yankees`$yearID)

yolo = gather(data.frame(my_TS), key = 'team', value = 'ts', -class, -time)

str(yolo)

ggplot(yolo, aes(x = time, y = ts, color = class)) + geom_line()
