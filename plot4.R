####################################
# read the data from the zipped file
####################################
setClass('myDate')
setAs("character", "myDate", function(from) as.Date(from, format="%d/%m/%Y") )
hpData <- read.table(unz("data/exdata_data_household_power_consumption.zip", "household_power_consumption.txt")
                     , header = TRUE, stringsAsFactors = FALSE, quote="\"", sep=";"
                     , colClasses = c('myDate', rep('character', 8)))
####################################
# PROCESS DATA
# restrict to dates of interest
####################################
appData <- with(hpData, {
  out <- Date %in% as.Date(c("2007-02-01", "2007-02-02"))
  hpData[out, ]
}
)
appData[, 3:9] <- lapply(3:9, function(x){as.numeric(appData[,x])})
appData<- within(appData,{
  datetime <- paste(Date, Time)
  datetime <- strptime(datetime, "%Y-%m-%d %H:%M:%S")
})

####################################
# Produce the 4 plots
# First the "Global Active Power"
####################################
par(mfrow=c(2,2), mar=c(3,4,1.5,1.5), oma=c(1,1,1,1), mai=c(0.6,0.6,0.1,0.1))
plot(x = appData$datetime, y = appData$Global_active_power
     , type = "l", ylab = "Global Active Power"
     , cex.lab = 0.5, xlab = '', cex.axis = 0.4, mgp = c(2, 1, 0))


####################################
# Second the "Voltage"
####################################
plot(x = appData$datetime, y = appData$Voltage
     , type = "l", ylab = "Voltage"
     , cex.lab = 0.5, xlab = "datetime", cex.axis = 0.4, mgp = c(2, 1, 0))

####################################
# Third the "Energy sub metering"
####################################
plot(x = appData$datetime, y = appData$Sub_metering_1
     , type = "l", ylab = "Energy sub metering"
     , cex.lab = 0.5, xlab = "", cex.axis = 0.4, mgp = c(2, 1, 0))
lines(x = appData$datetime, y = appData$Sub_metering_2, col = "red")
lines(x = appData$datetime, y = appData$Sub_metering_3, col = "blue")
l = legend(list(x = c(as.POSIXct("2007-02-01 23:45:00"), as.POSIXct("2007-02-02 23:59:00"))
                , y = c(39, 30)
)
, c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
, col = c("black", "red", "blue"), lty = c(1, 1, 1)
, cex=0.55, seg.len=3,  bty = "n")

####################################
# Finally the "Global_reactive_power"
####################################
plot(x = appData$datetime, y = appData$Global_reactive_power
     , type = "l", ylab = "Global_reactive_power"
     , cex.lab = 0.5, cex.axis = 0.4
     , xlab = "datetime", mgp = c(2, 1, 0))


####################################
# Write to file
####################################
dev.copy(png, width = 480, height = 480, file = "plot4.png") # explicitly state width/height
dev.off()


