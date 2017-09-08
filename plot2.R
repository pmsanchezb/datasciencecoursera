# --------------------
#    Graph 2
# --------------------

options(scipen = 999)
library(reshape)
library(lubridate)

setwd("C:/Users/paulomauricio/Documents/Jhon's Hopkins/Exploratory data analysis")

source_clasification <- readRDS("Source_Classification_Code.rds")
summary_pm25         <- readRDS("summarySCC_PM25.rds")
summary_pm25$year    <- as.character(summary_pm25$year)

summary_pm25$plot1 <- "Plot1"
summary_pm25 <-melt(summary_pm25)

baltimore_data <-summary_pm25[which(summary_pm25$fips == "24510"),]

table_baltimore <- cast(baltimore_data,year ~ plot1,fun.aggregate = sum,
                     value.var = baltimore_data$Emissions,margins = c("year","emissions"))
table_baltimore$Plot1 <- table_baltimore$Plot1/1000000 

jpeg('plot2.png')
plot(table_baltimore$year,table_baltimore$Plot1,ylab = "Emissions (millions of tons)",
     main="Emissions from pm.25 Baltimore",col="blue",type="l",xlab = "")
dev.off()
