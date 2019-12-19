# DVAL

# library(rvest)
library(RSelenium)

# Tru no imagees, speed up rendering

driver <- rsDriver(browser=c("chrome"), port=4447L, verbose = FALSE)

remote_driver <- driver[["client"]]
remote_driver$open()

imps <- readRDS("E:/Users/earmmor/OneDrive - University of Leeds/CREDS Data/MOT API/attempt_2/part1/mot_tmp_main_btch_1.Rds")

reg = imps$registration[1:20]

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
  #Sys.sleep(1)
  
  #reg_element <- try(remote_driver$findElement(using = 'class', value = 'govuk-input'), silent = TRUE)
  reg_element <- finder_func(remote_driver, 'class', 'govuk-input')
  reg_element$sendKeysToElement(list(reg[i]))
  
  #button_element <- remote_driver$findElement(using = 'class', value = "govuk-button")
  button_element <- finder_func(remote_driver, 'class', 'govuk-button')
  button_element$clickElement()
  #Sys.sleep(5)
  
  #yes_element <- try(remote_driver$findElement(using = 'id', value = "yes-vehicle-confirm"), silent = TRUE)
  #yes_element <- finder_func(remote_driver, 'id', 'yes-vehicle-confirm')
  yes_element <- finder_yes(remote_driver)
  if(class(yes_element) != "try-error"){
    yes_element$clickElement()
    
    #button_element2 <- remote_driver$findElement(using = 'class', value = "govuk-button")
    button_element2 <- finder_func(remote_driver, 'class', 'govuk-button')
    button_element2$clickElement()
    #Sys.sleep(5)
    
    #out <- remote_driver$findElement(using = "class", value="govuk-summary-list")
    out <- finder_func(remote_driver, 'class', 'govuk-summary-list')
    data <- out$getElementText()
    data <- strsplit(data[[1]], "\n", fixed = TRUE)
    data <- data[[1]]
    res_data[[i]] <- data
    rm(button_element2, out, data)
  }
  rm(reg_element, button_element, yes_element)
  
}

#res_data2 = res_data
#res_data2 = lapplgsub("Vehicle make ","",res_data2)



# Form Request

# <form action="/?locale=en" accept-charset="UTF-8" method="post" _lpchecked="1">
# <input name="utf8" type="hidden" value="✓"><input type="hidden" name="authenticity_token" value="A4cNWL6LtJ4SkjivbSfCvvIDn8RP7u/vwW5SlTZVV6CNredNHS072ajBH9D79x+whokctNfwURvYFX/DdBi8eA=="><govuk-fieldset>
#   <legend class="govuk-fieldset__legend govuk-fieldset__legend--l">
#   <h1 class="govuk-fieldset__heading">Enter the registration number of the vehicle</h1>
#   </legend>
#   <div class="govuk-form-group"><label class="govuk-label" for="wizard_vehicle_enquiry_capture_vrn_vrn">Registration number (number plate)
# </label><span class="govuk-hint">
#   For example, CU57ABC
# </span>
#   <input class="govuk-input govuk-input--width-10" maxlength="8" autocomplete="off" size="8" type="text" name="wizard_vehicle_enquiry_capture_vrn[vrn]" id="wizard_vehicle_enquiry_capture_vrn_vrn">
#   </div></govuk-fieldset>
#   <button class="govuk-button" id="submit_vrn_button" onclick="trackLinkClick('Continue')" type="submit">Continue</button>
#   </form>

# Make a POST request for

# Headers

# Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3
# Accept-Encoding: gzip, deflate, br
# Accept-Language: en-GB,en-US;q=0.9,en;q=0.8
# Cache-Control: max-age=0
# Connection: keep-alive
# Content-Length: 184
# Content-Type: application/x-www-form-urlencoded
# Cookie: TSPD_101=08b61b9ebeab280068b3344c508a0ed3cb5f3aace7d412974eede99deb1c2c2e2114d8c1fb6278bf18403336efb142cb:; _vehicle_enquiry_ui_session=d343b52efde9767ce1cf2390eda2748c; TS016c01bc=010a55ec4f754ffea49613c633adaa5f24e1a11b3067a05f02bde8cdc8f3fd91115b4c0d4878f7177a203c2e94ce83c4fbf55030f1ab5ca4715136f4439adab9779dc232b7
# DNT: 1
# Host: vehicleenquiry.service.gov.uk
# Origin: https://vehicleenquiry.service.gov.uk
# Referer: https://vehicleenquiry.service.gov.uk/?locale=en
# Sec-Fetch-Mode: navigate
# Sec-Fetch-Site: same-origin
# Sec-Fetch-User: ?1
# Upgrade-Insecure-Requests: 1
# User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36



# req <- httr::POST(
#   url = "https://vehicleenquiry.service.gov.uk/?locale=en",
#   query = list(
#     authenticity_token = "A4cNWL6LtJ4SkjivbSfCvvIDn8RP7u/vwW5SlTZVV6CNredNHS072ajBH9D79x+whokctNfwURvYFX/DdBi8eA==",
#     utf8 = "✓",
#     `wizard_vehicle_enquiry_capture_vrn[vrn]` = reg
#   ),
#   httr::add_headers(
#     `Accept` =  "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
#     `Accept-Encoding` = "gzip, deflate, br",
#     `Accept-Language` = "en-GB,en-US;q=0.9,en;q=0.8",
#     `Cache-Control` = "max-age=0",
#     `Connection` = "keep-alive",
#     `Content-Length` = "184",
#     `Content-Type` = "application/x-www-form-urlencoded",
#     Cookie = "TSPD_101=08b61b9ebeab280068b3344c508a0ed3cb5f3aace7d412974eede99deb1c2c2e2114d8c1fb6278bf18403336efb142cb:; _vehicle_enquiry_ui_session=d343b52efde9767ce1cf2390eda2748c; TS016c01bc=010a55ec4f754ffea49613c633adaa5f24e1a11b3067a05f02bde8cdc8f3fd91115b4c0d4878f7177a203c2e94ce83c4fbf55030f1ab5ca4715136f4439adab9779dc232b7",
#     DNT = "1",
#     Host = "vehicleenquiry.service.gov.uk",
#     Origin = "https://vehicleenquiry.service.gov.uk",
#     Referer = "https://vehicleenquiry.service.gov.uk/?locale=en",
#     `Sec-Fetch-Mode` = "navigate",
#     `Sec-Fetch-Site` = "same-origin",
#     `Sec-Fetch-User` = "?1",
#     `Upgrade-Insecure-Requests` = "1"
#     
#   )
#   )
# data <- httr::content(req, as = "text", encoding = "UTF-8")
# data <- read_html(data)



# url = "https://vehicleenquiry.service.gov.uk/ConfirmVehicle?locale=en"
# req <- read_html(url)
# tab = html_table(req)
# tab = tab[sapply(tab, nrow) %in%  c(10,11,12,13,14)]
# tab = tab[[1]]
# #nodes = html_nodes(req, xpath = "//html//body//div[1]//div[2]//div//div[1]//div[1]//div[3]//h1")
# nodes = html_nodes(req, xpath = "//html//body//div[1]//div[1]//div//div[1]//div[1]//div[2]//h1")
# txt = html_text(nodes)
# txt = strsplit(txt,"  ")[[1]][1]
# 
# naptan3$stop_name[i] <- txt
# naptan3$stop_code[i] <- tab$X2[tab$X1 == "Bus Stop NaptanCode:"]
# naptan3$stop_lon[i] <- tab$X2[tab$X1 == "Bus Stop Longitude:"]
# naptan3$stop_lat[i] <- tab$X2[tab$X1 == "Bus Stop Latitude:"]
#   
  
