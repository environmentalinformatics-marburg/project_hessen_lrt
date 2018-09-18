source("C:/Users/tnauss/permanent/plygrnd/hessen_wald_lrt/project_hessen_lrt/src/fun/00_set_environment.R")


# Read polygons
plg = readOGR(paste0(path_lrt, "/GDE_Wald_LRT.shp")) 
plg = spTransform(plg, CRS="+init=epsg:25832")
# mapview(plg)

plg_buffer = gBuffer(plg, byid = TRUE, width = -15, quadsegs = 5)
plg_buffer$area = area(plg_buffer)
plg_buffer_minarea = plg_buffer[which(plg_buffer$area >= 2700), ]
# mapview(plg_buffer) + plg
# table(plg_buffer_minarea$LRT[plg_buffer_minarea$WST == "A"])
# saveRDS(plg_buffer_minarea, paste0(path_rdata, "/plg_buffer_minarea.rds"))

plg_grid = lapply(seq(length(plg_buffer_minarea)), function(i){
  plg_grid = spsample(plg_buffer_minarea[i,], nsig = 2, cellsize = 15, 
                      offset = c(0.5, 0.5), pretty = TRUE, type = "regular")
  
  df = plg_buffer_minarea[i,]@data
  df = df[rep(row.names(df), length(plg_grid)), 1:46]
  plg_grid = SpatialPointsDataFrame(plg_grid, df)
  saveRDS(plg_grid, paste0(path_rdata, "/plot_grid_", sprintf("name_%04d", i), ".rds"))
  return(plg_grid)
})
# saveRDS(plg_grid, paste0(path_rdata, "/plot_grid.rds"))


areas_of_pois = lapply(plg_grid, function(p){
  pois = as.data.frame(p@coords)
  areas_of_pois <- mapply(
    function(x, y){return(extent_diameter(x=x, y=y, d=30))}, 
    pois$x1, pois$x2
  )
  return(areas_of_pois)
})
# saveRDS(areas_of_pois, paste0(path_rdata, "/areas_of_pois.rds"))
# areas_of_pois = readRDS(paste0(path_rdata, "/areas_of_pois.rds"))

# get one pointdb
remotesensing <- RemoteSensing$new("http://137.248.191.215:8081", "ag-ui:XG293SSd") # remote server
remotesensing$pointdbs
pointdb <- remotesensing$pointdb("hessen_hlnug")


functions <- c("BE_FHD", "BE_H_MAX", "BE_H_MEDIAN", "BE_H_SD", "BE_H_SKEW", "TCH", 
               "BE_PR_CAN", "BE_PR_REG", "BE_PR_UND",
               "surface_intensity_sd", 
               "chm_surface_ratio", "dsm_surface_ratio", 
               "vegetation_coverage_01m", "vegetation_coverage_02m", 
               "vegetation_coverage_05m", "vegetation_coverage_10m")

pois_indices = lapply(seq(10), function(i){
  areas = areas_of_pois[[i]]
  df <- pointdb$process(areas=areas, functions=functions)
})



# 
# plg_gird_lidar = plg_grid[[1]]
# plg_gird_lidar@data = cbind(plg_grid[[1]]@data, df) 
# 
# 
# plg_gird_lidar
# 
# nrow(plg_grid[[1]]@data)
# nrow(df)
# 
# t
# 
# # all_functions <-  pointdb$processing_functions
# functions <-  c("BE_H_MAX", "BE_H_P20", "pulse_density")
# 
# 
# df <- pointdb$process(areas=areas, functions=functions)
# 
# 
# c("BE_FHD", "BE_H_MAX", "BE_H_MEDIAN", "BE_H_SD", "BE_H_SKEW", "TCH", 
#   "BE_PR_CAN", "BE_PR_REG", "BE_PR_UND",
#   "surface_intensity_sd", 
#   "chm_surface_ratio", "dsm_surface_ratio", 
#   "vegetation_coverage_01m", "vegetation_coverage_02m", 
#   "vegetation_coverage_05m", "vegetation_coverage_10m")
# 
# 
# 
# names(df)
# 
# 
# 
# 
# 
# 
# 
# areas <- areas_of_pois
# 
# df <- pointdb$process(areas=areas, functions=functions)
# 
# names(df)

