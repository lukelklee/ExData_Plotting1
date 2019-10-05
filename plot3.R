

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists("./household_power_consumption.zip")) {download.file(fileUrl, destfile = "./household_power_consumption.zip")}

fileCon <- unz("./household_power_consumption.zip", "household_power_consumption.txt")
idxSelect <- grep("^[1-2]/2/2007", readLines(fileCon))
idxSkip <- idxSelect[1] - 1
idxNRows <- idxSelect[length(idxSelect)] - idxSkip
close(fileCon)

# Note that some functions such as read.table will close file connection
# automatically when they finish; so it's safer to establish the file
# connection using unz(..., ...) everytime before using read.table. 

# Extract the first row of the text file as the variable/column names
dfHeader <- read.table(unz("./household_power_consumption.zip", "household_power_consumption.txt"), header = F, sep = ";", colClasses = "character", nrows = 1)
# Extract the 1/2/2007 and 2/2/2007 rows from the text file
df2Days <- read.table(unz("./household_power_consumption.zip", "household_power_consumption.txt"), header = F, sep = ";", colClasses = "character", skip = idxSkip, nrows = idxNRows, col.names = dfHeader)

# Add a new column/variable "DateTime" that combines the "Date" and "Time" column.
df2Days$DateTime <- strptime(paste(df2Days$Date, df2Days$Time, sep = " "), "%d/%m/%Y %H:%M:%S")
# Coerce the columns 3 - 7 that are supposed to have numeric data.
for (i_col in 3:9) {df2Days[, i_col] <- as.numeric(df2Days[, i_col])}



### Plot 3

with(df2Days, plot(DateTime, Sub_metering_1, xlab = "Date & Time", ylab = "Energy Sub-Metering (watt-hours)", type = "n"))
with(df2Days, lines(DateTime, Sub_metering_1, col = "black"))
with(df2Days, lines(DateTime, Sub_metering_2, col = "red"))
with(df2Days, lines(DateTime, Sub_metering_3, col = "blue"))
legend("topright", lty = c(1, 1, 1), col = c("black", "red", "blue"), legend = colnames(df2Days)[7:9])

dev.copy(png, file = "./plot3.png", width = 480, height = 480)
dev.off()




