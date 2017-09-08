# --------------------
#    Graph 1
# --------------------

options(scipen = 999)
library(reshape)
library(lubridate)

setwd("C:/Users/paulomauricio/Documents/Jhon's Hopkins/Exploratory data analysis")

source_clasification <- readRDS("Source_Classification_Code.rds")
summary_pm25         <- readRDS("summarySCC_PM25.rds")
summary_pm25$year    <- as.character(summary_pm25$year)

head(summary_pm25,3)

summary_pm25$plot1 <- "Plot1"
summary_pm25 <-melt(summary_pm25)
table_resume <- cast(summary_pm25,year ~ plot1,fun.aggregate = sum,
                     value.var = summary_pm25$Emissions,margins = c("year","emissions"))
table_resume$Plot1 <- table_resume$Plot1/1000000 

jpeg('plot1.png')
plot(table_resume$year,table_resume$Plot1,ylab = "Emissions (millions of tons)",
     main="Emissions from pm.25",col="blue",type="l",xlab = "")
dev.off()

