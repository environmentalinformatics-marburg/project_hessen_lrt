source("C:/Users/tnauss/permanent/plygrnd/hessen_wald_lrt/project_hessen_lrt/src/fun/00_set_environment.R")


# Read lrt polygons
lrt_data_file = list.files(envrmt$path_data_lrt_org, 
                           pattern = glob2rx("GDE*.shp"), full.names = TRUE)
plg = readOGR(lrt_data_file) 
plg = spTransform(plg, CRS="+init=epsg:25832")
plg$LRTKlassen = NA
plg$LRTKlassen[plg$LRT %in% c("9110", "9130")] = "Buchen"
plg$LRTKlassen[plg$LRT %in% c("9150", "9160", "9170", "9190")] = "Eichen"
plg$LRTKlassen[plg$LRT %in% c("*9180")] = "Schlucht_Hangmischwald"
plg$LRTKlassen[plg$LRT %in% c("*91D1")] = "Birken_Moorwald"
plg$LRTKlassen[plg$LRT %in% c("*91E0", "91E0")] = "Auenwald"
plg$LRTKlassen[plg$LRT %in% c("91F0")] = "Hartholz_Auenwald"
plg$LRTKlassen[plg$LRT %in% c("*91D2")] = "Hartholz_Auenwald"
plg$LRTKlassen = factor(plg$LRTKlassen)
plg$LRTKlassenWST = factor(paste0(plg$LRTKlassen, "_", plg$WST))
# head(lrt_data_file)


# Buffer lrt areas (reduce area to allow 60 m range selection later)
plg_buffer = gBuffer(plg, byid = TRUE, width = -30, quadsegs = 5)
plg_buffer$area = area(plg_buffer)
plg_buffer_minarea = plg_buffer[which(plg_buffer$area >= 3600), ]
# mapview(plg_buffer) + plg
# table(plg_buffer_minarea$LRTKlassenWST)
# saveRDS(plg_buffer_minarea, paste0(path_rdata, "/plg_buffer_minarea.rds"))

plg_buffer_minarea = plg_buffer_minarea[, colnames(plg_buffer_minarea@data) %in% 
                                          c("OBJECTID","FFH_NR", "JAHR", "FLAECHE_NR", "RWERT",
                                            "HWERT", "AREA", "LRT", "WST", "LRTKlassen", "LRTKlassenWST", 
                                            "area")]

plg_grids = lapply(seq(nrow(plg_buffer_minarea)), function(i){
  set.seed(20180225)
  plg_grid = spsample(plg_buffer_minarea[i,], nsig = 2, cellsize = 50,
                     offset = c(0.5, 0.5), pretty = FALSE, type = "stratified")
  # mapview(plg_grid) + plg_buffer_minarea[i,]
  df = data.frame(BufferID = sprintf("BufferID_%04d", i), plg_buffer_minarea[i,]@data)
  df = df[rep(row.names(df), length(plg_grid)), 1:12]
  plg_grid = SpatialPointsDataFrame(plg_grid, df)
  # saveRDS(plg_grid, paste0(path_rdata, "/plot_grid_", sprintf("name_%04d", i), ".rds"))
  return(plg_grid)
})

saveRDS(plg_grids, paste0(envrmt$path_data_lrt_20_lrt_buffered, "/plot_grids.rds"))

plg_grids_df = lapply(plg_grids, function(g){
  as.data.frame(g)
})
plg_grids_df = do.call("rbind", plg_grids_df)

saveRDS(plg_grids_df, paste0(envrmt$path_data_lrt_20_lrt_buffered, "/plg_grids_df.rds"))

