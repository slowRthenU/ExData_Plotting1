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
# PRODUCE THE HISTOGRAM
####################################
hist(appData$Global_active_power, col = "red"
     , main = "Global Active Power", xlab = "Global Active Power (kilowatts)"
     , ylab = "Frequency")
dev.copy(png, width = 480, height = 480, file = "plot1.png") # explicitly state width/height
dev.off()

