# merge datasets 

path = "E:/OneDrive - University of Leeds/CREDS Data/"
path = "E:/Users/earmmor/OneDrive - University of Leeds/CREDS Data/"

file = paste0(path,"MOT anoymised/raw/test_result_2016.txt")

data <- readLines(file)
data <- strsplit(data,"|", fixed = TRUE)
lths <- lengths(data)

data_good <- data[lths == 14]
data_bad <- data[lths != 14]
#data_bad2 <- data[c(34549796, 34549795, 34549797)]

# format up the good data
data_good <- data.frame(matrix(unlist(data_good), ncol=14, byrow=T),stringsAsFactors=FALSE)
names(data_good) <- as.character(data_good[1,])
data_good <- data_good[2:nrow(data_good),]


data_bad_13 = data_bad[lengths(data_bad) == 13]
data_bad_15 = data_bad[lengths(data_bad) == 15]
data_bad_16 = data_bad[lengths(data_bad) == 16]
#data_bad_17 = data_bad[lengths(data_bad) == 17]


data_bad_16 = lapply(data_bad_16, function(x){c(x[1:10],x[13:16])})
data_bad_16 = t(as.data.frame(data_bad_16))
rownames(data_bad_16) = 1:nrow(data_bad_16)

data_bad_13 = lapply(data_bad_13, function(x){c(x[1:13],"")})
data_bad_13 = t(as.data.frame(data_bad_13))
rownames(data_bad_13) = 1:nrow(data_bad_13)

data_fixed <- rbind(data_bad_13, data_bad_16)
data_fixed <- as.data.frame(data_fixed)
names(data_fixed) <- names(data_good)
data_fixed[] <- lapply(data_fixed, as.character)
data_final <- rbind(data_good, data_fixed)
saveRDS(data_final, "E:/Users/earmmor/OneDrive - University of Leeds/CREDS Data/MOT anoymised/clean/test_result_2016.Rds")

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



# problem reading the data
foo <- (1:nrow(main_anon))[!main_anon$fuel_type %in% c("DI","PE","EL","HY","OT","GB","LP","FC","ED","GD","CN","GA","LN","ST")]
foo2 <- main_anon[!main_anon$fuel_type %in% c("DI","PE","EL","HY","OT","GB","LP","FC","ED","GD","CN","GA","LN","ST"),]
main_anon2 <- readLines(con = "E:/OneDrive - University of Leeds/CREDS Data/MOT anoymised/test_result_2017/test_result_2017.csv", n = 1)
main_anon2[13833:13836]
main_anon2[13834]

# Mathc formats
main_api$firstUsedDate <- lubridate::ymd(main_api$firstUsedDate)

