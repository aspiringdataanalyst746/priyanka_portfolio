# video: same data, different outcomes
# install Tmisc package
library(Tmisc)
data("quartet")
View(quartet)
# summarize each set
quartet %>% 
  group_by(set) %>% 
  summarise(mean(x), sd(x), mean(y), cor(x,y))
# graphs to visualize data
ggplot(quartet, aes(x,y)) + geom_point() + geom_smooth(method = lm, se = FALSE) + facet_wrap(~set)

# datasauRus package
library('datasauRus')
ggplot(datasaurus_dozen,aes(x=x,y=y,colour=dataset))+geom_point()+theme_void()+theme(legend.position = "none")+facet_wrap(~dataset,ncol=3) 

# The bias function
library("SimDesign")
actual_temp <- c(68.3, 70, 72.4, 71, 67, 70)
predicted_temp <- c(67.9, 69, 71.5, 70, 67, 69)
bias(actual_temp, predicted_temp)

# Games store example
actual_sales <- c(150, 203, 137, 247, 116, 287)
predicted_sales <- c(200, 300, 150, 250, 150, 300)
bias(actual_sales, predicted_sales)
