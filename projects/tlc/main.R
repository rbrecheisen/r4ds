source("projects/tlc/install_packages.R")
source("projects/tlc/download_tlc_data.R")
source("projects/tlc/build_df.R")

data_dir <- "D:/r4ds/tlc"

#download_tlc_data(data_dir)
df <- build_df(data_dir)