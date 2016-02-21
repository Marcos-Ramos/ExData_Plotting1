##Install the library to run the script.
require("plyr",character.only = TRUE)
require("dplyr",character.only = TRUE)
require("lubridate",character.only = TRUE)
library(plyr)
library(dplyr)
library(lubridate)

##if the data is not available:
##Download the data from source website.######################################################

if(!file.exists("./data/household_power_consumption.txt")) {
  ##Verify if there a data directory in the working directory, if no, create a new directory.
  if(!file.exists("./data")){dir.create("./data")}
  
  ##download the data files from the source
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, dest="./data/EPC.zip", mode="wb") 
  
  ##Extract the data file from the zip file
  unzip ("./data/EPC.zip", exdir = "./data")
}

##Load the data from the file
epc3 <- read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE)

##Adjust the Date info and select the period analysed

epc3$Date <- dmy(epc3$Date)

epc3$Date <- as.Date(epc3$Date)

epc3 <- epc3[epc3$Date >= as.Date("2007-02-01") & epc3$Date <= as.Date("2007-02-02"),]
epc3 <- mutate(epc3, DateFull = as.POSIXct(paste(Date, as.character(Time)), format="%Y-%m-%d %H:%M:%S"))

##transform the data into a numeric value
epc3$Sub_metering_1 <- as.numeric(as.character(epc3$Sub_metering_1))
epc3$Sub_metering_2 <- as.numeric(as.character(epc3$Sub_metering_2))
epc3$Sub_metering_3 <- as.numeric(as.character(epc3$Sub_metering_3))

##Set the environment to plot
par(mfrow = c(1,1))

##Plot the chart
plot(epc3$DateFull, epc3$Sub_metering_1, col = "black", type="l",  main = "" , xlab = "", ylab = "Energy sub metering")
lines(epc3$DateFull, epc3$Sub_metering_2, col = "red", type = "l")
lines(epc3$DateFull, epc3$Sub_metering_3, col = "blue", type = "l")
legend("topright", legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lwd=1, cex=0.7)

##Save the file in PNG format
dev.copy(png, file="./data/Plot3.png", width=480,height=480,units="px")
dev.off()