# merge datasets 

path = "E:/OneDrive - University of Leeds/CREDS Data/"

main_api = readRDS(paste0(path,"MOT API/mot_history_main_1-21728.Rds"))
main_anon = readr::read_delim(paste0(path,"MOT anoymised/test_result_2017.zip"), n_max = 10, delim = ",")
file = "E:/OneDrive - University of Leeds/CREDS Data/MOT anoymised/test_result_2017/test_result_2017.csv"
import_mot = function(file){
  data <- readLines(file, n = 100000)
  data <- strsplit(data,",")
  lths <- lengths(data)
  
  data_good <- data[lths == 14]
  data_bad <- data[lths != 14]
  #rm(data)
  
  # format up the good data
  data_good <- data.frame(matrix(unlist(data_good), ncol=14, byrow=T),stringsAsFactors=FALSE)
  names(data_good) <- as.character(data_good[1,])
  data_good <- data_good[2:nrow(data_good),]
  
  #handel the bad data
  fix_mot <- function(sub){
    #cols are
    #test_id number 
    #vehicle_id  number
    #test_date date
    #test_class_id number 1 digit
    #test_type character 2 letters
    #test_result character 1-3 letters
    #test_mileage number
    #postcode_area  character 2 letters        
    #make character    
    #model character
    #colour character
    #fuel_type character 2 letters
    #cylinder_capacity number
    # first_use_date date
    
    is_int <- !is.na(as.integer(sub))
    is_date <- !is.na(lubridate::ymd(sub))
    n_char <- nchar(sub)
    
    if()
    
    
    
  }
  
  
}



# problem reading the data
foo <- (1:nrow(main_anon))[!main_anon$fuel_type %in% c("DI","PE","EL","HY","OT","GB","LP","FC","ED","GD","CN","GA","LN","ST")]
foo2 <- main_anon[!main_anon$fuel_type %in% c("DI","PE","EL","HY","OT","GB","LP","FC","ED","GD","CN","GA","LN","ST"),]
main_anon2 <- readLines(con = "E:/OneDrive - University of Leeds/CREDS Data/MOT anoymised/test_result_2017/test_result_2017.csv", n = 1)
main_anon2[13833:13836]
main_anon2[13834]

# Mathc formats
main_api$firstUsedDate <- lubridate::ymd(main_api$firstUsedDate)

