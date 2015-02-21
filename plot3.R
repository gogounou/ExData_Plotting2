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

##Subset for Baltimore City (fips 24510)
BCdata <- nei[nei$fips == "24510", ]

## Load ggplot library and create plot
library(ggplot2)

png(filename='plot3.png', width=480, height=480, units='px')
plot3 <- ggplot(BCdata, aes(year, Emissions, color=type))
plot3 + geom_line(stat="summary", fun.y="sum") +
        ylab("Emissions (tons)") +
        ggtitle("Total PM2.5 Emissions in Baltimore City, MD\n1999 to 2008")
dev.off()