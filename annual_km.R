# Summarise the annual km driven by a vehicle taking into account test times

ts <- tests[1:1000,]
ms <- main[,c("registration","firstUsedDate")]
ts <- dplyr::left_join(ts, ms, by = "registration")

annual_km_internal <- function(ts, ystart = 2005, yend = 2019){
  # exclude duplicated values
  ts <- ts[!duplicated(ts$odometerValue),]
  # convert to km
  ts$km <- ifelse(ts$odometerUnit == "mi", as.integer(round(ts$odometerValue * 1.60934)), ts$odometerValue)
  # order by date
  ts <- ts[order(ts$completedDate),]
  # check distance increase each year
  if(any(ts$km != ts$km[order(ts$km)])){
    stop("readings do not increase with each test")
  }
  ts_dates <- c(ts$firstUsedDate[1], as.Date(ts$completedDate))
  ts_km <- c(0L, ts$km)
  #ts_dkm <- ts_km[seq(2, length(ts_km))] - ts_km[seq(1, length(ts_km)-1)]
  #ts_dkm <- c(0,ts_dkm)
  ApproxFun <- approxfun(x = ts_dates, y = ts_km)
  Dates <- seq.Date(ymd(paste0(ystart,"-12-31")), ymd(paste0(yend,"-12-31")), by = "year")
  LinearFit <- ApproxFun(Dates)
  names(LinearFit) <- seq(ystart, yend)
  lf_off <- c(0, LinearFit[seq(1, length(LinearFit) - 1)])
  lf_off[is.na(lf_off)] <- 0
  akm <- LinearFit - lf_off
  
  return(LinearFit)
  
}

ts <- ts[,c("registration","completedDate","odometerValue","odometerUnit")]
ts <- split(ts, ts$registration)
kms <- pbapply::pblapply(ts, annual_km_internal)
