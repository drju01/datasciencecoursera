library(data.table)
setwd("E:/Coursera - Exploratory Analysis/exdata-data-household_power_consumption")
DT<-fread("household_power_consumption.txt")
DT2<-subset(DT, as.Date(Date,"%d/%m/%Y") >= '2007-02-01' & as.Date(Date,"%d/%m/%Y") <= '2007-02-02')

par(mfrow=c(2,2),mar=c(4,4,2,1))
with(DT2,plot(strptime(paste(Date,Time),"%d/%m/%Y %H:%M:%S"),Global_active_power,type="l",xlab="",ylab="Global Active Power (kilowatts)"))

with(DT2,plot(strptime(paste(Date,Time),"%d/%m/%Y %H:%M:%S"),Voltage,type="l",xlab="datetime",ylab="Voltage"))

with(DT2,plot(strptime(paste(Date,Time),"%d/%m/%Y %H:%M:%S"),Sub_metering_1,type="l",xlab="",ylab="Energy submetering"))
with(DT2,lines(strptime(paste(Date,Time),"%d/%m/%Y %H:%M:%S"),Sub_metering_2,type="l",col="red"))
with(DT2,lines(strptime(paste(Date,Time),"%d/%m/%Y %H:%M:%S"),Sub_metering_3,type="l",col="blue"))
with(DT2,legend("topright",pch="-",col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3")))

with(DT2,plot(strptime(paste(Date,Time),"%d/%m/%Y %H:%M:%S"),Global_reactive_power,type="l",xlab="datetime",ylab="Global_reactive_power"))

dev.copy(png,file="plot4.png")
dev.off()