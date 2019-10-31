anon_2015 <- readRDS("E:/Users/earmmor/OneDrive - University of Leeds/CREDS Data/MOT anoymised/clean/test_result_2015.Rds")
anon_2014 <- readRDS("E:/Users/earmmor/OneDrive - University of Leeds/CREDS Data/MOT anoymised/clean/test_result_2014.Rds")

anon_2015$vehicle_id <- as.numeric(anon_2015$vehicle_id)

sub_15 <- anon_2015[1:5,]
sub_14 <- anon_2014[anon_2014$vehicle_id %in% sub_15$vehicle_id,]
