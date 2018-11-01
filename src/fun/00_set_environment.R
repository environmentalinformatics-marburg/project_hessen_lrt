# Set libraries ----------------------------------------------------------------
libs = c("doParallel",
         "gpm",
         "ggplot2",
         "link2GI",
         "mapview",
         "rPointDB",
         "raster",
         "rgdal",
         "rgeos",
         "sp")

lapply(libs, require, character.only = TRUE)

# Set path ---------------------------------------------------------------------
if(Sys.info()["sysname"] == "Windows"){
  filepath_base = "C:/Users/tnauss/permanent/plygrnd/hessen_wald_lrt/"
} else {
  projRootDir = "/media/permanent/active/hessen_wald_lrt/"
}

project_folders = c("data/", "data/sentinel/", "data/lidar/",
                    "data/lrt/org/", "data/lrt/20_lrt_buffered/",
                    "data/tmp/", "data/rdata/",
                    "project_hessen_lrt/src/fun/")

GRASSlocation = paste0(projRootDir, "/data/tmp/")

envrmt = initProj(projRootDir = filepath_base , projFolders = project_folders,
         path_prefix = "path_", global = FALSE)

# Other settings ---------------------------------------------------------------
rasterOptions(tmpdir = envrmt$path_data_tmp)

saga_cmd <- "C:/OSGeo4W64/apps/saga/saga_cmd.exe "
# initOTB("C:/OSGeo4W64/bin/")
# initOTB("C:/OSGeo4W64/OTB-5.8.0-win64/OTB-5.8.0-win64/bin/")


