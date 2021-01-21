path <- file.path("D:/OneDrive - University of Leeds/Data/CREDS Data/MOT anoymised/clean")

years <- 2005:2017

library(dplyr)

mot <- list()

for(i in 1:length(years)){
  year <- years[i]
  message(year)
  mot_sub <- readRDS(file.path(path,paste0("test_result_",year,".Rds")))
  mot_sub <- mot_sub[!duplicated(mot_sub$vehicle_id),]
  mot_sub <- mot_sub[c("vehicle_id","test_date","test_mileage","postcode_area",
                       "make","model", "colour", "fuel_type","cylinder_capacity","first_use_date")]
  mot_sub$year <- year
  mot[[i]] <-  mot_sub
}

#mot <- mot[!sapply(mot, is.null)]
mot <- bind_rows(mot)

for(i in 1:13){
  print(class(mot[[i]]$vehicle_id))
}
