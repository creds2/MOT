library(httr)
key = Sys.getenv("MOT_key") # get API key
npages = 100000 #59310
res <- list()

pb = txtProgressBar(min = 1, max = npages, initial = 1) # Make progress bar
for(i in 1:npages){
  setTxtProgressBar(pb,i)
  # Request page
  req <- GET(
    url = "https://beta.check-mot.service.gov.uk/trade/vehicles/mot-tests",
    query = list(
      page = i
    ),
    add_headers(`Content-type` = "application/json", `x-api-key` = key)
  )
  if(req$status_code == 200){
    # convert response content into text
    data <- httr::content(req, as = "text", encoding = "UTF-8")
    data <- jsonlite::fromJSON(data)
    res[[i]] <- data
    rm(data)
  }else if(req$status_code == 404){
    message(paste0("Failed to get page ",i," page not found"))
    if(i > 90000){
      stop("must have run out of pages")
    }
  }else{
    message(paste0("Failed to get page ",i," error ",req$status_code))
  }
  
  if(i %% 100 == 0){
    saveRDS(res,"F:/MOT_data/download_data.Rds")
  }
  
}

res <- dplyr::bind_rows(res)
saveRDS(res,"F:/MOT_data/mot_history_all_2019_10_04.Rds")
