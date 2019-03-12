#---------------------------------------------------
#Title: k-means clustering on correlation of workflows and activities count
#Created Date: 2019/03/12
#Created by: Josh N <yoshitaka.nagano@uipath.com>
#Usage: 1.Run CodeAnalyzer  2. Place Overview.csv in data 3. Run this script
#---------------------------------------------------

#dependencies
#install.packages("readr")
#install.packages("ggplot2")
#install.packages("ggthemes")
#install.packages("reshape2")
#install.packages("cluster")

#setwd("./R/project/xx/")

#init
library("readr")
library("ggplot2")
library("ggthemes")
library("reshape2")
library("cluster")

#arguments = read_csv("../../data/Arguments.csv")
#issues = read_csv("../../data/Issues.csv")
overview = read_csv("../../data/Overview.csv")
#variables = read_csv("../../data/Variables.csv")

#shape it up (pivot-ish table)
shptbl = dcast(overview, ProjectName~Category, value.var = "Value", sum)
colnames(shptbl) <- c("Project", "Activity", "Log", "Workflow")
shptbl = subset(shptbl, Workflow>0, select = c(Activity,Workflow))

#k-means clustering (Hartigan & Wong algorithm)
cls = kmeans(shptbl, 3)
shptbl$cluster = factor(cls$cluster)
#centers = as.data.frame(cls$centers)

#visualize
ggplot(data = shptbl, aes(x = Activity, y = Workflow)) +
  geom_point(aes(color = cluster, shape = cluster)) +
  theme_bw() + #  scale_color_bw() +
  ggtitle("Correlation of Workflows and Activities count (k-means clustering)")

#EOL