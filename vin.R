
regs = readRDS("C:/Users/malco/OneDrive - University of Leeds/Data/CREDS Data/MOT API/attempt_2/part1/mot_tmp_main_btch_1.Rds")

url = "https://app.chipex.co.uk/api/lookup-reg/"
urls = paste0(url, regs$registration[1:10000])

results <- progressr::with_progress(vin_async(urls, ncores = 6))
resultsdf = RcppSimdJson::fparse(results, parse_error_ok = TRUE)
resultsdf = data.table::rbindlist(resultsdf, fill = TRUE)

vin_async <- function(urls, ncores){
  
  # Success Function
  otp_success <- function(res){
    p()
    data <<- c(data, rawToChar(res$content))
  }
  # Fail Function
  otp_failure <- function(msg){
    p()
    cat("Error: ", msg, "\n")
  }
  
  t1 <- Sys.time()
  
  pool <- curl::new_pool(host_con = ncores)
  data <- list()
  
  for(i in seq_len(length(urls))){
    curl::curl_fetch_multi(urls[i],
                           otp_success,
                           otp_failure ,
                           pool = pool)
  }
  p <- progressr::progressor(length(urls))
  curl::multi_run(timeout = Inf, pool = pool)
  t2 <- Sys.time()
  message("Done in ",round(difftime(t2,t1, units = "mins"),1)," mins")
  return(unlist(data, use.names = FALSE))
}



