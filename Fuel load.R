#######################################################################################
##################################### Fuel load data ##################################
#######################################################################################

#set the working directory
setwd("D:/IIASA_2024/File/data")

#Load the packages 
library(terra)
library(raster)
library(sf)

# Load the raster data (AGB)
agb <- raster("fuel/Cat_AGB_2010.tif")

# Print the CRS of the raster data (AGB)
crs(agb)

# Load the second raster data (Catalonia)
cat <- raster("fuel/Cat.tif")

# Print the CRS of the second raster data (Catalonia)
crs(cat)

# Set the extent of the AGB raster to match the extent of the Catalonia raster
agb_crs <- projectRaster(agb, cat)

# Print the CRS of the transformed raster data (AGB)
crs(agb_crs)

# Save the raster file with the corrected CRS
writeRaster(agb_crs, filename="agb_cat.tif", format="GTiff", overwrite=TRUE)

#################################

# Load the saved raster file
agb <- raster("agb_cat.tif")

# Set random seed for reproducibility
set.seed(1234)

# Creating random points
pts <- sampleRandom(agb, n = 200, sp = TRUE)

# Print the first few rows of the points
head(pts)

# Export the points to a CSV file
write.csv(pts, "pts.csv", row.names = FALSE)

# Read the points back from the CSV file
pts <- read.csv('pts.csv')

# Extract AGB values for random points
agb_values <- extract(agb, pts)

# Print the extracted AGB values
print(agb_values)


