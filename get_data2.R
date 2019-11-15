# Ne method of getting data
source("../../ITSLeeds/motCarData/R/dl_pages.R")
test <- mot_dl_page(1, key = Sys.getenv("MOT_key"))
#res <- mot_dl_pages(pages = 1:98065, ncores = 8, dir = "F:/MOT_data", max_pages = 1000, recombine = FALSE)
res <- mot_dl_pages(pages = 83001:98065, ncores = 8, dir = "F:/MOT_data", max_pages = 1000, recombine = FALSE)

# failed on batch 69

# batches to check
# 25, 


# res_main <- res[[1]]
# res_tests <- res[[2]]
# res_comments <- res[[3]]
# 
# ids <- res_main$id
# ids <- strsplit(ids,"-")
# ids1 <- as.numeric(sapply(ids, function(x){x[1]}))
# ids2 <- as.numeric(sapply(ids, function(x){x[2]}))
# summary(ids1)
# length(unique(ids1))
# summary(ids2)
# length(unique(ids2))
# table(ids1)
