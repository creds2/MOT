# Scrapes DVLA data from website

# Load Packages
library(RSelenium)

# Get list of VRMs to use
reg <- c("K505MGT")

# Setup scraping

driver <- rsDriver(browser=c("chrome"), port=4447L, verbose = TRUE)
remote_driver <- driver[["client"]]
remote_driver$open()

res_data = list()

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
  message(Sys.time()," ",i)
  
  remote_driver$navigate(url = "https://vehicleenquiry.service.gov.uk")
  
  reg_element <- finder_func(remote_driver, 'class', 'govuk-input')
  reg_element$sendKeysToElement(list(reg[i]))
  
  button_element <- finder_func(remote_driver, 'class', 'govuk-button')
  button_element$clickElement()
  
  yes_element <- finder_yes(remote_driver)
  if(class(yes_element) != "try-error"){
    yes_element$clickElement()
   
    button_element2 <- finder_func(remote_driver, 'class', 'govuk-button')
    button_element2$clickElement()
      
    out <- finder_func(remote_driver, 'class', 'govuk-summary-list')
    data <- out$getElementText()
    data <- strsplit(data[[1]], "\n", fixed = TRUE)
    data <- data[[1]]
    res_data[[i]] <- data
    rm(button_element2, out, data)
  }
  rm(reg_element, button_element, yes_element)
  
}
