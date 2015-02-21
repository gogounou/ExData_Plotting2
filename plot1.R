## Check if zip file is already downloaded. If not download to working directory.
zipdl <- "particulate_matter_pollution.zip"
if (!file.exists(zipdl)) {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                      destfile=zipdl, method="curl")
}

## Unzip the file
unzip(zipdl)

## Check to see if data is already loaded. If not, load data.
if (!"nei" %in% ls()) {
        nei <- readRDS("summarySCC_PM25.rds")
}
if (!"scc" %in% ls()) {
        scc <- readRDS("Source_Classification_Code.rds")
}

## Sum for total emissions
totalEmissions <- aggregate(nei$Emissions, by=list(nei$year), FUN="sum")

## Create the plot
png(filename="plot1.png", width=480, height=480)
plot(totalEmissions, type="l", xlab="Year", 
     main="Total PM2.5 Emissions in the United States\n1999 to 2008", 
     ylab="Emissions (tons)")
dev.off()