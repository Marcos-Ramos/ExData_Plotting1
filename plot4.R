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
epc4 <- read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE)

##Adjust the Date info and select the period analysed

epc4$Date <- dmy(epc4$Date)

epc4$Date <- as.Date(epc4$Date)

epc4 <- epc4[epc4$Date >= as.Date("2007-02-01") & epc4$Date <= as.Date("2007-02-02"),]
epc4 <- mutate(epc4, datetime = as.POSIXct(paste(Date, as.character(Time)), format="%Y-%m-%d %H:%M:%S"))

##Prepare the environment to plot the charts.
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1))


##transform the data into a numeric value
epc4$Global_active_power <- as.numeric(as.character(epc4$Global_active_power))

##Plot the chart #1
with(epc4, plot(datetime, Global_active_power, type="l",  main = "" , xlab = "", ylab = "Global Active Power"))

##Plot the chart #2
epc4$Voltage <- as.numeric(as.character(epc4$Voltage))
with(epc4, plot(datetime, Voltage, type="l",  main = ""))


##Plot the chart #3
epc4$Sub_metering_1 <- as.numeric(as.character(epc4$Sub_metering_1))
epc4$Sub_metering_2 <- as.numeric(as.character(epc4$Sub_metering_2))
epc4$Sub_metering_3 <- as.numeric(as.character(epc4$Sub_metering_3))

plot(epc4$datetime, epc4$Sub_metering_1, col = "black", type="l",  main = "" , xlab = "", ylab = "Energy sub metering")
lines(epc4$datetime, epc4$Sub_metering_2, col = "red", type = "l")
lines(epc4$datetime, epc4$Sub_metering_3, col = "blue", type = "l")
legend("topright", legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lwd=1, cex=0.5, bty = "n")


##Plot the chart 4
epc4$Global_reactive_power <- as.numeric(as.character(epc4$Global_reactive_power))
with(epc4, plot(datetime, Global_reactive_power, type="l",  main = ""))


##Save the file in PNG format
dev.copy(png, file="./data/Plot4.png", width=480,height=480,units="px")
dev.off()