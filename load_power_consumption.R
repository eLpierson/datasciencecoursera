## Load Household Power Consumption Dataset
filename <- "./household_power_consumption.txt"
dat <- read.table(filename,
                   header = TRUE,
                   sep = ";",
                   colClasses = c("character", "character", rep("numeric",7)),
                   na = "?")
attach(dat)
## Subset 2 Days of Data
subset <- Date == "1/2/2007" | Date == "2/2/2007"
sub_dat <- dat[subset, ]
attach(sub_dat)
x <- paste(Date, Time)
sub_dat$DateTime <- strptime(x, "%d/%m/%Y %H:%M:%S")
rownames(sub_dat) <- 1:nrow(sub_dat)
attach(sub_dat)