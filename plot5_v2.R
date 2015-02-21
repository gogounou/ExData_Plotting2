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

## Isolate vehicle-related pollution sources
vehic_scc <- scc[(grep("highway veh", scc$Short.Name, ignore.case=T)), ]
BCvehic_nei <- BCdata[BCdata$SCC %in% vehic_scc$SCC,]

## Sum for on-road emissions
BC_onroad_emissions <- aggregate(BCvehic_nei$Emissions,
                                 by=list(BCvehic_nei$year), FUN="sum")

## Create the plot
png(filename="plot5_v2.png", width=480, height=480)
plot(BC_onroad_emissions, type="l", xlab="Year", 
     main="Motor Vehicle PM2.5 Emissions in Baltimore City\n1999 to 2008", 
     ylab="Emissions (tons)")
dev.off()