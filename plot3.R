CreatePlot3 <- function(){
  dataSource <- paste0(getwd(),"/household_power_consumption.txt")
  
  if(!(file.exists(dataSource))){
    
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    tempZipFile <- paste0(getwd(), "/temp.zip")
    # Download the zipfile if the data is not present
    # Check the Operating System for the propper download command
    if (Sys.info()['sysname'] == "Windows"){
      download.file(fileUrl, tempZipFile)
    } else {
      download.file(fileUrl, tempZipFile, method = "curl")
    }
    
    # Unzipped the files
    unzip(tempZipFile)
    
    # Removing the temporary zip file being downloaded
    file.remove(tempZipFile)
  }
  
  plotData <- read.table(dataSource, sep = ";", skip = 66637, nrows = 2880)
  colnames(plotData)<-c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")
  
  plotData$Date <- as.Date(plotData$Date, format = "%d/%m/%Y")
  plotData$datetime <- strptime(paste(plotData$Date, plotData$Time), "%Y-%m-%d %H:%M:%S")
  plotData$Sub_metering_1 <- as.numeric(plotData$Sub_metering_1)
  plotData$Sub_metering_2 <- as.numeric(plotData$Sub_metering_2)
  plotData$Sub_metering_3 <- as.numeric(plotData$Sub_metering_3)
  
  # Create plot
  png("plot3.png", width=480, height=480)
  
  with(plotData, plot(plotData$datetime,plotData$Sub_metering_1, type="n", xlab = "", ylab = "Energy Sub Metering"))
  with(plotData, points(plotData$datetime,plotData$Sub_metering_1, col="black", type="l"))
  with(plotData, points(plotData$datetime,plotData$Sub_metering_2, col="red", type="l"))
  with(plotData, points(plotData$datetime,plotData$Sub_metering_3, col="blue", type="l"))
  legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, col=c("black", "red", "blue"))
  
  # Saving the PNG Chart
  dev.off()
}
