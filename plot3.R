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

#Plot 3
relaventData <-  mutate(relaventData,DayOfWeek = wday(dmy(Date))) #adding a weekday column  
#Starting a png device with the requested dimensions
png("plot3.png", width = 480, height = 480, units = "px", bg = "white")
par(mar= c(4, 4, 2, 1))

#xaxt - removes the ticks on the x axis
with(relaventData,plot(Sub_metering_1,type = "l",xaxt="n",xlab = "",ylab="Energy sub metering",col="black"))
with(relaventData,points(Sub_metering_2,type = "l",col="red"))
with(relaventData,points(Sub_metering_3,type = "l",col="blue"))
#adding ticks - the first parameter means the x axis, we add three points - at the beginning of the data, at the start of Friday and at the end of the data					   
axis(1, at=c(0,count(select(relaventData,DayOfWeek) %>% 
                       filter(DayOfWeek == 5)),length(relaventData$Global_active_power)),
     labels=c("Thu","Fri","Sat"))
legend("topright", lty = c(1,1,1), col = c("black", "red","blue"),
       legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))

dev.off()
