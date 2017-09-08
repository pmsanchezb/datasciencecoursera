# --------------------
#    Graph 4
# --------------------

options(scipen = 999)
library(reshape)
library(dplyr)

setwd("C:/Users/paulomauricio/Documents/Jhon's Hopkins/Exploratory data analysis")

source_clasification <- readRDS("Source_Classification_Code.rds")
summary_pm25         <- readRDS("summarySCC_PM25.rds")
summary_pm25$year    <- as.character(summary_pm25$year)

summary_pm25$plot1 <- "Plot1"
fuel.scc <- as.character(source_clasification[grep("Fuel Comb", source_clasification$EI.Sector),"SCC"])

fuel.summary <- summary_pm25[which(summary_pm25$SCC %in% fuel.scc),]

fuel.summary <-melt(fuel.summary)

coal_emissions <- cast(fuel.summary,year ~ plot1,fun.aggregate = sum,
                        value.var = fuel.summary$Emissions)
coal_emissions$Plot1 <- coal_emissions$Plot1/1000000 

jpeg('plot4.png')
plot(coal_emissions$year,coal_emissions$Plot1,ylab = "Emissions (millions of tons)",
     main="Emissions from coal-combustion",col="blue",type="l",xlab = "")
dev.off()
