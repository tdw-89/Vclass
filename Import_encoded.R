## Author: Tom Wolfe
##
## Purpose: Import .fsa files encoded with nucleotide letters changed to either 0.0 (N),
## 0.25 (A), 0.50 (G), 0.75 (C), or 1.00 (T), per the 'fsa_encoder' executable.
## 
## Planned improvements:
## > Change for-loops to something more efficient (especially the one on line 55!)
## > Combine with 'import_encoded_fna' to add human sequences to training set.
## > 

setwd("/home/tom/Dropbox/UML/Fall 2020/Bioinformatics/Research Project/Viral Sequences/NCBI_refseq_genomes/unzipped2")
library(keras)
library(abind)
file_list <- read.delim(file = "list_of_converted_files.txt", header = FALSE)

imported_list <- vector(mode = "list", length = nrow(file_list))
for (i in 1:nrow(file_list))
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

## proof that the two data sets are just in reverse order:
count <- 0
count2 <- 0
for(n in length(imported_list_trimmed))
{
  diff <- as.vector(data_array[(1539-count),,]==imported_list_trimmed[[1+count]])
  if(sum(diff) != 1024)
  {
    count2 <- count2 + 1
  }
}
cat(paste("There are this many that do not match: ", count2, sep = ""))
rm(imported_list_trimmed, count, count2, diff, i, list_length, n, percent)

## to make an array of training data, use x_train <-
## to create a matrix of training data labels, use y_train <- 

# x_train_test <- mnist$train$x
# x_train_test_reshape <- array_reshape(x_train_test, c(nrow(x_train_test), 784))







