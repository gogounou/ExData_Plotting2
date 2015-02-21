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

## Isolate coal-related pollution sources
coal_scc <- scc[(grep("coal", scc$Short.Name, ignore.case=T)), ]
coal_nei <- nei[nei$SCC %in% coal_scc$SCC,]

## Sum for coal emissions
coalEmissions <- aggregate(coal_nei$Emissions, by=list(coal_nei$year), FUN="sum")

## Create the plot
png(filename="plot4.png", width=480, height=480)
plot(coalEmissions, type="l", xlab="Year", 
     main="Total Coal-Related PM2.5 Emissions in the United States\n1999 to 2008", 
     ylab="Emissions (tons)")
dev.off()