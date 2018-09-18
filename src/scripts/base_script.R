# gi-ws-06 example control script 
# MOC - Advanced GIS (T. Nauss, C. Reudenbach)
#
# setup working environment 
# provides LiDAR functionality 
# calculate some basic diversity indices
# see also: https://github.com/logmoc/msc-phygeo-class-of-2017-creuden

######### setup the environment -----------------------------------------------
# library requirements
require(link2GI)
require(gdalUtils)
require(raster)


# define project folder

filepath_base<-"~/lehre/msc/active/msc-2017/msc-phygeo-class-of-2017-creuden/"

# define the actual course session
activeSession<-6

# define the used input file(s)
inputFile<- "geonode-lidar_dem_01m.tif"

# make a list of all functions in the corresponding function folder
sourceFileNames <- list.files(pattern="[.]R$", path=paste0(filepath_base,"fun"), full.names=TRUE)

# source all functions
res<- sapply(sourceFileNames, FUN=source)

# if at a new location create filestructure
createMocFolders(filepath_base,ccourse = "gi",csess = activeSession)

# get the global path variables for the current session
getSessionPathes(filepath_git = filepath_base, sessNo = activeSession,courseCode = "gi")

# set working directory
setwd(pd_gi_run)

######### set extra vars ------------------------------------------------------------
## Fusion binary folder
Fusion<-"wine /home/creu/.wine/dosdevices/c:/FUSION/"
ext <- "478000.0000,5624000.0000,478999.9900,5624999.9900"

######### initialize the external GIS packages --------------------------------

# check GDAL binaries and start gdalUtils
gdal<- link2GI::linkgdalUtils()




########## platform stuff
# Create a list containing the las files in the input folder
las_files<-list.files(pd_gi_input, pattern=".las$", full.names=TRUE,recursive = TRUE) 

cmd <- "wine \home\creu\.wine\dosdevices\c:\FUSION\catalog.exe "
if (Sys.info()["sysname"] == "Linux"){
  file.copy(las_files,pd_gi_run)
  pi<-pd_gi_input
  pr<-pd_gi_run
  p0<-pd_gi_output
  pd_gi_input<-""
  pd_gi_run <- ""
  pd_gi_output <-""
  
}


######### START of the thematic stuff ----------------------------------------


######### start core script     -----------------------------------------------

### read data 
