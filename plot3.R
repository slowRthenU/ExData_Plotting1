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
# Produce the line plot
####################################
plot(x = appData$datetime, y = appData$Sub_metering_1
     , type = "l", ylab = "Energy sub metering"
     , xlab = "")
lines(x = appData$datetime, y = appData$Sub_metering_2, col = "red")
lines(x = appData$datetime, y = appData$Sub_metering_3, col = "blue")
l = legend(list(x = c(as.POSIXct("2007-02-02 12:45:00"), as.POSIXct("2007-02-02 23:59:00"))
            , y = c(39, 30)
            )
       , c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
       , col = c("black", "red", "blue"), lty = c(1, 1, 1)
       , cex=0.45, seg.len=3)
dev.copy(png, width = 480, height = 480, file = "plot3.png") # explicitly state width/height
dev.off()


