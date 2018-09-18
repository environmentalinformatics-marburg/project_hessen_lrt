# Set path ---------------------------------------------------------------------
if(Sys.info()["sysname"] == "Windows"){
  filepath_base <- "C:/Users/tnauss/permanent/plygrnd/hessen_wald_lrt/"
} else {
  filepath_base <- "/media/permanent/active/hessen_wald_lrt/"
}

path_fun <- paste0(filepath_base, "project_hessen_lrt/src/fun/")
path_data <- paste0(filepath_base, "data/")
path_landsat <- paste0(path_data, "landsat/")
path_lrt <- paste0(path_data, "lrt/")
path_temp <- paste0(path_data, "temp/")
path_rdata <- paste0(path_data, "rdata/")


# Set libraries ----------------------------------------------------------------
library(doParallel)
library(gpm)
library(ggplot2)
library(mapview)
library(rPointDB)
library(raster)
library(rgdal)
library(rgeos)
library(sp)

# Other settings ---------------------------------------------------------------
rasterOptions(tmpdir = path_temp)

saga_cmd <- "C:/OSGeo4W64/apps/saga/saga_cmd.exe "
# initOTB("C:/OSGeo4W64/bin/")
initOTB("C:/OSGeo4W64/OTB-5.8.0-win64/OTB-5.8.0-win64/bin/")


