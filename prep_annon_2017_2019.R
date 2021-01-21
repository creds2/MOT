# merge datasets 

path = "D:/OneDrive - University of Leeds/Data/CREDS Data/"

year <- 2019

dir.create("tmp")
unzip(paste0(path,"MOT anoymised/dft_test_result_",year,".zip"),
      exdir = "tmp")

files <- list.files("tmp", pattern = ".csv", full.names = TRUE)

res <- list()
for(j in seq(1, length(files))){
  sub <- readLines(files[j])
  res[[j]] <- sub[seq(2, length(sub))]
}
unlink("tmp", recursive = TRUE)

data <- unlist(res, recursive = FALSE)
data <- strsplit(data,",")
lths <- lengths(data)
summary(lths)

data_good <- data[lths == 14]
data_bad <- data[lths != 14]

# format up the good data
data_good <- data.frame(matrix(unlist(data_good), ncol=14, byrow=T),stringsAsFactors=FALSE)
names(data_good) <- as.character(data_good[1,])
data_good <- data_good[2:nrow(data_good),]


data_bad_13 = data_bad[lengths(data_bad) == 13]
data_bad_15 = data_bad[lengths(data_bad) == 15]
data_bad_16 = data_bad[lengths(data_bad) == 16]
data_bad_17 = data_bad[lengths(data_bad) == 17]


if(length(data_bad_17) > 0){
  data_bad_17 = lapply(data_bad_17, function(x){c(x[1:10],x[14:17])})
  data_bad_17 = t(as.data.frame(data_bad_17))
  rownames(data_bad_17) = 1:nrow(data_bad_17)
} else {
  data_bad_17 <- NULL
}

if(length(data_bad_16) > 0){
  data_bad_16 = lapply(data_bad_16, function(x){c(x[1:9],paste(x[10:12], collapse = " "),x[13:16])})
  data_bad_16 = t(as.data.frame(data_bad_16))
  rownames(data_bad_16) = 1:nrow(data_bad_16)
} else {
  data_bad_16 <- NULL
}

if(length(data_bad_15) > 0){
  data_bad_15 = lapply(data_bad_15, function(x){c(x[1:9],paste(x[10:11], collapse = " "),x[12:15])})
  data_bad_15 = t(as.data.frame(data_bad_15))
  rownames(data_bad_15) = 1:nrow(data_bad_15)
} else {
  data_bad_15 <- NULL
}

if(length(data_bad_13) > 0){
  data_bad_13 = lapply(data_bad_13, function(x){c(x[1:13],"")})
  data_bad_13 = t(as.data.frame(data_bad_13))
  rownames(data_bad_13) = 1:nrow(data_bad_13)
} else {
  data_bad_13 <- NULL
}

data_fixed <- rbind(data_bad_13, data_bad_15)
data_fixed <- rbind(data_fixed, data_bad_16)
data_fixed <- rbind(data_fixed, data_bad_17)
data_fixed <- as.data.frame(data_fixed)
names(data_fixed) <- names(data_good)
data_fixed[] <- lapply(data_fixed, as.character)
data_final <- rbind(data_good, data_fixed)
data_final <- data_final[data_final$test_id != "test_id",]

data_final$test_id <- as.numeric(data_final$test_id)
data_final$vehicle_id <- as.numeric(data_final$vehicle_id)
data_final$test_date <- lubridate::ymd(data_final$test_date)
data_final$test_mileage <- as.numeric(data_final$test_mileage)
data_final$cylinder_capacity <- as.numeric(data_final$cylinder_capacity)
data_final$first_use_date <- lubridate::ymd(data_final$first_use_date)


saveRDS(data_final, paste0(path,"MOT anoymised/clean/test_result_",year,".Rds"))


# import_mot = function(file){
#   data <- readLines(file, n = 100000)
#   data <- strsplit(data,",")
#   lths <- lengths(data)
#   
#   data_good <- data[lths == 14]
#   data_bad <- data[lths != 14]
#   #rm(data)
#   
#   
#   
#   #handel the bad data
#   fix_mot <- function(sub){
#     #cols are
#     #test_id number 
#     #vehicle_id  number
#     #test_date date
#     #test_class_id number 1 digit
#     #test_type character 2 letters
#     #test_result character 1-3 letters
#     #test_mileage number
#     #postcode_area  character 2 letters        
#     #make character    
#     #model character
#     #colour character
#     #fuel_type character 2 letters
#     #cylinder_capacity number
#     # first_use_date date
#     
#     is_int <- !is.na(as.integer(sub))
#     is_date <- !is.na(lubridate::ymd(sub))
#     n_char <- nchar(sub)
#     
#     if()
#     
#     
#     
#   }
#   
#   
# }



# # problem reading the data
# foo <- (1:nrow(main_anon))[!main_anon$fuel_type %in% c("DI","PE","EL","HY","OT","GB","LP","FC","ED","GD","CN","GA","LN","ST")]
# foo2 <- main_anon[!main_anon$fuel_type %in% c("DI","PE","EL","HY","OT","GB","LP","FC","ED","GD","CN","GA","LN","ST"),]
# main_anon2 <- readLines(con = "E:/OneDrive - University of Leeds/CREDS Data/MOT anoymised/test_result_2017/test_result_2017.csv", n = 1)
# main_anon2[13833:13836]
# main_anon2[13834]
# 
# # Mathc formats
# main_api$firstUsedDate <- lubridate::ymd(main_api$firstUsedDate)

