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
BC_onroad <- nei[nei$fips == "24510" & nei$type == "ON-ROAD", ]

## Sum for on-road emissions
BC_onroad_emissions <- aggregate(BC_onroad$Emissions, by=list(BC_onroad$year),
                                 FUN="sum")

## Create the plot
png(filename="plot5.png", width=480, height=480)
plot(BC_onroad_emissions, type="l", xlab="Year", 
     main="Motor Vehicle PM2.5 Emissions in Baltimore City, MD\n1999 to 2008", 
     ylab="Emissions (tons)")
dev.off()