# rs-ws-05-1
#' @description  MOC - Advanced GIS (T. Nauss, C. Reudenbach)
#' getSessionPathes
#'@return 
#' defines and creates (if necessary) all folders variables
#' set the SAGA path variables and other system variables
#' exports all variables to the global environment
#'
#'@param filepath_git  project github root directory (your github name)
#'@param csess= current session "01",
#'@param courseCode current course options are "gi", "rs", "da" you may only use one course per session
#'@param moc=TRUE creates a folder structure according to the needs of the MOC courses, FALSE creates a simple project structure
#'\preformatted{
#'   If moc=TRUE the following folderstructure is exported. If folders do not exist thesy will be created.
#'.
#'├── data
#'│   ├── data_analysis
#'│   │   ├── csv
#'│   │   └── raw
#'│   ├── gis
#'│   │   ├── input
#'│   │   ├── output
#'│   │   ├── RData
#'│   │   ├── run
#'│   │   └── temp
#'│   └── remote_sensing
#'│       ├── aerial
#'│       ├── aerial_croped
#'│       ├── aerial_merged
#'│       ├── input
#'│       ├── RData
#'│       ├── run
#'│       └── temp
#'└── MOC
#'    ├── data_analysis
#'    │   └── da-ws-01
#'    │       └── rmds
#'    │       └── scripts
#'    ├── fun
#'    ├── gis
#'    │   └── gi-ws-01
#'    │       └── rmds
#'    │       └── scripts
#'    └── remote_sensing
#'        └── rs-ws-01
#'    │       └── rmds
#'            └── scripts
#'   } 
#'
#'@author Thomas Nauss, Chris Reudenbach
#'
#'@return  getSessionPathes< creates if necessary the directories and export the corresponding pathes as global variables\cr

getSessionPathes<- function(filepath_git,sessNo=1,courseCode="gi") {
  
  # switch backslash to slash and expand path to full path
  filepath_git<-gsub("\\\\", "/", path.expand(filepath_git))  
  
  # check  tailing / and if not existing append
  if (substr(filepath_git,nchar(filepath_git)-1,nchar(filepath_git)) != "/") {
    filepath_git<-paste0(filepath_git,"/")
  }
  

  # script and function folder for each course session can be adapted 
  session_working_folder<-c("/scripts/", "/rmds/")
  # currently implemented data folders can be adapted 
  data_working_folder<-c("RData/","temp/","run/","input/","output/")
                       
  

    # static course structure - better keep the below folders
    proj_root_git<-c(path.expand(filepath_git))
    proj_root_data<-paste0(substr(proj_root_git,1,gregexpr(pattern ='/',proj_root_git)[[1]][as.numeric(lengths(gregexpr(pattern ='/',proj_root_git))[[1]]-2)]),"data/")
    
    if (courseCode == "lrt") {
    sub_root<-c("Wald_LRT_modelling/")
    session_ID<-c("lrt-dat-")
    
    } else if (courseCode == "gi") {
    sub_root<-c("gis/")
    session_ID<-c("gi-ws-")
    
    } else if (courseCode == "cal") {
      sub_root<-c("caldern/")
      session_ID<-c("cal-")
    
    } else if  (courseCode == "da") {
    sub_root<-c("data_analysis/")
    session_ID<-c("da-ws-")
    
    }
    # create sessionstring
    
    session_number<- sapply(sessNo, function(no){
      if (no<10) {no<-paste0("0",no)}
      return(no)
    })
    
    # create folder and varibales 
    # function folder for all courses
    name<-paste0("pg_fun")
    value<-paste0(filepath_git,"/fun/")
    makGlobalVar(name, value)
    # and the rest
      
    for (i in 1:length(proj_root_git)) {
#      for (j in 1:length(sub_root)) {
        #for (k in 1:length(session_ID)) {
          for (l in 1:length(session_number)) {
            for (m in 1:length(session_working_folder)) {
              name<-paste0("pg_", substr(session_ID,1,2),"_",as.character(gsub("/", "", session_number[l])),"_",as.character(gsub("/", "",session_working_folder[m])))
              value<- paste0(proj_root_git[i],sub_root,session_ID,session_number[l],session_working_folder[m])
               makGlobalVar(name, value)
              }
            }
#          }
#        }sub_root<-3
      }
    
    
    # data structure NOTE it is outside the proj_root_git folder
    for (i in 1:length(proj_root_data)){
#      for (j in 1:length(sub_root)) {
        for (k in 1:length(data_working_folder)) {
          name<-paste0("pd_",substr(session_ID,1,2),"_",as.character(gsub("/", "",data_working_folder[k])))
          value<- paste0(proj_root_data[i],sub_root,data_working_folder[k])
           makGlobalVar(name, value)
          if (courseCode==substr(session_ID,1,2) && data_working_folder[k]=="run/"){
            path_temp<- value
          }
        }
#      }
  } # end of moc=TRUE

}
