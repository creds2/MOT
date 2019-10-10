library(httr)
key = Sys.getenv("MOT_key") # get API key
npages = 100000 #59310
res_main <- list()
res_tests <- list()
res_comments <- list()
# page fails, 4318, 4319, 4321, 4322, 4323, 10590 - 10596, 10849
# 11867, 11868, 20308 - 20313
fails = c(4318, 4319, 4321, 4322, 4323, 10590:10596, 10849,
          11867, 11868, 20308:20313)
pb = txtProgressBar(min = 1, max = npages, initial = 1) # Make progress bar
#gc()
for(i in seq(21729, npages)){
  setTxtProgressBar(pb,i)
  #message(Sys.time()," ", i)
  # Request page
  req <- try(GET(
    url = "https://beta.check-mot.service.gov.uk/trade/vehicles/mot-tests",
    query = list(
      page = i
    ),
    add_headers(`Content-type` = "application/json", `x-api-key` = key)
  ))
  if(class(req) == "try-error"){
    message(paste0("Got try error for req number ",i))
  }else{
    if(req$status_code == 200){
      # convert response content into text
      data <- httr::content(req, as = "text", encoding = "UTF-8")
      data <- jsonlite::fromJSON(data)
      data_main <- data[,c("registration","make","model","firstUsedDate","fuelType","primaryColour")]
      data_tests <- data$motTests
      names(data_tests) <- data_main$registration
      data_tests <- dplyr::bind_rows(data_tests, .id = "registration")
      data_comments <- data_tests$rfrAndComments
      data_tests$rfrAndComments <- NULL
      names(data_comments) <- data_tests$motTestNumber
      data_comments <- dplyr::bind_rows(data_comments, .id = "motTestNumber")
      
      #Compress data
      data_comments[] <- lapply(data_comments, as.factor)
      data_main[c(2,3,5,6)] <- lapply(data_main[c(2,3,5,6)], as.factor)
      data_main$firstUsedDate <- lubridate::ymd(data_main$firstUsedDate)
      data_tests$completedDate <- lubridate::ymd_hms(data_tests$completedDate)
      data_tests$expiryDate <- lubridate::ymd(data_tests$expiryDate)
      data_tests$registration <- as.factor(data_tests$registration)
      data_tests$testResult <- as.factor(data_tests$testResult)
      data_tests$odometerUnit <- as.factor(data_tests$odometerUnit)
      data_tests$odometerValue <- as.numeric(data_tests$odometerValue)
      
      # Add to list
      res_main[[i]] <- data_main
      res_tests[[i]] <- data_tests
      res_comments[[i]] <- data_comments
      rm(data, data_main, data_tests, data_comments)
    }else if(req$status_code == 404){
      message(paste0("Failed to get page ",i," page not found"))
      if(i > 90000){
        stop("must have run out of pages")
      }
    }else{
      message(paste0("Failed to get page ",i," error ",req$status_code))
    }
  }
  
  
  if(i %% 2000 == 0){
    message(paste0(Sys.time()," starting to save a backup for requests 1:",i))
    saveRDS(res_main,"F:/MOT_data/download_data_main.Rds")
    saveRDS(res_tests,"F:/MOT_data/download_data_test.Rds")
    saveRDS(res_comments,"F:/MOT_data/download_data_comments.Rds")
    message(paste0(Sys.time()," backup saved"))
  }
  rm(req)
  
}

main <- dplyr::bind_rows(res_main)
tests <- dplyr::bind_rows(res_tests)
comments <- dplyr::bind_rows(res_comments)

comments[] <- lapply(comments, as.factor)
main[c(2,3,5,6)] <- lapply(main[c(2,3,5,6)], as.factor)
main$firstUsedDate <- lubridate::ymd(main$firstUsedDate)
tests$completedDate <- lubridate::ymd_hms(tests$completedDate)
tests$expiryDate <- lubridate::ymd(tests$expiryDate)
tests$registration <- as.factor(tests$registration)
tests$testResult <- as.factor(tests$testResult)
tests$odometerUnit <- as.factor(tests$odometerUnit)
tests$odometerValue <- as.numeric(tests$odometerValue)


saveRDS(main,"F:/MOT_data/mot_history_main_21729-xx.Rds")
saveRDS(tests,"F:/MOT_data/mot_history_tests_21729-xx.Rds")
saveRDS(comments,"F:/MOT_data/mot_history_comments_21729-xx.Rds")
