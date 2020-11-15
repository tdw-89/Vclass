library(keras)
## This creates a neural network model with a single convolution layer containing 1200 filters of
# size 2 x 11. Output is then sent through a global max-pooling layer, flattened, then classified
# using two dense layers.

model <- keras_model_sequential()

model %>% 
  layer_conv_2d(filters = 1200, kernel_size = c(2, 11), strides = c(1, 4), padding = "same", activation = "relu", data_format = "channels_last", input_shape = c(32, 32, 1)) %>%
  layer_global_max_pooling_2d(data_format = "channels_last") %>%
  layer_flatten() %>%
  layer_dense(units = 1000, activation = "relu") %>%
  layer_dense(units = 1, activation = "sigmoid")
 
summary(model)

# model %>% compile(optimizer = "adam", loss = "binary_crossentropy",
#   metrics = "accuracy")
 
# history <- model %>% fit(x = cifar$train$x, y = cifar$train$y, epochs = 10,
#   validation_data = unname(cifar$test), verbose = 2)