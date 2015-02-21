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

##Subset for Baltimore City (fips 24510) and On-Road emissions type
BCLA_onroad <- nei[(nei$fips == "24510" & nei$type == "ON-ROAD") 
                 | (nei$fips == "06037" & nei$type == "ON-ROAD"), ]

## Load ggplot library and create plot
library(ggplot2)

png(filename='plot6.png', width=480, height=480, units='px')
plot6 <- ggplot(BCLA_onroad, aes(year, Emissions, color=fips))
plot6 + geom_line(stat = "summary", fun.y = "sum") +
        ylab("Emissions (tons)") +
        ggtitle("Motor Vehicle PM2.5 Emissions in Baltimore City, MD\n and Los Angeles County - 1999 to 2008") +
        scale_color_discrete(name = "Region", label = c("Los Angeles County","Baltimore City"))
dev.off()