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
epc2 <- read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE)

##Adjust the Date info and select the period analysed

epc2$Date <- dmy(epc2$Date)

epc2$Date <- as.Date(epc2$Date)

epc2 <- epc2[epc2$Date >= as.Date("2007-02-01") & epc2$Date <= as.Date("2007-02-02"),]
epc2 <- mutate(epc2, DateFull = as.POSIXct(paste(Date, as.character(Time)), format="%Y-%m-%d %H:%M:%S"))

##transform the data into a numeric value
epc2$Global_active_power <- as.numeric(as.character(epc2$Global_active_power))

##Set the environment to plot
par(mfrow = c(1,1))

##Plot the chart
with(epc2, plot(DateFull, Global_active_power, type="l",  main = "" , xlab = "", ylab = "Global Active Power (kilowatts)"))

##Save the file in PNG format
dev.copy(png, file="./data/plot2.png", width=480,height=480,units="px")
dev.off()