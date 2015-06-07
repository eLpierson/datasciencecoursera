## Source 'load_power_consumption.R'
source("load_power_consumption.R")
png(filename = "plot2.png", 
     width = 480, height = 480,
     units = "px", bg = "transparent")
plot(DateTime, Global_active_power, 
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)")
dev.off()