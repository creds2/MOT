# DVAL

# library(rvest)
library(RSelenium)

# Tru no imagees, speed up rendering

driver <- rsDriver(browser=c("firefox"), port=4447L, verbose = FALSE)

remote_driver <- driver[["client"]]
remote_driver$open()

#imps <- readRDS("E:/Users/earmmor/OneDrive - University of Leeds/CREDS dat/MOT API/attempt_2/part1/mot_tmp_main_btch_1.Rds")
#reg = imps$registration[1:20]
imps <- readxl::read_excel("E:/Users/earmmor/OneDrive - University of Leeds/CREDS data/github-secure-data/vehicleregistration.xlsx",
                         sheet = "Sheet1")
reg <- imps$`Vehicle Registration Number`

res_dat = list()

finder_func <- function(remote_driver, using, value, n = 5){
  for(itr in 1:n){
    suppressMessages({element <- try(remote_driver$findElement(using = using, value = value), silent = TRUE)})
    if(class(element) != "try-error"){
      return(element)
    }else{
      Sys.sleep(1)
    }
  }
  return(element)
}

finder_yes <- function(remote_driver, using = 'id', value = 'yes-vehicle-confirm', n = 5){
  for(itr in 1:n){
    suppressMessages({element <- try(remote_driver$findElement(using = using, value = value), silent = TRUE)})
    if(class(element) != "try-error"){
      return(element)
    }else{
      # Might be because of bad registation
      suppressMessages({element_error <- try(remote_driver$findElement(using = "class", value = "govuk-error-summary"), silent = TRUE)})
      if(class(element_error) != "try-error"){
        return(element)
      }
      suppressMessages({element_missing <- try(remote_driver$findElement(using = "class", value = "info-panel"), silent = TRUE)})
      if(class(element_missing) != "try-error"){
        element_missing_text <- element_missing$getElementText()
        if(element_missing_text[[1]] == "Vehicle details could not be found"){
          return(element)
        }
      }
      
      Sys.sleep(1)
    }
  }
  return(element)
}



for(i in 1:length(reg)){
  message(Sys.time()," ",i," ",reg[i])
  
  remote_driver$navigate(url = "https://vehicleenquiry.service.gov.uk")
  Sys.sleep(0.5)

  reg_element <- finder_func(remote_driver, 'class', 'govuk-input', n = 20)
  reg_element$sendKeysToElement(list(reg[i]))

  button_element <- finder_func(remote_driver, 'class', 'govuk-button')
  button_element$clickElement()
  Sys.sleep(0.5)
  
  yes_element <- finder_yes(remote_driver, n = 20)
  if(class(yes_element) != "try-error"){
    yes_element$clickElement()

    button_element2 <- finder_func(remote_driver, 'class', 'govuk-button')
    button_element2$clickElement()
    Sys.sleep(0.5)
    
    out <- finder_func(remote_driver, 'class', 'govuk-summary-list', n = 20)
    dat <- out$getElementText()
    dat <- strsplit(dat[[1]], "\n", fixed = TRUE)
    dat <- dat[[1]]
    
    dat <- gsub("Vehicle make ","",dat, fixed = TRUE)
    dat <- gsub("Date of first registration ","",dat, fixed = TRUE)
    dat <- gsub("Year of manufacture ","",dat, fixed = TRUE)
    dat <- gsub("Cylinder capacity ","",dat, fixed = TRUE)
    #dat <- gsub("CO₂ emissions ","",dat, fixed = TRUE)
    dat <- gsub("Fuel type ","",dat, fixed = TRUE)
    dat <- gsub("Euro status ","",dat, fixed = TRUE)
    dat <- gsub("Real Driving Emissions (RDE) ","",dat, fixed = TRUE)
    dat <- gsub("Export marker ","",dat, fixed = TRUE)
    dat <- gsub("Vehicle status ","",dat, fixed = TRUE)
    dat <- gsub("Vehicle colour ","",dat, fixed = TRUE)
    dat <- gsub("Vehicle type approval ","",dat, fixed = TRUE)
    dat <- gsub("Wheelplan ","",dat, fixed = TRUE)
    dat <- gsub("Revenue weight ","",dat, fixed = TRUE)
    dat <- gsub("Date of last V5C (logbook) issued ","",dat, fixed = TRUE)
    dat <- c(reg[i],dat)
    
    res_dat[[i]] <- dat
    rm(button_element2, out, dat)
  }
  rm(reg_element, button_element, yes_element)
  
}

#res_dat2 = res_dat
colnames <- c("Registation","Vehicle make","Date of first registration","Year of manufacture","Cylinder capacity",
             "CO2 emissions","Fuel type","Euro status","Real Driving Emissions","Export marker",
             "Vehicle status","Vehicle colour","Vehicle type approval","Wheelplan","Revenue weight",
             "Date of last V5C")
res_dat2 = as.data.frame(data.table::transpose(res_dat), col.names = colnames)
saveRDS(res_dat2,"scrape.Rds")



  
