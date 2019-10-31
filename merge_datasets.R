library(plyr)
library(dplyr)

# load data
path = "E:/OneDrive - University of Leeds/CREDS Data/"
path = "E:/Users/earmmor/OneDrive - University of Leeds/CREDS Data/"

main_api <- readRDS(paste0(path,"MOT API/mot_history_main_1-21728.Rds"))
main_annon <- readRDS(paste0(path,"MOT anoymised/clean/test_result_2006.Rds"))
main_annon <- main_annon[!duplicated(main_annon$vehicle_id),]
tests_api <- readRDS(paste0(path,"MOT API/mot_history_tests_1-21728.Rds"))


# filter tests to 2006
tests_2006 <- tests_api[tests_api$completedDate <= lubridate::ymd("2006-12-31"),]
tests_2006 <- tests_2006[tests_2006$completedDate > lubridate::ymd("2005-12-31"),]
tests_2006 <- tests_2006[!duplicated(tests_2006$registration),]
tests_2006$miles <- ifelse(tests_2006$odometerUnit == "mi", tests_2006$odometerValue, round(tests_2006$odometerValue * 0.621371,0))
tests_2006$test_date <- lubridate::date(tests_2006$completedDate)
tests_2006 <- tests_2006[,c("registration","miles","test_date")]
#summary(duplicated(tests_2006[,c("miles","test_date")]))

# about 5% of date and miles are duplicated so join to main first
durp_reg = main_api$registration[duplicated(main_api$registration)]
foo = main_api[main_api$registration %in% durp_reg,]

main_api <- left_join(main_api, tests_2006, by = c("registration"))


# match formatting
#table(main_api$fuelType)
#table(main_annon$fuel_type)

main_annon$fuel_type <- revalue(main_annon$fuel_type, 
           c("CN" = "CNG",
             "DI" = "Diesel",
             "ED" = "Electric Diesel",
             "EL" = "Electric",
             "FC" = "Fuel Cells",
             "GA" = "Gas",
             "GB" = "Gas Bi-Fuel",
             "GD" = "Gas Diesel",
             "HY" = "Hybrid Electric (Clean)",
             "LN" = "LNG",
             "LP" = "LPG",
             "OT" = "Other",
             "PE" = "Petrol",
             "ST" = "Steam"))

main_api$colour <- toupper(main_api$colour)

tmp <- main_api[1:100,]
#tmp$primaryColour <- toupper(tmp$primaryColour)

# non -unique so need test date and millage
foo <- dplyr::left_join(tmp, main_annon, by = c("make" = "make", 
                                                "model" = "model",
                                                "primaryColour" = "colour",
                                                "fuelType" = "fuel_type",
                                                "firstUsedDate" = "first_use_date"))
