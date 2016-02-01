# Learning how to detect the quality of dumb bell lifting in real time

library(caret)
library(e1071)

# Reset the environment for reproducible results
rm(list=ls())
set.seed(42313)

# Load training, validation and test data
trainingAndValidationData = read.csv("pml-training.csv")
testingData = read.csv("pml-testing.csv")

trainingPartition = createDataPartition(trainingAndValidationData$classe, p = 0.3, list = FALSE)

trainingData = trainingAndValidationData[trainingPartition, ]
validationData = trainingAndValidationData[-trainingPartition, ]

# Random forest model
# Model based on all predictors takes a lot of time to compute (~10 minutes), and does not seem to produce valid predictions
# Simplified model based on user name + time stamp is fast and pretty darn accurate!
rfModel = train(classe ~ user_name + raw_timestamp_part_1 + raw_timestamp_part_2, trainingData, method = "rf")
rfValidationPrediction = predict(rfModel, newdata = validationData)
rfConfusionMatrix = confusionMatrix(rfValidationPrediction, validationData$classe)

# RPart 
rpartModel = train(classe ~ user_name + raw_timestamp_part_1 + raw_timestamp_part_2, trainingData, method = "rpart")
rpartValidationPrediction = predict(rpartModel, newdata = validationData)
rpartConfusionMatrix = confusionMatrix(rpartValidationPrediction, validationData$classe)

# GBM (Boosting)
gbmModel = train(classe ~ user_name + raw_timestamp_part_1 + raw_timestamp_part_2, trainingData, method = "gbm")
gbmValidationPrediction = predict(gbmModel, newdata = validationData)
gbmConfusionMatrix = confusionMatrix(gbmValidationPrediction, validationData$classe)

# Test support vector machine - generates 1964 predictions instead of 17658
svmModel = svm(classe ~ user_name + raw_timestamp_part_1 + raw_timestamp_part_2, data = trainingData)
svmValidationPrediction = predict(svmModel, newData = validationData)
#simplestSvmConfusionMatrix = confusionMatrix(simplestSvmValidationPrediction, validationData$classe)

# lda
ldaModel = train(classe ~ user_name + raw_timestamp_part_1 + raw_timestamp_part_2, trainingData, method = "lda")
ldaValidationPrediction = predict(ldaModel, newdata = validationData)
ldaConfusionMatrix = confusionMatrix(ldaValidationPrediction, validationData$classe)

#glm - Error in train.default(x, y, weights = w, ...) : Stopping
# glmModel = train(classe ~ user_name + raw_timestamp_part_1 + raw_timestamp_part_2, trainingData, method = "glm")
# glmValidationPrediction = predict(glmModel, newdata = validationData)
# glmConfusionMatrix = confusionMatrix(glmValidationPrediction, validationData$classe)

#lasso: Error: wrong model type for classification
#lassoModel = train(classe ~ user_name + raw_timestamp_part_1 + raw_timestamp_part_2, trainingData, method="lasso")

# Final test predictions:
rfTestPrediction = predict(rfModel, newdata = testingData)
gbmTestPrediction = predict(gbmModel, newdata = testingData)
rpartTestPrediction = predict(rpartModel, newdata = testingData)
ldaTestPrediction = predict(ldaModel, newdata = testingData)
svmTestPrediction = predict(svmModel, newdata = testingData)