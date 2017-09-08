# --------------------
#    Graph 6
# --------------------

options(scipen = 999)
library(reshape)
library(lubridate)
library(ggplot2)
library(lattice)

setwd("C:/Users/paulomauricio/Documents/Jhon's Hopkins/Exploratory data analysis")

source_clasification <- readRDS("Source_Classification_Code.rds")
summary_pm25         <- readRDS("summarySCC_PM25.rds")
summary_pm25$year    <- as.character(summary_pm25$year)

summary_pm25$plot6 <- "Plot6"
vehicles.scc <- as.character(source_clasification[grep("Vehicles", source_clasification$Short.Name),"SCC"])
motorcycle.scc <- as.character(source_clasification[grep("Motorcycles", source_clasification$Short.Name),"SCC"])
motor_sources <- union(vehicles.scc,motorcycle.scc)

motor.summary <- summary_pm25[which(summary_pm25$SCC %in% motor_sources),]

baltimore_california_motor <- motor.summary[which(motor.summary$fips == "24510" | motor.summary$fips == "06037"),]

baltimore_california_motor$city <- ifelse(baltimore_california_motor$fips == "24510","Baltimore","Los Angeles County")

jpeg('plot6.png')
qplot(baltimore_california_motor$year,baltimore_california_motor$Emissions,data = baltimore_california_motor,facets = .~city,geom = "path",
      xlab = "",ylab = "Emissions (tons)")
dev.off()