library(keras)
library(tensorflow)
library(tibble)
library(forcats)
library(ROCR)

#setwd("C:/Users/eccwo/Dropbox/UML/Fall 2020/Bioinformatics/Research Project/MGHPCC/Algorithm_&_Data")
#setwd("C:/Users/eccwo/Dropbox/UML/Fall 2020/Bioinformatics/Research Project/Final Draft/")
# library(keras, lib.loc = "/home/tw40l/R_lib")
# use_python("/share/pkg/anaconda3/2019.03/bin/python3")

x_train <- readRDS(file = "x_train.rds")
y_train <- readRDS(file = "y_train.rds")

set.seed(30)

rand_set <- sample(1:nrow(x_train), replace = FALSE)
x_train <- x_train[rand_set,,,]
x_train <- array_reshape(x_train, dim = c(nrow(x_train), 32, 32, 1))
y_train <-y_train[rand_set,] 
x_test <- x_train[1:1000,,,]
y_test <- y_train[1:1000,]
x_train <- x_train[-(1:1000),,,]
y_train <- y_train[-(1:1000),]
x_train <- array_reshape(x_train, dim = c(nrow(x_train), 32, 32, 1))
x_test <- array_reshape(x_test, dim = c(nrow(x_test), 32, 32, 1))

model <- keras_model_sequential()

model %>% 
  layer_conv_2d(filters = 1200,
                kernel_size = c(2, 11),
                stride = 4, padding = "same",
                activation = "relu",
                data_format = "channels_last",
                input_shape = c(32, 32, 1)) %>%
  layer_global_max_pooling_2d(data_format = "channels_last") %>%
  layer_dropout(rate = 0.5) %>%
  layer_dense(units = 1000, activation = "relu") %>%
  layer_dense(units = 2, activation = "sigmoid")

summary(model)

epoch_number <- 100

opt1 = optimizer_adam(lr = .00001, decay = .00001/epoch_number)

model %>% compile(optimizer = opt1,
                  loss = "binary_crossentropy",
                  metrics = "accuracy")

history <- model %>% fit(x_train, y_train,
                         batch_size = 15,
                         epochs = epoch_number,
                         validation_split = 0.2)
print(plot(history))

model %>% save_model_tf("model")

results <- model %>% evaluate(x_test, y_test, verbose = 0)
print(results)
predictions <- model %>% predict(x_test)
class_predictions <- model %>% predict_classes(x_test)

prediction_data <- tibble(
  truth      = as.factor(y_test[,2]) %>% fct_recode(yes = "1", no = "0"),
  estimate   = as.factor(class_predictions) %>% fct_recode(yes = "1", no = "0"),
  class_prob = predictions[,2]
)
confusion_matrix <- prediction_data %>% conf_mat(truth, estimate)

pred <- prediction(predictions = predictions[,1], labels = y_test[,1])
perf <- performance(pred, "tpr", "fpr")
plot(perf, avg="threshold", lwd= 3,
     main= "Receiver Operating Characteristic")
model_auc <- performance(pred, measure = "auc")
model_auc <- model_auc@y.values[[1]]

perf2 <- performance(pred, "prec", "rec")
plot(perf2, avg= "threshold", lwd= 3, main= "Precision vs .Recall")
