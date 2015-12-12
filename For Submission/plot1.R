#Setting the woeking directory to the directory the script is run from
CurrentScriptDirectory = script.dir <- dirname(sys.frame(1)$ofile)
setwd(CurrentScriptDirectory)

##Creating a directory for the data and codebook if no such directory exists
if(!file.exists("data"))
{
  dir.create("data")
  ##Downloading the files
}

datafileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dataFileLocation <- "./data/ElectricPowerConsumption.zip"
if(!file.exists(dataFileLocation))
{
  download.file(datafileUrl,destfile = dataFileLocation) 
}

library(dplyr)
library(lubridate)

#header = true so it will read the first row as names and not part of the data
table <- read.table(unz(dataFileLocation,"household_power_consumption.txt"),
                    sep = ";",header = TRUE,na.strings = "?")
table <- as.tbl(table) #so we can use dplyr
relaventData <-  mutate(table,Date = as.character(Date)) %>%
  filter(dmy(Date)==dmy("01/02/2007") | dmy(Date) == dmy("02/02/2007"))

#Procude first plot

#Starting a png device with the requested dimensions 
png("plot1.png", width = 480, height = 480, units = "px", bg = "white")
par(mar= c(4, 4, 2, 1))

with(relaventData,hist(Global_active_power,
                       col = "red",xlab = "Global Active Power (Kilowatts)",
                       main = "Global Active Power"))
dev.off()