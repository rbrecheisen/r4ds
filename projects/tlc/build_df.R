library(arrow)
library(dplyr)

build_df <- function(data_dir) {
  return(open_dataset(data_dir, format = "parquet"))
}