
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
epc1 <- read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE)

##Adjust the Date info and select the period analysed
epc1$Date <- dmy(epc1$Date)

epc1$Date <- as.Date(epc1$Date)

epc1 <- epc1[epc1$Date >= as.Date("2007-02-01") & epc1$Date <= as.Date("2007-02-02"),]

##transform the data into a numeric value
epc1$Global_active_power <- as.numeric(as.character(epc1$Global_active_power))


##Set the environment to plot
par(mfrow = c(1,1))

##Plot the chart
with(epc1, hist(as.numeric(Global_active_power), main = "Global Active Power" , xlab = "Global Active Power (kilowatts)", col = "red"))

##Save the file in PNG format
dev.copy(png, file="./data/plot1.png", width=480,height=480,units="px")
dev.off()