library(data.table)
setwd("E:/Coursera - Exploratory Analysis/exdata-data-household_power_consumption")
DT<-fread("household_power_consumption.txt")
DT2<-subset(DT, as.Date(Date,"%d/%m/%Y") >= '2007-02-01' & as.Date(Date,"%d/%m/%Y") <= '2007-02-02')

hist(as.numeric(DT2$Global_active_power),col="red",xlab="Global Active Power (kilowatts)", main="Global Active Power")

dev.copy(png,file="plot1.png")
dev.off()