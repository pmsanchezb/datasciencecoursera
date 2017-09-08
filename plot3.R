# --------------------
#    Graph 3
# --------------------

options(scipen = 999)
library(reshape)
library(lubridate)
library(ggplot2)

setwd("C:/Users/paulomauricio/Documents/Jhon's Hopkins/Exploratory data analysis")

source_clasification <- readRDS("Source_Classification_Code.rds")
summary_pm25         <- readRDS("summarySCC_PM25.rds")
summary_pm25$year    <- as.character(summary_pm25$year)

baltimore_data <-summary_pm25[which(summary_pm25$fips == "24510"),]

jpeg('plot3.png')
qplot(baltimore_data$year,baltimore_data$Emissions,data = baltimore_data,facets = .~type,geom = "path",
      xlab = "",ylab = "Emissions (tons)")
dev.off()
