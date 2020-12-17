setwd("/home/tom/Dropbox/UML/Fall 2020/Bioinformatics/Research Project/Other Sequences/Homo Sapiens/coding_sequences_do_not_open")
library(keras)
library(abind)

file_list <- read.delim(file = "list_of_converted_fna.txt", header = FALSE)

imported_list <- vector(mode = "list", length = 10000)
for (i in 1:10000)
{
  imported_list[[i]] <- read.csv(file_list$V1[i], header = FALSE, skip = 1)
}

rm(file_list)
for (i in 1:length(imported_list))
{
  imported_list[[i]] <- imported_list[[i]][,-33]
}

j <- 0
for (i in 1:length(imported_list))
{
  if(nrow(imported_list[[i]]) >= 32 && sum(is.na(imported_list[[i]])) == 0)
  {
    j <- j + 1
  }
}

list_length <- j
imported_list_trimmed <- vector(mode = "list", length = list_length)
j <- 1
for (i in 1:length(imported_list))
{
  if(nrow(imported_list[[i]]) >= 32 && sum(is.na(imported_list[[i]])) == 0)
  {
    imported_list_trimmed[[j]] <- imported_list[[i]]
    j <- j + 1
  }
}

rm(imported_list, j)
## CHECK: They should both return 'integer(0)' ##
nulls <- sapply(imported_list_trimmed, is.null)
which(nulls)
nas <- sapply(imported_list_trimmed, is.na)
which(nas)
rm(nulls, nas)

data_array <- imported_list_trimmed[[1]]
for (i in 2:length(imported_list_trimmed))
{
  data_array <- abind(as.matrix(imported_list_trimmed[[i]]), data_array, rev.along=3)
  if (i %% 10 == 0)
  {
    percent <- (i/length(imported_list_trimmed)) * 100
    percent <- round(percent, digits = 0)
    cat(paste(percent, "%...\n", sep = ""))
  }
}

# saveRDS(data_array, file = "cds_fna_data_array.rds")
# data_array <- readRDS("cds_fna_data_array.rds")

data_array_raw <- unname(data_array)
x_train <- data_array_raw
y_train <- array(rep(0, times = nrow(data_array_raw)), dim = c(nrow(data_array_raw)))

