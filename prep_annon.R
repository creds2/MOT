# MOTE some files hav bad records see the prep_annon_20XX.R files which manaul clean those years


library(readr)

path = "E:/Users/earmmor/OneDrive - University of Leeds/CREDS Data/"

files = list.files(paste0(path,"/MOT anoymised/raw"), pattern = "result")
#dir.create(paste0(path,"MOT anoymised/clean"))

for(i in 3:length(files)){
  message(files[i])
  format(object.size(files[i]), units = "Mb")
  file = readr::read_delim(paste0(path,"MOT anoymised/raw/",files[i]), 
                           delim = "|",
                           escape_backslash = FALSE,
                           escape_double = FALSE,
                           col_types = readr::cols(
                             test_id = col_double(),
                             vehicle_id = col_double(),
                             test_date = col_date(format = ""),
                             test_class_id = col_double(),
                             test_type = col_factor(),
                             test_result = col_factor(),
                             test_mileage = col_double(),
                             postcode_area = col_factor(),
                             make = col_factor(),
                             model = col_factor(),
                             colour = col_factor(),
                             fuel_type = col_factor(),
                             cylinder_capacity = col_double(),
                             first_use_date = col_date(format = "")
                           ))
  
  
  saveRDS(file, paste0(path,"MOT anoymised/clean/",substr(files[i],1,nchar(files[i]) - 3),"Rds"))
}



files = list.files(paste0(path,"/MOT anoymised/raw"), pattern = "item")


for(i in 1:length(files)){
  message(files[i])
  
  file = readr::read_delim(paste0(path,"MOT anoymised/raw/",files[i]), 
                           delim = "|",
                           escape_backslash = FALSE,
                           escape_double = FALSE,
                           col_types = readr::cols(
                              test_id = col_double(),
                              rfr_id = col_double(),
                              rfr_type_code = col_character(),
                              location_id = col_double(),
                              dangerous_mark = col_character()
                           ),
                           n_max = 100
                           )
  
  
  saveRDS(file, paste0(path,"MOT anoymised/clean/",substr(files[i],1,nchar(files[i]) - 3),"Rds"))
}

