# --------------------
#    Graph 5
# --------------------

options(scipen = 999)
library(reshape)
library(lubridate)
library(ggplot2)

setwd("C:/Users/paulomauricio/Documents/Jhon's Hopkins/Exploratory data analysis")

source_clasification <- readRDS("Source_Classification_Code.rds")
summary_pm25         <- readRDS("summarySCC_PM25.rds")
summary_pm25$year    <- as.character(summary_pm25$year)

summary_pm25$plot5 <- "Plot5"
vehicles.scc <- as.character(source_clasification[grep("Vehicles", source_clasification$Short.Name),"SCC"])
motorcycle.scc <- as.character(source_clasification[grep("Motorcycles", source_clasification$Short.Name),"SCC"])
motor_sources <- union(vehicles.scc,motorcycle.scc)

motor.summary <- summary_pm25[which(summary_pm25$SCC %in% motor_sources),]

baltimore_motor <- motor.summary[which(motor.summary$fips == "24510"),]

jpeg('plot5.png')
qplot(baltimore_motor$year,baltimore_motor$Emissions,data = baltimore_motor,geom = "path",
      xlab = "",ylab = "Emissions (tons)",main = "Motor vehicle emissions (Baltimore)")
dev.off()
