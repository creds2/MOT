# merge datasets 

path = "E:/OneDrive - University of Leeds/CREDS Data/"

main_api = readRDS(paste0(path,"MOT API/mot_history_main_1-21728.Rds"))
main_anon = readr::read_csv(paste0(path,"MOT anoymised/test_result_2017.zip"))
main_anon = main_anon[main_anon$fuel_type %in% c("DI","PE","EL","HY","OT","GB","LP","FC","ED","GD","CN","GA","LN","ST"),]

foo <- unique(main_anon[,c("make","model","colour","fuel_type","first_use_date")])



# try a join

main_api$firstUsedDate <- lubridate::ymd(main_api$firstUsedDate)
main_api$primaryColour <- tolower(main_api$primaryColour)
main_anon$colour <- tolower(main_anon$colour)

jn = dplyr::left_join(main_api[1:100,], main_anon, by = c("make" = "make","model" = "model", "firstUsedDate" = "first_use_date"))




