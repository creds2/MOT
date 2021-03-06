# merge datasets 

path = "D:/OneDrive - University of Leeds/Data/CREDS Data/"

year <- 2020

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
head(data_good)
names(data_good) <- c("test_id","vehicle_id","test_date","test_class_id","test_type","test_result","test_mileage",
                      "postcode_area","make","model","colour","fuel_type","cylinder_capacity","first_use_date")
#data_good <- data_good[2:nrow(data_good),]


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




